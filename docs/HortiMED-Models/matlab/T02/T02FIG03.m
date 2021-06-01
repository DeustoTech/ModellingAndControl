% Dado que el Grafo de correlaciones de variables 
% Veamos algunas de las corelaciones mas grandes 
% que hemos visto en el grafo del script T02FIG03
%
clear 

load("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset02.mat')
 
%%
newTs = Concat(iTs_list);
newTs = RemoveRowsNan(newTs);
newTs = RemoveVars(newTs,'verbose',1);
newTs = UniformTimeStamp(newTs,minutes(50));
%%
clf
subplot(2,1,1)
plot(newTs.DateTime,  newTs.DataSet.DemPant1)
xlim([datetime('2016-Aug-11'),datetime('2016-Aug-13')])
subplot(2,1,2)
plot(newTs.DateTime,  newTs.DataSet.EstadoPant1)
xlim([datetime('2016-Aug-11'),datetime('2016-Aug-13')])