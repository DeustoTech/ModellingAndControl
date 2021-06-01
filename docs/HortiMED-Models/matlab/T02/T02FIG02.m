%%
% Figura de base de datos con menos variables 
%
clear 

load(MainPath+"/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/Ts_sysclima_02.mat")
 
%%
newTs = iTs;
%%
fig = figure('Units','norm','pos',[0 0 0.55 0.5]);
fig.Renderer = 'Painters';
clf
xlims = [datetime('2016-07-01') datetime('2019-08-01')];
ShowData(newTs,'windows',200,'distribution',[3 4],'FontSize',9,'xlim',xlims)

print(fig,'-depsc',fullfile(ImgDocPath,'SysClimaDataSet02.eps'))


%%
