function   iNN = compile(iNN,ics,varargin)

%% Set Params
p = inputParser;
addRequired(p,'iNN')
addRequired(p,'ics')
addOptional(p,'MiniBatchSize',10)

parse(p,iNN,ics,varargin{:})

MiniBatchSize = p.Results.MiniBatchSize;
%%

Nin  = ics.Nin + ics.Ndis;
Nout = ics.Nout;
%
NNeurons = iNN.NHNFactor*Nin;
NLayers = iNN.NLayers;
%% Build symbolical NN
[F_sym,in_sym,out_sym,p] = MultiLayer(Nin,NNeurons,NLayers,Nout);
%%
u_sym = in_sym(      1              : ics.Nin            );
d_sym = in_sym( (ics.Nin+1) : end           );
%

pred  = F_sym(in_sym,p.all);
%
loss  = (pred - out_sym)'*(pred - out_sym);
%
FLoss = casadi.Function('loss',{in_sym,out_sym,p.all},{loss});
%

%%
[fdLoss,miniBatchSize] =  BuilddLoss(FLoss,in_sym,out_sym,p.all,'MiniBatchSize',MiniBatchSize);

iNN.loss.dLoss         = fdLoss;
iNN.loss.miniBatchSize = miniBatchSize;

%% Define the model

iNN.model.Fcn = casadi.Function('Fmodel',{u_sym,d_sym,p.all},{pred});
iNN.model.sym.u  = u_sym;
iNN.model.sym.d  = d_sym;
iNN.params.sym = p.all;
iNN.params.num = zrand(size(p.all));
%
iNN.loss.Fcn = FLoss;
iNN.loss.in_sym  = in_sym;
iNN.loss.out_sym = out_sym;

end

