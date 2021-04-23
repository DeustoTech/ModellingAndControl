clear  all
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_01_13_sysclima/A001_UniformFormat/output/dataset01.mat')
%%
dataset01.Properties.VariableNames{end} = 'DateTime';
%
iT01 = TableSeries(dataset01);
%%
%figure(1);
%clf 
%ShowData(iT01)
%
%% Removemos las columnas sin infromacion
%figure(1);
%clf
iT02 = RemoveVars(iT01);
%ShowData(iT02)
%% Temperatura Ext
figure(3);
clf
%LinearCoor(iT02,'alpha',0.95)
%%
rmvars = {'RadAcumExt','AlarmaLluvia','AlarmaVto','Aerotermo1Activo', ...
          'Troc_o','x_DemPan1','DPV','Sonda1','x_DemPant1','EstadoLateralE', ...
          'Sonda2','Sonda3','Sonda5','Sonda6','DeltaX','DeltaT','MaxHR_','TVentilaci_n'};
iT03 = RemoveVars(iT02,'rmvars',rmvars);
%figure(1);
%clf
%ShowData(iT03)
%%
InputVars   = {'EstadoCenitalE','EstadoCenitalO','x_EstadoPant1'};
OutputVars  = {'Tinv','RadInt','HRInt'};
DistVars    = {'Text','RadExt','V_viento','Direcci_nViento'};

%%
iT04 = UniformTimeStamp(iT03,'DT',minutes(2));
%%
ics = ControlSystem(iT04,InputVars,DistVars,OutputVars);
%%
save('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_01_13_sysclima/A001_UniformFormat/output/ics01.mat','ics')
