
clear all
load("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset01.mat','ds','full')
%%

full.VarName1 = datetime(full.VarName1);
full.Properties.VariableNames{1} = 'DateTime';

%%
full(full.Tinv < -10,:) = [];
full(full.Tinv > 60,:) = [];

%%
iTs = TableSeries(full);
iTs_list = cut(iTs,days(1));
%
iTs_list = RemoveRowMaxGrad(iTs_list,'Tinv',0.3);

%%
clf
i = 0;
for jjTs = iTs_list
    i = i + 1;
   subplot(4,4,i) 
   hold on
   t = minutes(jjTs.tspan);
   %
   plot(jjTs.DateTime,jjTs.DataSet.Tinv,'b.-')
   title("i = "+i)
    
end

%%
clf
hold on
i = 0;
grid on
for jjTs = iTs_list
    i = i + 1;
   t = minutes(jjTs.tspan);

   plot(jjTs.DateTime,jjTs.DataSet.Tinv,'b.-')
   title("i = "+i)
    
end
%%
path_file =  "" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset02.mat';

save(path_file,'iTs_list')
%%
fig = figure(1);
clf(fig);

NN = 8;
for j = 1:NN
    ui = uipanel('Parent',fig,'pos',[ 0 1-(1/NN)*(j) 1 1/NN]);

    jTs = iTs_list(j);
    %
    dt = 5;
    jTs = UniformTimeStamp(jTs,'DT',minutes(dt));
    %
    Tinv = jTs.DataSet.Tinv  ;
    %

    fft_fcn(Tinv,jTs.DateTime,dt,1e2,ui)
    xlim([0 0.002])
    ylim([0 2e5])
end
%%


