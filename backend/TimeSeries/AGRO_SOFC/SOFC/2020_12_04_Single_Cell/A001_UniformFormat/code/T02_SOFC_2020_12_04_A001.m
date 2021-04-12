clear all

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset01.mat')
dataset01 = [dataset01{:}];
%% 0 Uniform Time Stamp

dataset02 = UniformTimeStamp(dataset01,'DT',minutes(2));

%% Media Movil
dataset03 = MediaMovil(dataset02,5);
%%
LinearCoor(dataset03)

%% 3 - Elegimos las entradas y salidas

ControlVars  = {'H2_act','Air_act'};

Disturbances = {'T_Oven_01'};

StateVars = { 'T_C_In'  , 'T_C_Out' ,               ...
              'i_act2'  , 'V_act'   ,               ...
              'v_H2_act', 'v_CO_act','v_CO2_act','v_CH4_act','v_O2_act'};
%%
ics = ControlSystem(dataset03,ControlVars,Disturbances,StateVars);
%%
save('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/cs01.mat','ics')

%%

