function opt_params =  momentumGD(Loss,Inputs,Outputs,x_sym,yT_sym,params,fdLoss,miniBatchSize,varargin)
import casadi.*

p = inputParser;
addRequired(p,'Loss')
addRequired(p,'Inputs')
addRequired(p,'Outputs')
addRequired(p,'x_sym')
addRequired(p,'yT_sym')
addRequired(p,'params')
%%
addOptional(p,'p0',[]);
addOptional(p,'LR',1e-3);
addOptional(p,'MaxIter',1000);

parse(p,Loss,Inputs,Outputs,x_sym,yT_sym,params,varargin{:})

p0              = p.Results.p0;
LR              = p.Results.LR;
MaxIter         = p.Results.MaxIter;
%%
Outputs = Outputs';
Inputs  = Inputs';
%%
ndata = size(Outputs,1);
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

xlabel('iterations')
title('log(Error)')
grid on

indexs = arrayfun(@(i)randsample(ndata,miniBatchSize,false),1:MaxIter,'UniformOutput',false);
indexs =[indexs{:}]';

epsilon = 1e-8;

err_m = 0;
beta = 0.99;
no_mean = true;
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
        
        err = log(full(mean(Loss(miniBacth,ytargets,p0))));
        ip.XData = [ip.XData it];
        ip.YData = [ip.YData err];
        
        if no_mean 
            ipm = plot(1,err,'r.-','LineWidth',2);
            err_m = err;
            no_mean = false;
        else
            ipm.XData = [ipm.XData it];
            err_m = beta*err_m + (1-beta)*err;
            ipm.YData = [ipm.YData err_m];
        end
        pause(0.001)
    end
end
opt_params = p0;

end

