function [F_sym,in_sym,out_sym,p] = MultiLayer(NInput,NNeurons,NLayers,NOutput)

[w,b,params] = BuildLearneableParams(NInput,NNeurons,NLayers,NOutput);
%% Define input sym
import casadi.*

in_sym = SX.sym('x',[NInput,1]);
out_sym = SX.sym('yT',[NOutput,1]);

%% Define Model  of dynamic - multilayer perceptron 
sigma = @(x) x.*(0.5+0.5*tanh(x));

dxt_sym = in_sym;
for il = 1:NLayers+1
    dxt_sym = sigma(w{il}*dxt_sym + b{il});
end
il = il + 1;
dxt_sym = w{il}*dxt_sym + b{il};

F_sym = casadi.Function('F',{in_sym,params},{dxt_sym});

p.all = params;
p.wights  = w;
p.bias  = b;

end

