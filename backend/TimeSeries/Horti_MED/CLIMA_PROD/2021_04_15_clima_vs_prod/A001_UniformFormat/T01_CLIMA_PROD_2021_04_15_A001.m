clear all
%
path_file =  '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset02.mat';
load(path_file)
%
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/PROD/2020_01_13_PROD/A001_UniformFormat/output/dataset03.mat')
%%
clima_ts = iTs_list;

for i = 1:6
produ_ts(i) = TableSeries((dataset03{i}));
end
%%
clf
subplot(4,1,1)
dates = [datetime('01-Jul-2016') datetime('01-Jan-2021')];
%
hold on 
grid on
for i = 1:6
    plot(produ_ts(i).DateTime,produ_ts(i).DataSet.Netokg,'.-')
end
xlim(dates)

j = 1;
for ivar = {'Tinv','Text'}
    j = j + 1;
    subplot(4,1,j)
    hold on
    grid on
    for i = 1:13
        plot(clima_ts(i).DateTime,clima_ts(i).DataSet.(ivar{:}),'.')
    end
    title(ivar{:})
    xlim(dates)
    ylim([0 50])
    yline(30)
    yline(10)

end

subplot(4,1,4)
hold on
grid on
for i = 1:13
    plot(clima_ts(i).DateTime,clima_ts(i).DataSet.Tinv -clima_ts(i).DataSet.Text ,'.')
end
xlim(dates)


%%
