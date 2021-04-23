clear 

load("" + MainPath + 'TimeSeries/Horti_MED/PROD/2020_01_13_PROD/A001_UniformFormat/output/dataset03.mat')

%%
ds = dataset03(1:3);
%%
intF = [ds{1}.FechaDeEntrega(1) ds{1}.FechaDeEntrega(end)];

load("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/2020_02_04_sysclima/A001_UniformFormat/output/dataset02.mat')
ds_clima = dataset01;