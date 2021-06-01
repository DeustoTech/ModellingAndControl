function   iNARX = compile(iNARX,ics,varargin)

%% Set Params
p = inputParser;
addRequired(p,'iNARX')
addRequired(p,'ics')
addOptional(p,'MiniBatchSize',10)

parse(p,iNARX,ics,varargin{:})

MiniBatchSize = p.Results.MiniBatchSize;
%%

No   = iNARX.No;
Nin  = ics.Nin + ics.Ndis + No*ics.Nout;
Nout = ics.Nout;
%
NNeurons = iNARX.NHNFactor*Nin;
NLayers = iNARX.NLayers;
%% Build symbolical NN
[F_sym,in_sym,out_sym,p] = MultiLayer(Nin,NNeurons,NLayers,Nout);
%%
u_sym = in_sym(      1              : ics.Nin            );
x_sym = in_sym( (ics.Nin+1)         : (ics.Nin+Nout*No) );
d_sym = in_sym( (ics.Nin+Nout*No+1) : end           );
%

pred  = F_sym(in_sym,p.all);
%
loss  = (pred - out_sym)'*(pred - out_sym);
%
FLoss = casadi.Function('loss',{in_sym,out_sym,p.all},{loss});
%
%%
[~,Outputs] = GenData(iNARX,ics,'DeltaOutput',1);
%
iNARX.mn  = mean(Outputs,2);
iNARX.st  = std(Outputs,[],2);
% 
%Outputs = (Outputs - mn)./st;

%%
[fdLoss,miniBatchSize] =  BuilddLoss(FLoss,in_sym,out_sym,p.all,'MiniBatchSize',MiniBatchSize);

iNARX.loss.dLoss         = fdLoss;
iNARX.loss.miniBatchSize = miniBatchSize;

%% Define the model

iNARX.model.Fcn = casadi.Function('Fmodel',{x_sym,u_sym,d_sym,p.all},{ x_sym(1:Nout) +  pred.*iNARX.st + iNARX.mn});
iNARX.model.sym.u  = u_sym;
iNARX.model.sym.x  = x_sym;
iNARX.model.sym.d  = d_sym;
iNARX.params.sym   = p.all;
iNARX.params.num   = zrand(size(p.all));
%
iNARX.loss.Fcn = FLoss;
iNARX.loss.in_sym  = in_sym;
iNARX.loss.out_sym = out_sym;

end

