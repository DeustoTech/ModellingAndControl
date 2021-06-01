clear 
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/Ts_sysclima_02.mat')
%%
ind = 1.75e5:20:3.6e5;
LocalTimes = iTs.DateTime(ind)';
RadMeasure = iTs.DataSet.RadExt(ind);
% Meñaka

Latitud  = 43.349024834327; 
Longitud = -2.797651290893;
%%

rad =[];
HRA = [];
DGMT = 2;
iter = 0;
for iLT = LocalTimes
    iter = iter + 1;
    rad(iter) = DateTime2Rad(iLT,Longitud,Latitud,DGMT);
end
%
clf
subplot(3,1,1)

hold on
plot(LocalTimes,rad,'.-')
plot(LocalTimes,RadMeasure,'.-')
grid on
ylim([0 1000])

xlim([LocalTimes(1) LocalTimes(end)])
legend('Mechanistic','Measurement')
%
subplot(3,1,2)
plot(LocalTimes,abs(RadMeasure-rad'),'.-')
ylim([0 1000])
grid on
xlim([LocalTimes(1) LocalTimes(end)])
