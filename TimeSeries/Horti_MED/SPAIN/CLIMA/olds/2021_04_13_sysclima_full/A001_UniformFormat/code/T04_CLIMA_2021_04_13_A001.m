
clear all
load("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset02.mat')
%%
newTs = Concat(iTs_list);

ind = (newTs.DateTime > datetime('2016-08-10')).*(newTs.DateTime < datetime('2016-08-14'));
ind = logical(ind);
newTs = subselect(newTs,ind);
%%
clf
ShowData(newTs)