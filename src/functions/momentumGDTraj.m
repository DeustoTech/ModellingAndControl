function opt_params =  momentumGDTraj(Loss,ics,x_sym,yT_sym,params,varargin)

p = inputParser;
addRequired(p,'Loss')
addRequired(p,'Inputs')
addRequired(p,'Outputs')
addRequired(p,'x_sym')
addRequired(p,'yT_sym')
addRequired(p,'params')
addOptional(p,'p0',[]);
addOptional(p,'LR',1e-3);
addOptional(p,'MaxIter',1000);
addOptional(p,'miniBatchSize',10);

parse(p,Loss,ics,x_sym,yT_sym,params,varargin{:})

p0          = p.Results.p0;
LR          = p.Results.LR;
MaxIter     = p.Results.MaxIter;
miniBatchSize = p.Results.miniBatchSize;

%%
ntraj = length(ics.TableSeries);
%%
import casadi.*

dLoss = Function('dLoss', ...
                {x_sym,yT_sym}, ...
                {gradient(Loss(x_sym,yT_sym,params),params)});
%
dLoss = dLoss.map(miniBatchSize,'thread',10);
%
x_sym_mb = SX.sym('x',[length(x_sym),miniBatchSize]);
y_sym_mb = SX.sym('y',[length(yT_sym),miniBatchSize]);

dLossFcn = casadi.Function('dLoss', ...
                                {x_sym_mb,y_sym_mb,params},...
                                {dLoss(x_sym_mb,y_sym_mb)});


dLossFcn.generate('dLoss.c')
system('gcc -fPIC -shared dLoss.c -o dLoss.so')
fdLoss = external('dLoss', './dLoss.so');

%%
if isempty(p0)
    p0 = (0.5-rand(size(params)));
end
clf
hold on

vt = 0;
mt = 0;
beta1 = 0.99;
beta2 = 0.999;
ip = plot(0,0,'.-');


indexs = arrayfun(@(i)randsample(ntraj,ntraj,false),1:MaxIter,'UniformOutput',false);
indexs =[indexs{:}]';

epsilon = 1e-8;
for it = 1:MaxIter
    ind = indexs(it,:);
    miniBacth = Inputs(ind,:)';
    ytargets  = Outputs(ind,:)';
    gt = mean(fdLoss(miniBacth,ytargets,p0),2);

    %
    mt = beta1*mt + (1-beta1)*gt;
    vt = beta2*vt + (1-beta2)*gt.^2;
    %
    mt_hat = mt/(1-beta1^it);
    vt_hat = vt/(1-beta2^it);
    %
    p0 = p0 - LR*(beta1*mt_hat + gt.*(1-beta1)/(1-beta1^it) )./(sqrt(vt_hat)+epsilon);
    
    if mod(it,100) == 0
        ip.XData = [ip.XData it];
        ip.YData = [ip.YData log(full(mean(Loss(miniBacth,ytargets,p0))))];
        pause(0.001)
    end
end
opt_params = p0;

end

