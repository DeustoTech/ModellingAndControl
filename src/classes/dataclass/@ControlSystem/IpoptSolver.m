function p0 = IpoptSolver(ics,FLoss,Inputs,Outputs,p,varargin)



pIn = inputParser;
addRequired(pIn,'FLoss')
addRequired(pIn,'Inputs')
addRequired(pIn,'Outputs')

addOptional(pIn,'p0',[]);
addOptional(pIn,'miniBatchSize',10);

parse(pIn,FLoss,Inputs,Outputs,varargin{:})

p0 = pIn.Results.p0;

if isempty(p0)
    p0 = zrand(size(p.all));
end

for i = 1:10
ind = randsample(9265,50,true);
newInputs   = Inputs(ind,:);
newOutputs  = Outputs(ind,:);

%
nlp = struct('x',p.all, 'f',mean(FLoss(newInputs',newOutputs',p.all)), 'g',[]);
opt = struct('ipopt',struct('max_iter',5));
S = casadi.nlpsol('S', 'ipopt', nlp,opt);
r = S('x0',p0);

opt_params = r.x;
p0 = opt_params;
end

end

