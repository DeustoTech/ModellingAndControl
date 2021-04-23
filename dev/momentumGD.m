function opt_params =  momentumGD(Loss,Inputs,Outputs,x_sym,yT_sym,params)
%%
ndata = size(Outputs,1);
%%
import casadi.*
dLoss = casadi.Function('dLoss', ...
                        {x_sym,yT_sym,params}, ...
                        {gradient(Loss(x_sym,yT_sym,params),params)});
                    
%%
dLoss.generate('dLoss.c')
!gcc -fPIC -shared dLoss.c -o dLoss.so

file_dLoss = external('dLoss', './dLoss.so');

%%
p0 = (0.5-rand(size(params)));

clf
hold on

vt = 0;
alpha = 0.1;
beta = 0.50;

ip = plot(0,0,'.-');

for it = 1:20000
    ind = randsample(ndata,2,false);
    miniBacth = Inputs(ind,:)';
    ytargets  = Outputs(ind,:)';
    
    gt = mean(file_dLoss(miniBacth,ytargets,p0),2);
    vt = beta*vt + (1-beta)*gt;
    p0 = p0 - (alpha/it^(1/3))*vt;
    
    if mod(it,500) == 0
        ip.XData = [ip.XData it];
        ip.YData = [ip.YData full(mean(Loss(miniBacth,ytargets,p0)))];
        pause(0.001)
    end
end
opt_params = p0;

end

