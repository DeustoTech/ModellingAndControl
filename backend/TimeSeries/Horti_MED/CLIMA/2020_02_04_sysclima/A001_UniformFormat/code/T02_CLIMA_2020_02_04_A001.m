clear 
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_04_sysclima/A001_UniformFormat/output/dataset01.mat')
%
dataset01.VarName1 = datetime(dataset01.VarName1);
dataset01.Properties.VariableNames{1} = 'DateTime';
%%
dataset01 = dataset01(:,{'DateTime','Tinv','RadInt','HRInt','Text','RadExt','HRExt','Vviento','DireccinViento','AlarmaVto','AlarmaLluvia','EstadoCenitalO','EstadoCenitalE','EstadoPant1'});
dataset01.Time = dataset01.DateTime - dataset01.DateTime(1);
dataset01.RadExt = dataset01.RadExt*1e-3;
dataset01.RadInt = dataset01.RadInt*1e-3;

%%
bl1 = (datetime('03-Feb-2019 00:00:00') < dataset01.DateTime) .* ...
     (dataset01.DateTime < datetime('15-Feb-2019 00:00:00'));

dataset = dataset01(logical(bl1),:);

ndata = length(dataset.DateTime);
nend = floor(0.8*ndata);
dataset_train = dataset(1:nend,:);
dataset_test  = dataset(1+nend:end,:);

%
path =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_04_sysclima/A001_UniformFormat/output';


ControlVars = {'RadExt','Vviento','EstadoCenitalE','EstadoCenitalO','Text','HRExt','EstadoPant1'};
StateVars = {'Tinv','HRInt','RadInt'};
idd1 = Build_Iddata({dataset_train,dataset_test},ControlVars,StateVars);

save(fullfile(path,'traj_1.3.2_without_heater.mat'),'dataset','dataset_train','dataset_test','idd1')

%%

bl2 = (datetime('17-Feb-2019 00:00:00') < dataset01.DateTime) .* ...
     (dataset01.DateTime < datetime('28-Feb-2019 00:00:00'));

dataset = dataset01(logical(bl2),:);
%
ndata = length(dataset.DateTime);
nend = floor(0.8*ndata);
dataset_train = dataset(1:nend,:);
dataset_test  = dataset(1+nend:end,:);

%
path =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_04_sysclima/A001_UniformFormat/output';

%%
ControlVars = {'RadExt','Vviento','EstadoCenitalE','Text'};
StateVars = {'Tinv','HRInt','RadInt'};
idd1 = Build_Iddata({dataset_train,dataset_test},ControlVars,StateVars);
%%
save(fullfile(path,'traj_1.3.2_with_heater.mat'),'dataset','dataset_train','dataset_test','idd1')
