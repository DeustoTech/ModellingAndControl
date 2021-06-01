clear 
rng(0)
Nt = 1000;
T  = 20;
N  = 4;
tspan = linspace(0,T,Nt);
dt = tspan(2)-tspan(1);
A = -0.5*eye(N);
A(1,2) = 0.5;
A(2,1) = 0.5;

B = 0.1*rand(N);

ut = -10*sin(pi*tspan.*rand(N,1));

u_fcn = @(t) interp1(tspan,ut',t)';

x0 = rand(N,1);

[~,xt] = ode45(@(t,x) A*x+B*u_fcn(t),tspan,x0);%
%

xvars = repmat("x",N,1)+(1:N)';
uvars = repmat("u",N,1)+(1:N)';

%%
ds = [];
%
i = 0;
for ivar = xvars' 
    i = i + 1;
    ds.(ivar) = xt(:,i);
end 
i = 0;
for ivar = uvars' 
    i = i + 1;
    ds.(ivar) = ut(i,:)';
end 

%%
ds.DateTime = (datetime+minutes(tspan))';
iTs = TableSeries(struct2table(ds));
iTs = UniformTimeStamp(iTs,minutes(dt));
%%
clf
ShowData(iTs)
%%
OutputVars = arrayfun(@(i) char(xvars(i)),1:4,'UniformOutput',0);
InputVars = arrayfun(@(i) char(uvars(i)),1:4,'UniformOutput',0);
DisturbanceVars = {};
ics = ControlSystem(iTs,InputVars,DisturbanceVars,OutputVars);
%%
[mu_vars,std_vars] = NormalizeData(ics);

no_ics = ics;
ics = SetNormalization(ics,mu_vars,std_vars);
%%
%iNARX = NARX_norm('No',2);
iNARX = NARX('No',2);

iNARX = compile(iNARX,ics,'miniBatchSize',32);
%%
figure(4)
opts = {'LR',1e-2,'MaxIter',10000};
iNARX = train(iNARX,ics,'opts',opts);
%iNARX = train(iNARX,ics,'opts',opts);

%%

%%
ind = 1;
figure(1)
CloseLoopComparison(iNARX,ics,'ind',ind,'OutGroups',{1,2,3},'Nt',0800,'DisGroups',{},'InGroups',{1,2,3})
