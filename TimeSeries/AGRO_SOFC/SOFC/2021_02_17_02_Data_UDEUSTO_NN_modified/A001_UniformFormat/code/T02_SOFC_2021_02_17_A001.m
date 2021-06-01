%%
% Pre Procesing Second Batch
%%
clear all
load("" + MainPath + 'TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/dataset.mat')
pathfolder = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/papers/SOFC-Cell-Modelling-Paper/img/';

%%
dataset01 = [dataset{:}];
dataset01 = Concat(dataset01);
dataset01 = Sort(dataset01);
dataset01 = RemoveRepeatMs(dataset01);
%%
fig = figure('unit','norm','pos',[0 0 0.5 0.5]);
%ShowData(dataset01,'window',100)
ShowDataSelect(dataset01,{1,2,3,4,[5:10 19],11,12:18,20:21},'window',100)
%%
pathfile =  pathfolder+"showdata_singlecell_secondbatch.eps";
print(fig,'-depsc',pathfile)
% 
%%
pathfile =  pathfolder+"dt_singlecell_secondbatch.eps";
fig = figure('unit','norm','pos',[0 0 0.4 0.5]);
%
ShowDiffTspan(dataset01);

print(fig,'-depsc',pathfile)
%%
close all
dataset01 = cut(dataset01,minutes(5));
%%
fig = figure('unit','norm','pos',[0 0 0.4 0.5]);
fig.Renderer = 'painters';
ShowDiffTspan(dataset01,'window',100);
pathfile =  pathfolder+"dt_singlecell_secondbatch_split.eps";
print(fig,'-depsc',pathfile)

%%
for i = 1:length(dataset01)
    fprintf("\\item ("+datestr(dataset01(i).DateTime(1),'')+") - ("+string(dataset01(i).DateTime(end))+")\n")
end
%%
dataset02 = RemoveRowsNan(dataset01);
%%
dataset03 = UniformTimeStamp(dataset02,'DT',minutes(2));
%%
savepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/dataset03.mat';
save(savepath,'dataset03')
%%

ControlVars  = {'T_Oven01','H2O_tar','CH4_tar','CO2_tar','H2_tar','CO_tar','N2_tar','Air_tar'};

Disturbances = {'i_real_perA'};

StateVars = { 'V_act'  ,  ...
              'v_H2_act' ,'v_CO_act', 'v_CO2_act', ...
              'v_CH4_act', 'v_O2_act','v_O2_cath','v_N2_act'};
%
%%

vars = [ControlVars(:)' Disturbances(:)' StateVars(:)'];

for i = 1:9
    dataset05(i).DataSet = dataset05(i).DataSet(:,vars);
end
%%
ics = ControlSystem(dataset05,ControlVars,Disturbances,StateVars);
%
save("" + MainPath + 'TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/cs01.mat','ics')
