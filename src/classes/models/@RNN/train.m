function   iNN = train(iNN,ics,varargin)

%% Set Params
p = inputParser;
addRequired(p,'iNN')
addRequired(p,'ics')
addOptional(p,'opts',{})

parse(p,iNN,ics,varargin{:})

opts = p.Results.opts;

%% Build symbolical NN
%%
%
%
loss       = iNN.loss;
FLoss      = loss.Fcn;
in_sym     = loss.in_sym;
out_sym    = loss.out_sym;
sym_params = iNN.params.sym;

%
[Inputs,Outputs] = GenData(iNN,ics);
%
%
p0 = iNN.params.num;
dLoss = loss.dLoss;
miniBatchSize = loss.miniBatchSize;
%%

iNN.params.num =  momentumGD(FLoss,Inputs,Outputs,in_sym,out_sym,sym_params,dLoss,miniBatchSize,'p0',p0,opts{:});

%% Define the model




end

