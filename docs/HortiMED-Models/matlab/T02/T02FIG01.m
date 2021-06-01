%%
% Figura que muestra la totalidad de la base de datos original de sysclima
% abarcando desde Julio de 2016 hasta Agosto de 2019 ademas de la producion
% de kilos de tomate producidos en un periodo similar
%
clear 

load(MainPath+"/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/Ts_sysclima_01.mat")
 
%%
newTs = iTs;
%%
fig = figure('Units','norm','pos',[0 0 0.55 0.8]);
fig.Renderer = 'Painters';
clf
ShowData(newTs,'windows',300,'distribution',[8 4],'FontSize',9)

print(fig,'-depsc',fullfile(ImgDocPath,'SysClimaDataSet.eps'))

%%
load("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/PROD/2020_01_13_PROD/A001_UniformFormat/output/dataset03.mat')
iTs_prod = TableSeries(vertcat(dataset03{:}));
%%
fig = figure('Units','norm','pos',[0 0 0.45 0.55]);
fig.Renderer = 'Painters';
clf
ShowData(iTs_prod,'FontSize',14,'PlotOpts',{'LineStyle','-','MarkerSize',15})
box 
print(fig,'-depsc',fullfile(ImgDocPath,'ProdMenaka.eps'))

%%
