clear 
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/dataset.mat')

%%
dataset = [dataset{:}];
%%
ShowData(dataset(5));