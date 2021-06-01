function r = SplitGenData(iNN,ics,varargin)

p = inputParser;

addRequired(p,'ics')
addOptional(p,'ind',[]);
addOptional(p,'Nt',[]);

parse(p,ics,varargin{:})

ind = p.Results.ind;
Nt = p.Results.Nt;

%
[Inputs,Outputs,tspan,DateTime] = GenData(iNN,ics,varargin{:});

% 
if isempty(Nt)
    Nt = length(tspan);
end
%
Nin  = ics.Nin;
Ndis = ics.Ndis;
%%

udata = Inputs(1:Nin,:);
ddata = Inputs((1+Nin):(Nin+Ndis),:);
%
r.Input = udata;
r.Output = Outputs;
r.Disturbances = ddata;
r.tspan  = tspan';
r.DateTime = DateTime';
end


