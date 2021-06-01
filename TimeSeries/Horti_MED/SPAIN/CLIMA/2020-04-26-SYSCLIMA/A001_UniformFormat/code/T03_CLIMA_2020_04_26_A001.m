clear 
load(MainPath+"/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/Ts_sysclima_01.mat")
%%
iTs = RemoveVars(iTs,'verbose',1,'rmvars',{'EstadoLateralE','Sonda1','Sonda2', ...
                                           'Sonda3','Sonda5','Sonda6', ...
                                           'Aerotermo1Activo','DeltaT','DeltaX', ...
                                           'MaxHR','Troco','RadAcumExt', ...
                                           'TVentilacin','DPV','DemPant1'});
%%
xlims = [datetime('2018-02-20') datetime('2018-02-25')];
ShowData(iTs,'xlim',[])
%%
pathfile = fullfile(MainPath,'TimeSeries','Horti_MED','SPAIN','CLIMA', ...
                    '2020-04-26-SYSCLIMA','A001_UniformFormat', ...
                    'output','Ts_sysclima_02.mat');

save(pathfile,'iTs')

%% Limpieza

Tinv_clean  = filloutliers(iTs.DataSet.Tinv,'nearest','mean');
clf
subplot(2,1,1)
plot(iTs.DateTime,Tinv_clean)
hold on 
plot(iTs.DateTime,iTs.DataSet.Tinv,'--')
%
subplot(2,1,2)
plot(iTs.DateTime,iTs.DataSet.Tinv - Tinv_clean)

