%
clear all
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2021_04_21_euskalmet/A000_RelatedFiles/takeclimadata/fulldata.mat')
%
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset02.mat')

%%
newds.Properties.VariableNames{7} = 'Text';
%
ds.Text = newds.Text;
ds.DateTime = newds.DateTime;

newds = struct2table(ds);
%%
iTs = TableSeries(newds);

clf
ShowData(iTs)
xlim([datetime('01-Jun-2016') datetime('01-Jul-2016')])
hold on 
%%
iTs = RemoveRowsNan(iTs);
ShowData(iTs)
%%
%%
iTs = UniformTimeStamp(iTs,'DT',minutes(20));
ShowData(iTs)

%%
%
path_file =  '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset02.mat';
load(path_file)

%%

clf
datelim = [datetime('01-Jun-2016') datetime('01-Oct-2016')];
fft_fcn(iTs.DataSet.Text,iTs.DateTime,20,1e2,'freqlim',[0 4e-3],'datelim',[])
ylim([0 20])
%%
subplot(4,1,2)
hold on
grid on
for i = 1:13
    lll = plot(clima_ts(i).DateTime,clima_ts(i).DataSet.Text,'.')
end
rrr = plot(iTs.DateTime,iTs.DataSet.Text)

title('Text + Text eus')
xlim(dates)
ylim([0 50])
yline(30)
yline(10)


legend([lll rrr],'Text','Text eus')
subplot(4,1,3)
hold on
grid on
for i = 1:13
    plot(clima_ts(i).DateTime,clima_ts(i).DataSet.Text,'.')
end
title('Text')
xlim(dates)
ylim([0 50])
yline(30)
yline(10)

    
subplot(4,1,4)
hold on
plot(iTs.DateTime,iTs.DataSet.Text)
xlim([datetime('Jul-2016') datetime('Jan-2021')])
ylim([0 50])
yline(30)
yline(10)
grid on
title('Text eus')
