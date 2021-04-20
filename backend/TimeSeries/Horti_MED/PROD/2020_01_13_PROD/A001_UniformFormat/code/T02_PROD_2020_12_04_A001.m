clear 

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/PROD/2020_01_13_PROD/A001_UniformFormat/output/dataset01.mat')
%% Ordenamos los datos por dias 
[~,ind] = sort(dataset01.FechaDeEntrega);
%
dataset01.Properties.VariableNames{1} = 'DateTime';
dataset02 = dataset01(ind,:);
dataset02(:,2:end-1) = [];
%% Vista de datos generales

fig = figure(1);
fig.Units = 'norm';
fig.Position = [0 0 0.6 0.5];


idays = days(dataset02.DateTime - dataset02.DateTime(1));
plot(dataset02.DateTime,dataset02.Netokg,'*-')
ylabel('NetoKg')
xlabel('Date')
grid on 
title('Producción')
print(fig,'/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/PROD/2020_01_13_PROD/A001_UniformFormat/pics/pic01.png','-dpng')

%% Separacion por recogidas 
%
% Diferencia de dias entre los datos 
plot(days(diff(dataset02.DateTime)))
%
Delta_day = 15;
%%
% Consideramos que existen 3 paradas 
plot(days(diff(dataset02.DateTime))>Delta_day)
%
ind_days_bolean = (days(diff(dataset02.DateTime)) > Delta_day);
% consideramos el primer dia como inicio de un campaña de recogida
ind_days_bolean(1) = 1;
dataset02.DateTime(ind_days_bolean)
%
dataset03 = {};
ind_days =find(ind_days_bolean);
ind_days(1) = 0;
ndays = length(ind_days);
for i = 1:ndays-1
    dataset03{i} = dataset02((ind_days(i)+1):(ind_days(i+1)-1),:);
end
dataset03{i+1} = dataset02((ind_days(i+1)+1):end,:);

%%


fig = figure(2);
fig.Units = 'norm';
fig.Position = [0 0 0.6 0.5];

clf
nt = length(dataset03);
for i = 1:nt
ui{i} = uipanel('Parent',fig    , ...
                'Title',"Season "+i, ...
                'unit'  ,'norm' , ...
                'pos',[(i-1)/nt 0 1/nt 1.0]);
plotdat(dataset03{i},ui{i})
end

print(fig,'/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/PROD/2020_01_13_PROD/A001_UniformFormat/pics/pic02.png','-dpng')
%%
pathfile = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/PROD/2020_01_13_PROD/A001_UniformFormat/output'
save(fullfile(pathfile,'dataset03.mat'),'dataset03');
%%
function plotdat(ds,Parent)
    subplot(2,1,1,'Parent',Parent)
    plot(ds.DateTime,ds.Netokg,'-','Marker','.')
    title('Kg')
    grid on
    subplot(2,1,2,'Parent',Parent)
    plot(ds.DateTime,cumsum(ds.Netokg),'-','Marker','.')
    title('cum Kg ')
    grid on

end
