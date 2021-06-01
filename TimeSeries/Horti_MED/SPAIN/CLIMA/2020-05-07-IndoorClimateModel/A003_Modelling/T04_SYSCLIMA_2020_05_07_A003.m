clear  all
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/Ts_sysclima_02.mat')
%%
%clf
%xlim = [datetime('2016-09-19') datetime('2016-09-30')];
%ShowData(iTs,'xlim',xlim)

%iTs = RemoveVars(iTs,'verbose',1,'rmvars',{'AlarmaLluvia','AlarmaVto'});
iTs = cut(iTs,minutes(30));
iTs = UniformTimeStamp(iTs,'DT',minutes(2));
iTs = MediaMovil(iTs,5);
%
iTs = UniformTimeStamp(iTs,'DT',minutes(5));

%iTs = iTs(1:4);
%%
StateVars  = {'EstadoCenitalE','EstadoCenitalO','EstadoPant1'};
Disturbances = {};
ControlVars    = {'HRInt','RadInt','TVentilacin','AlarmaLluvia'};
ics = ControlSystem(iTs,ControlVars,Disturbances,StateVars); 
%%
%%

[mu_vars,std_vars] = NormalizeData(ics);

mu_vars.out = [0 0 0];
std_vars.out = [100 100 100];

%%
ics = SetNormalization(ics,mu_vars,std_vars);

%%
No = 3;

iNARX = NN();
%iNARX.Nt = 3;
%iNARX = NARX('No',No);
iNARX = compile(iNARX,ics,'MiniBatchSize',64);

%%
figure(4)

opts = {'LR',1e-3,'MaxIter',20000};
iNARX = train(iNARX,ics,'opts',opts);

%%
figure(1)
PlotPrediction(iNARX,ics,'ind',5,'OutGroups',{1,2,3},'InGroups',{1,2,3,4},'Nt',[])

%%
