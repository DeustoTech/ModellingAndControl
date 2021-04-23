clear;
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_01_13_sysclima/A001_UniformFormat/output/dataset02.mat')
%%
vars = {'Text','RadExt','Tinv',}
ind = 1000+1:4000;
% Ventanas 
figure(1)
clf
subplot(2,1,1)
grid on
hold on 
plot( dataset02.DataTime(ind) ,dataset02.Text(ind),'.-')
plot( dataset02.DataTime(ind) ,dataset02.Tinv(ind),'.-')
legend({'Text','Tint'})
subplot(2,1,2)
grid on

hold on
plot( dataset02.DataTime(ind) ,dataset02.EstadoCenitalE(ind))
plot( dataset02.DataTime(ind) ,dataset02.EstadoCenitalO(ind))
plot( dataset02.DataTime(ind) ,dataset02.EstadoLateralE(ind))

%%
figure(1)
subplot(2,1,1)

plot(dataset02.EstadoCenitalE - dataset02.EstadoCenitalO); 
subplot(2,1,2)
plot(dataset02.EstadoCenitalO);
%
%% latex tabel


str = "";

for ivar = dataset02.Properties.VariableNames
   str = str + "\texttt{"+ivar{:} + "} \\" +newline + "\hline" + newline;
end

str = replace(str,'_','');