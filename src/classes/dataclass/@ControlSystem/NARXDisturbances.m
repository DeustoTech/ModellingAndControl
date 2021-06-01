function   [Fpred,opt_params] = NARXDisturbances(ics,varargin)

p = inputParser;
addRequired(p,'ics')
addOptional(p,'opts',{});

parse(p,ics,varargin{:})

opts = p.Results.opts;


Nin  = ics.Ndis;
Nout = ics.Ndis;
%
NNeurons = Nin;
NLayers = 2;

[F_sym,in_sym,out_sym,p] = MultiLayer(Nin,NNeurons,NLayers,Nout);
%%

pred  = F_sym(in_sym,p.all);

Fpred = casadi.Function('Fmodel',{in_sym,p.all},{pred});

loss  = (pred - out_sym)'*(pred - out_sym);
%
FLoss = casadi.Function('loss',{in_sym,out_sym,p.all},{loss});
%
[Inputs,Outputs] = GenNARXDataDisturbances(ics);
%
opt_params =  momentumGD(FLoss,Inputs,Outputs,in_sym,out_sym,p.all,opts{:});
%opt_params = IpoptSolver(ics,FLoss,Inputs,Outputs,p,opts{:});


end

