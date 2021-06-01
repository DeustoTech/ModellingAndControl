clear 
load("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/2020_03_08_build_data/A001_UniformFormat/output/dataset01.mat')
%
dataset01.VarName1 = datetime(dataset01.VarName1);
dataset01.Properties.VariableNames{1} = 'DateTime';
%%
%dataset01 = dataset01(:,{'DateTime','Tinv','RadInt','HRInt','Text','RadExt','HRExt','Vviento','DireccinViento','AlarmaVto','AlarmaLluvia','EstadoCenitalO','EstadoCenitalE','EstadoPant1'});
dataset01.Time = dataset01.DateTime - dataset01.DateTime(1);
%

max_ind_date = length(dataset01.DateTime) - 8000;

ind = randsample(max_ind_date,10,0);

pathfile =  '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/HortiMED/GreenHouseModel/data/clima/mat'



for i = ind'
   dataset = dataset01(i:i+8000,:);
   dataset.Time = dataset.DateTime - dataset.DateTime(1);
    

   timeserie = timeseries(dataset{:,2:end-1},hours(   dataset(:,end).Time));
   
   new_tspan = linspace(timeserie.Time(1),timeserie.Time(end),800);

   timeserie = resample(timeserie,new_tspan);
   names = dataset.Properties.VariableNames(2:end-1);
   timeserie.UserData = dataset(:,2:end);
   save(char(pathfile+"/time_serie_"+i+".mat"),'timeserie','-v7.3');
end

