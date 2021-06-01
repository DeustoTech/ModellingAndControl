clear
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/Ts_sysclima_02.mat')
%%
ShowData(iTs)
%%
iTs01 = RemoveVars(iTs, ...
                    'rmvars',{'AlarmaVto','AlarmaLluvia','EstadoCenitalE','EstadoCenitalO','EstadoPant1','Tinv','RadInt','HRInt'}, ...
                    'verbose',1);
%%
clf
ShowData(iTs01)
%%
iTs02 = cut(iTs01,minutes(60));
iTs03 = UniformTimeStamp(iTs02,'DT',minutes(5));
%%
ind = 4;
yt = iTs03(ind).DataSet{:,:};
%%
myt = mean(yt);
syt = std(yt);
%
yt = (yt - myt)./syt;

%% 

import casadi.*

N_y = 4;
N_h = 4;
Nt  = 200;
%
A = SX.sym('A',N_y,N_y);
B = SX.sym('B',N_y,N_h);
%

C = SX.sym('C',N_h,N_y);
D = SX.sym('D',N_h,N_h);
%
Omega = [A(:);B(:);C(:);D(:)];
%%
%

y0_sym = SX.sym('yt',N_y);
h0_sym = SX.sym('ht',N_h);
%%

f_y = casadi.Function('f_y',{[y0_sym(:);h0_sym(:)]},{[y0_sym(:);h0_sym(:)] + 0.1*([A*y0_sym + B*h0_sym;
%f_y = casadi.Function('f_y',{[y0_sym(:);h0_sym(:)]},{tanh([A*y0_sym + B*h0_sym;
                                                           C*y0_sym + D*h0_sym])});
%
%
rsym = f_y([y0_sym(:);h0_sym(:)]);
model = casadi.Function('model',{y0_sym,h0_sym,Omega},{rsym(1:N_y),rsym(N_y+1:end)});
%
%
F_y = f_y.mapaccum(Nt);
%
result = F_y([y0_sym; zeros(N_h,1)]);
result = result(1:N_y,:);
F_y_p = casadi.Function('Fyp',{Omega,y0_sym},{result});
%%
full_data = iTs03(3).DataSet{:,:};
%
mfull = mean(full_data);
sfull =  std(full_data);
%
full_data = (full_data - mfull)./sfull;
%

Nt_data = size(full_data,1);

ndata = 100;
iind = randsample(Nt_data-Nt-1,ndata,true);
eind  = iind + Nt - 1;

Input  = arrayfun(@(i) full_data(iind(i)-1,:)',1:ndata,'UniformOutput',0);
Output = arrayfun(@(i) full_data(iind(i):eind(i),:)',1:ndata,'UniformOutput',0);
%

%%
In_sym  = casadi.SX.sym('in',N_y,1);
Out_sym = casadi.SX.sym('out',N_y,Nt);

%%

FLoss = casadi.Function('FLoss', ...
                        {In_sym,Out_sym,Omega}, ...
                        { mean(mean((F_y_p(Omega,In_sym) - Out_sym).^2))});
%
dLoss = casadi.Function('dFLoss', ...
                        {In_sym,Out_sym,Omega}, ...
                        {gradient(FLoss(In_sym,Out_sym,Omega),Omega)});
%%
%omega0 = 1e-1*zrand(size(Omega));

 A0 = -0.0001*diag(rand(1,N_y));
 B0 = 0.001*zrand(N_y,N_h);
 C0 =  0.001*zrand(N_h,N_y);
 D0 = -0.0001*diag(rand(1,N_h));
% %
omega0 = [A0(:) ;B0(:); C0(:); D0(:)];
%
%
LR = 1e-2;
clf
ip = plot(0,0,'.-');
%%
vt = 0;
mt = 0;
beta1 = 0.99;
beta2 = 0.999;
epsilon = 1e-8;

%%
for it = 1:10000
    
    i = randsample(ndata,5);
    gt = dLoss(Input{i(1)},Output{i(1)},omega0);
    for jj = 2:5
        gt = gt + dLoss(Input{i(jj)},Output{i(jj)},omega0);
    end 
    gt = gt/5;
    %
    mt = beta1*mt + (1-beta1)*gt;
    vt = beta2*vt + (1-beta2)*gt.^2;
    %
    mt_hat = mt/(1-beta1^it);
    vt_hat = vt/(1-beta2^it);
    %
    omega0 = omega0 - LR*(beta1*mt_hat + gt.*(1-beta1)/(1-beta1^it) )./(sqrt(vt_hat)+epsilon);
    
    if mod(it,50) == 0
    L = FLoss(Input{i(1)},Output{i(1)},omega0);
    for jj = 2:5
        L = L + FLoss(Input{i(jj)},Output{i(jj)},omega0);
    end 
    L = L/5;

    ip.XData = [ip.XData it];
    ip.YData = [ip.YData full(L)];
    pause(0.01)
    end
end

%%
Nt_3 = 2005;
xt = zeros(N_y,Nt_3);
xt(:,1) = full_data(1,:);
ht = zeros(size(h0_sym,1),Nt_3);

for read_time = 1:50:700
%read_time = 20;
for it = 2:Nt_3
    if it < read_time
        [xs,hs] = model(full_data(it-1,:),ht(:,it-1),omega0);
        xt(:,it) = full_data(it,:);
        ht(:,it) = full(hs);
    else
        [xs,hs] = model(xt(:,it-1),ht(:,it-1),omega0);
        xt(:,it) = full(xs);
        ht(:,it) = full(hs);
    end
end

clf
subplot(3,1,1)
plot(xt')
xline(read_time,'LineWidth',3)
legend(iTs01.vars)
subplot(3,1,2)
plot(full_data(1:Nt_3,:))
legend(iTs01.vars)
subplot(3,1,3)

plot(ht')
pause(0.01)
end
