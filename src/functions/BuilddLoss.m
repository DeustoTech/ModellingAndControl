function [fdLoss,MiniBatchSize] =  BuilddLoss(Loss,x_sym,yT_sym,params,varargin)

p = inputParser;
addRequired(p,'Loss')
addRequired(p,'x_sym')
addRequired(p,'yT_sym')
addRequired(p,'params')

addOptional(p,'MiniBatchSize',10);

parse(p,Loss,x_sym,yT_sym,params,varargin{:})

MiniBatchSize = p.Results.MiniBatchSize;
%%
import casadi.*

dLoss = Function('dLoss', ...
                {x_sym,yT_sym}, ...
                {gradient(Loss(x_sym,yT_sym,params),params)});
%
dLoss = dLoss.map(MiniBatchSize,'thread',10);
%
x_sym_mb = SX.sym('x',[length(x_sym),MiniBatchSize]);
y_sym_mb = SX.sym('y',[length(yT_sym),MiniBatchSize]);

dLossFcn = casadi.Function('dLoss', ...
                                {x_sym_mb,y_sym_mb,params},...
                                {dLoss(x_sym_mb,y_sym_mb)});

%

dLossFcn.generate('dLoss.c')
system('gcc -fPIC -shared dLoss.c -o dLoss.so')

fdLoss = external('dLoss', './dLoss.so');


end

