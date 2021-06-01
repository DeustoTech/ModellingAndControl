clear  all
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/Ts_sysclima_02.mat')
%%
%clf
%xlim = [datetime('2016-09-19') datetime('2016-09-30')];
%ShowData(iTs,'xlim',xlim)

iTs = RemoveVars(iTs,'verbose',1,'rmvars',{'AlarmaLluvia','AlarmaVto'});
iTs = cut(iTs,minutes(30));
iTs = UniformTimeStamp(iTs,'DT',minutes(2));
iTs = MediaMovil(iTs,5);
%
iTs = UniformTimeStamp(iTs,'DT',minutes(30));

%iTs = iTs(1:4);
%%
StateVars  = {'EstadoCenitalE','EstadoCenitalO','EstadoPant1'};
Disturbances = {};
ControlVars    = {'HRInt','RadInt','Tinv'};
ics = ControlSystem(iTs,ControlVars,Disturbances,StateVars); 
%%
%%

[mu_vars,std_vars] = NormalizeData(ics);
%%
ics = SetNormalization(ics,mu_vars,std_vars);

%%
No = 3;

iNARX = NARX('No',No);
%iNARX.Nt = 3;
%iNARX = NARX('No',No);

%%
figure(4)

opts = {'LR',1e-6,'MaxIter',2000,'miniBatchSize',16};
iNARX = train(iNARX,ics,'opts',opts);

%%
figure(1)
ind = 3;
%NARX_Multi_OpenLoop_Comparison(ics,3,ind,pred,opt_params,{1,2,3},{1,2,3})
OpenLoopComparison(iNARX,ics,'ind',ind,'OutGroups',{1,2,3},'InGroups',{1,2,3})
%%
ind = 3;
figure(2)

%xlims = [datetime('2018-11-07') datetime('2018-11-09')];
xlims = [];
%NARX_Multi_CloseLoop_Comparison(ics,no,ind,pred,opt_params,96,{1,2,3},{1,2,3,4})
CloseLoopComparison(iNARX,ics,'ind',ind, ...
                              'OutGroups',{1,2,3},   ...
                              'Nt',[],               ...
                              'init',[],             ...
                              'DisGroups',{1,2,3,4}, ...
                              'InGroups',{1,2,3},    ...
                              'xlim',xlims)



%%
savepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A003_Modelling/output/model01mat';

save(savepath)

