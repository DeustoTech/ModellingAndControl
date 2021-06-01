function [F_sym,in_sym,out_sym,params] = MultiLayer(NInput,NNeurons,NLayers,NOutput,varargin)


p = inputParser;

addRequired(p,'NInput');
addRequired(p,'NNeurons');
addRequired(p,'NLayers');
addRequired(p,'NOutput');

addOptional(p,'prefi',"")

parse(p,NInput,NNeurons,NLayers,NOutput,varargin{:})

prefi = p.Results.prefi;

    %%
[w,b,p_sym] = BuildLearneableParams(NInput,NNeurons,NLayers,NOutput,'prefi',prefi);
%% Define input sym
import casadi.*

in_sym = SX.sym('x',[NInput,1]);
out_sym = SX.sym('yT',[NOutput,1]);

%% Define Model  of dynamic - multilayer perceptron 
sigma = @(x) 0.5 + 0.5*tanh(x);

dxt_sym = in_sym;
for il = 1:NLayers+1
    dxt_sym = sigma(w{il}*dxt_sym + b{il});
end
il = il + 1;
dxt_sym = w{il}*dxt_sym + b{il};
%dxt_sym = sigma(dxt_sym);

F_sym = casadi.Function('F',{in_sym,p_sym},{dxt_sym});

params.all = p_sym;
params.wights  = w;
params.bias  = b;

end

