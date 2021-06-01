function [Fpred,opt_params] = MultiLayerPercep(ics,varargin)
%NN

p = inputParser;
addRequired(p,'ics')
addOptional(p,'opts',{});

parse(p,ics,varargin{:})

opts = p.Results.opts;

%%
Nin  = ics.Nin + ics.Ndis;
Nout = ics.Nout;
%
NNeurons = 2*Nin;
NLayers = 2;

[F_sym,in_sym,out_sym,p] = MultiLayer(Nin,NNeurons,NLayers,Nout);
%%
model  = F_sym(in_sym,p.all);
loss  = (model - out_sym)'*(model - out_sym);
%
FLoss = casadi.Function('loss',{in_sym,out_sym,p.all},{loss});
%
%
[Inputs,Outputs] = GenData(ics);


opt_params =  momentumGD(FLoss,Inputs',Outputs',in_sym,out_sym,p.all,opts{:});
%

Fpred = casadi.Function('Fmodel',{in_sym,p.all},{model});

%

end

