function   iNARX = train(iNARX,ics,varargin)

%% Set Params
p = inputParser;
addRequired(p,'iNARX')
addRequired(p,'ics')
addOptional(p,'opts',{})

parse(p,iNARX,ics,varargin{:})

opts = p.Results.opts;

%% Build symbolical NN
%%
%
%
loss       = iNARX.loss;
FLoss      = loss.Fcn;
in_sym     = loss.in_sym;
out_sym    = loss.out_sym;
sym_params = iNARX.params.sym;

%
[Inputs,Outputs] = GenData(iNARX,ics,'DeltaOutput',1);
%
Outputs = (Outputs - iNARX.mn)./iNARX.st;
%
p0 = iNARX.params.num;
dLoss = loss.dLoss;
miniBatchSize = loss.miniBatchSize;
%%

iNARX.params.num =  momentumGD(FLoss,Inputs,Outputs,in_sym,out_sym,sym_params,dLoss,miniBatchSize,'p0',p0,opts{:});

%% Define the model




end

