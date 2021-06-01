clear all
%
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics.mat')
%%
[mu_vars,std_vars] = NormalizeData(ics);
%mu_vars.out(2:end) = 0;
%std_vars.out(2:end) = 100;

%%
ics = SetNormalization(ics,mu_vars,std_vars);
%%
iNARX = NARX_norm;
%iNARX = NARX_LongTerm;
%iNARX.Nt = 10;

iNARX = compile(iNARX,ics,'MiniBatchSize',64);
%%

figure(4)
%
opts = {'LR',1e-2,'MaxIter',10000};
iNARX.params.num = 0.1*iNARX.params.num;

iNARX = train(iNARX,ics,'opts',opts);
%%
figure(3)
PlotPrediction(iNARX,ics,'ind',1,'InGroups',{1,2:6},'OutGroups',{1,2:5},'Nt',40,'normalize',0,'init',1)

%%
figure(5)
clf
ErrorPlotPrediction(iNARX,ics,'Nt',20)

%%
