function   [Fpred,opt_params] = LinearSystem(ics,varargin)

p = inputParser;
addRequired(p,'ics')
addOptional(p,'opts',{});

parse(p,ics,varargin{:})

opts = p.Results.opts;

%%

%%
A_sym = casadi.SX.sym('A',ics.Nout,ics.Nout);
B_sym = casadi.SX.sym('B',ics.Nout,ics.Nin);
C_sym = casadi.SX.sym('C',ics.Nout,ics.Ndis);

params = [A_sym(:);B_sym(:);C_sym(:)];
%
xsym = casadi.SX.sym('xsym',ics.Nout,1);
usym = casadi.SX.sym('usym',ics.Nin,1);
dsym = casadi.SX.sym('dsym',ics.Ndis,1);
%
out_sym = casadi.SX.sym('xsym_out',ics.Nout,1);
%
%%

model  = xsym + 0.1*(A_sym*xsym + B_sym*usym + C_sym*dsym);

in_sym = [usym(:); xsym(:);dsym(:)];
Fpred = casadi.Function('Fmodel',{in_sym,params},{model});

loss  = (model - out_sym)'*(model - out_sym) ;
%
FLoss = casadi.Function('loss',{in_sym,out_sym,params},{loss});
%
[Inputs,Outputs] = GenNARXData(ics);
%
opt_params =  momentumGD(FLoss,Inputs,Outputs,in_sym,out_sym,params,opts{:});
%opt_params = IpoptSolver(ics,FLoss,Inputs,Outputs,p,opts{:});


end

