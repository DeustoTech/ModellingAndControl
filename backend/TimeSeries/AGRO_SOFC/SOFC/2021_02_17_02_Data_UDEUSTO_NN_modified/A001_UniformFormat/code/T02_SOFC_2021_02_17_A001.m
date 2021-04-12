clear all
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/dataset.mat')

%%
dataset01 = [dataset{:}];
%
%%
dataset02 = RemoveRowsNan(dataset01);
%%
dataset03 = UniformTimeStamp(dataset02,'DT',minutes(5));
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
    dataset03(i).DataSet = dataset03(i).DataSet(:,vars);
end
%%
ics = ControlSystem(dataset03,ControlVars,Disturbances,StateVars);
%
save('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/cs01.mat','ics')
