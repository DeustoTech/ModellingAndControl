clear  all
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/Ts_sysclima_02.mat')
%%

ds =  iTs.DataSet;
RadExt = ds.RadExt;
RadInt = ds.RadInt;
Tinv   = iTs.DataSet.Tinv;
Text   = iTs.DataSet.Text;
Tven   = iTs.DataSet.TVentilacin;
Pant   = iTs.DataSet.EstadoPant1;
CeniE  = iTs.DataSet.EstadoCenitalE;
CeniO  = iTs.DataSet.EstadoCenitalO;
HRInt = iTs.DataSet.HRInt;
Alarm  = iTs.DataSet.AlarmaLluvia;
dt     = iTs.DateTime;
DV     = ds.DireccinViento;
VV     = ds.Vviento;
MaxHR  = ds.MaxHR;
%
dlims = [datetime('2018-07-29 06:00:00') datetime('2018-07-29 22:00:00')];
%dlims = [datetime('2018-10-08 06:00:00') datetime('2018-10-10 00:00:00')];

%dlims = [datetime('2017-07-16 11:00:00') datetime('2017-07-17 12:00:00')];

dlims = [datetime('2018-02-25 11:00:00') datetime('2018-05-06 18:00:00')];
dlims = dlims + days(365)
%
clf
ui = uipanel('Parent',gcf,'Unit','norm','pos',[-0.12 -0.1 1.2 1.15]);
%
subplot(8,1,1,'Parent',ui)
plot(dt,RadExt,'.-')
hold on
grid on
plot(dt,RadInt,'.-')
legend('Ext','Int')
xlim(dlims)
%
subplot(8,1,2)
hold on
plot(dt,HRInt,'.-')
plot(dt,MaxHR,'.-')

legend('HumInt','MaxHR')

colormap jet
grid on
xlim(dlims)
%

%
subplot(8,1,3)
    hold on
grid on
plot(dt,(Tinv),'.-')
plot(dt,(Text),'.-')
plot(dt,(Tven),'.-')

xlim(dlims)
legend('Tinv','Text','Tven')
%ylim([11 25])
subplot(8,1,4)
hold on
plot(dt,(Alarm),'.-')
plot(dt,(ds.AlarmaVto),'.-')

xlim(dlims)
legend('AlarmaLlu','AlarmaV')

 subplot(8,1,5)
 plot(dt,(VV),'.-')
xlim(dlims)
 legend('Velocidad Viento')
 
 subplot(8,1,6)
 plot(dt,cos((pi/180)*DV),'.-')
 xlim(dlims)
 legend('Direc')

subplot(8,1,7)
hold on
plot(dt,CeniO,'.-')
plot(dt,CeniE,'.-')

%plot(dt,EstadoCenital(Tinv,Tven,Alarm,HRInt,MaxHR,RadInt,dt),'.-')

xlim(dlims)
legend('CeniO','CeniE')

 subplot(8,1,8)
 hold on
 grid on
 %plot(dt,80*EstadoPant(RadInt,Tinv,Tven,800,400),'.-')
 plot(dt,Pant,'.-')
 legend('Pant')
% 
 xlim(dlims)


