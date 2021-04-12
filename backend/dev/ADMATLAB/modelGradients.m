function [y,grad] = modelGradients(x,ytargets,params)
    

y = mse(ytargets,model(x,params)) + 0.0001*l2(params);
grad = dlgradient(y,params);



end