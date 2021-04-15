
clear
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset01.mat','ds','full')
%%

full.VarName1 = datetime(full.VarName1);
full.Properties.VariableNames{1} = 'DateTime';
%
%%
for i=2:7
    ds{i}.VarName1 = datetime(ds{i}.VarName1);
    ds{i}.Properties.VariableNames{1} = 'DateTime';
end
%%
iTs = TableSeries(ds{5});

dt = 10;
iTs = UniformTimeStamp(iTs,'DT',minutes(dt));

%
Tinv = iTs.DataSet.Tinv  ;
%
clf
fft_fcn(Tinv,iTs.DateTime,dt,1e3)
xlim([0 0.002])
%%

%%

