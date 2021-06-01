function   iNARX = compile(iNARX,ics,varargin)

%% Set Params
p = inputParser;
addRequired(p,'iNARX')
addRequired(p,'ics')
addOptional(p,'MiniBatchSize',10)

parse(p,ics,varargin{:})

MiniBatchSize = p.Results.MiniBatchSize;

No   = iNARX.No;
Nin  = ics.Nin + ics.Ndis + No*ics.Nout;
Nout = ics.Nout;
%
NNeurons = iNARX.NHNFactor*Nin;
NLayers = iNARX.NLayers;
%% Build symbolical NN
[F_sym,in_sym,out_sym,p] = MultiLayer(Nin,NNeurons,NLayers,Nout);
%%

xnext  = F_sym(in_sym,p.all);

%%

u_sym = in_sym(      1              : ics.Nin            );
x_sym = in_sym( (ics.Nin+1)         : (ics.Nin+Nout*No) );
d_sym = in_sym( (ics.Nin+Nout*No+1) : end           );

ind_sym = arrayfun(@(i)x_sym(1+(i-1)*ics.Nout:i*ics.Nout)',1:iNARX.No-1,'UniformOutput',0);


step_model = casadi.Function('step_model',{x_sym,u_sym,d_sym},{[xnext ;[ind_sym{:}]']});


Nt = iNARX.Nt;

roll_model = step_model.mapaccum(Nt);
%
%%
ut_sym = casadi.SX.sym('ut',ics.Nin,Nt);
dt_sym = casadi.SX.sym('dt',ics.Ndis,Nt);
%%
in_sym_new = [x_sym(:);ut_sym(:);dt_sym(:)];
out_sym_new = casadi.SX.sym('xt',ics.Nout,Nt);
out_sym_new = out_sym_new(:);
%%
xt_sym = roll_model(x_sym,ut_sym,dt_sym);
xt_sym = xt_sym(1:ics.Nout,:);
%%
%
loss  = norm(xt_sym(:) - out_sym_new);
%
FLoss = casadi.Function('loss',{in_sym_new,out_sym_new,p.all},{loss});
%
%%
%

[fdLoss,miniBatchSize] =  BuilddLoss(FLoss,in_sym_new,out_sym_new,p.all,'MiniBatchSize',MiniBatchSize);

iNARX.loss.dLoss         = fdLoss;
iNARX.loss.miniBatchSize = miniBatchSize;

%% Define the model
u_sym = in_sym(      1              : ics.Nin            );
x_sym = in_sym( (ics.Nin+1)         : (ics.Nin+Nout*No) );
d_sym = in_sym( (ics.Nin+Nout*No+1) : end           );

iNARX.model.Fcn = casadi.Function('Fmodel',{x_sym,u_sym,d_sym,p.all},{xnext});
iNARX.params.sym = p.all;
iNARX.params.num = zrand(size(p.all));
iNARX.model.sym.u = u_sym;
iNARX.model.sym.x = x_sym;
iNARX.model.sym.d = d_sym;

%
iNARX.loss.Fcn = FLoss;
iNARX.loss.in_sym  = in_sym;
iNARX.loss.out_sym = out_sym;

end

