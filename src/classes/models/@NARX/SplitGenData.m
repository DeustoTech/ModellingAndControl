function r = SplitGenData(iNARX,ics,varargin)

p = inputParser;

addRequired(p,'ics')
addOptional(p,'ind',[]);
addOptional(p,'Nt',[]);
addOptional(p,'init',1);

parse(p,ics,varargin{:})

ind = p.Results.ind;

Nt = p.Results.Nt;
init = p.Results.init;

%%
Nt = Nt + init - 1;
%%
%
Nin  = ics.Nin;
Nout = ics.Nout;
No   = iNARX.No;
Ndis = ics.Ndis;

%%
if isempty(Nt)
    Nt = ics.TableSeries(ind).ndata-No;
end

%
[Inputs,Outputs,tspan,DateTime] = GenData(iNARX,ics,'ind',ind,'Nt',Nt);


%%

udata = Inputs(1:Nin,init:Nt);
xdata = Inputs((1+Nin):(Nin+Nout*No),init:Nt);
ddata = Inputs((1+Nin+Nout*No):(Nin+Nout*No+Ndis),init:Nt);
%
r.Input         = udata;
r.Output        = Outputs(:,init:Nt);
r.OutputDelays  = xdata;
r.Disturbances  = ddata;
r.tspan         = tspan(init:Nt)' - tspan(init);
r.DateTime      = DateTime(init:Nt)';
end


