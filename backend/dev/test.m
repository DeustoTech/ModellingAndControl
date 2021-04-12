clear 
Nt = 50;
T  = 10;
%
tspan = linspace(0,T,Nt);

x0 = [1;0;0];
[~,xt] = ode45(@(t,x) dyn(x),tspan,x0);

%%

NInput = length(x0);
NOutput = NInput;
NLayers = 1;
NNeurons = 2;
%
[Fdxt_sym,x0_sym,out_sym,p] = MultiLayer(NInput,NNeurons,NLayers,NOutput);

%% Integrate the dynamic  
Tsym  = casadi.SX.sym('T');
xT = euler(Fdxt_sym,x0_sym,Tsym,p.all);
%% Build the model
model = casadi.Function('model',{[x0_sym;Tsym],p.all},{xT});
%% Generate Data

Nft = 10;
FinalTimeSpan = linspace(2,15,Nft);

Nx0 = 5;
x0Span        = rand(3,Nx0);
%
Inputs = zeros(4,2*Nft*Nx0);
Outputs = zeros(3,2*Nft*Nx0);

iter = 0;
for iFT = FinalTimeSpan
    for ix0 = x0Span
        itspan = linspace(0,iFT,Nt);
        [~,ixt] = ode45(@(t,x) dyn(x),itspan,ix0);
        iter = iter + 1;
        Inputs(:,iter)  = [ix0;iFT];
        Outputs(:,iter) = ixt(end,:)';
        %
        iter = iter + 1;
        Inputs(:,iter+1)  = [ixt(end,:)';iFT];
        Outputs(:,iter+1) = ixt(end,:)';

    end
end
%%
params0 = rand(size(p.all));

loss = sum((model(Inputs(:,1),params0) - Outputs(:,1)).^2);

for idata = 2:(2*Nft*Nx0)
    loss = loss + sum((model(Inputs(:,idata),p.all) - Outputs(:,idata)).^2);
end
%%
Floss = casadi.Function('Floss',{p.all},{loss});
%%

nlp = struct('x',p.all, 'f',Floss(p.all));

opt = struct('ipopt', ...
             struct('print_level',5, ...
                    'tol',1e-12, ...
                    'max_iter',800));

S = casadi.nlpsol('S', 'ipopt', nlp,opt);
%


r = S('x0',params0);
params_opt = r.x;

%%

tspan = linspace(0,T,2*Nt);

x0 =[rand(1,1);0;0];
[~,xt] = ode45(@(t,x) dyn(x),tspan,x0);
[~,xt_pred] = ode45(@(t,x) full(Fdxt_sym(x,params_opt)),tspan,x0);
%
figure(1)
clf

tit = {'A','B','C'};
for i = 1:3
    subplot(3,1,i)
    hold on
    %
    plot(tspan,xt_pred(:,i),'r.-');
    plot(tspan,xt(:,i),'b.-');
    %
    legend({'pred','real'})
    ylim([-1 1])
    yline(0)
    grid on
    title(tit{i})
end

%%

