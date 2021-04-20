function [y,grad] = modelGradients(x,ytargets,params)
    

y = mse(ytargets,model(x,params));
grad = dlgradient(y,params);


end