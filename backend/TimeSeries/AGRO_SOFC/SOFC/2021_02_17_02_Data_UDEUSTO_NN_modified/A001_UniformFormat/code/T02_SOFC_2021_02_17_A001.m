clear 
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/dataset.mat')

%%

Nvars = length(dataset.Properties.VariableNames);
%%
rm_ind  = arrayfun( @(i)length(unique(dataset{:,i})),1:Nvars) == 1;
dataset(:,rm_ind) = [];
dataset(:,[1 3 4]) = [];
dataset(:,[4]) = [];

Nvars = length(dataset.Properties.VariableNames);

%%
dataset = sortrows(dataset,1);
%%
%dataset = UniformTimeStamp(dataset,'DT',minutes(2));
plot(dataset.DateTime,dataset.V_act,'.-')%%