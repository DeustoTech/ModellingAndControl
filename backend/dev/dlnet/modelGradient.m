function [y,grad] = modelGradient(x,ytargets,params)
    
ypred = model(x,params);
y = mse(ytargets,ypred) ;
grad = dlgradient(y,params);

end