files = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_01_13_sysclima/A000_RelatedFiles/Sysclima/E0_2016_2017_2018_2019_Menaka.xlsx";

ProduccinMenaka = readtable(files);
%%
dataset01 = ProduccinMenaka;

dataset01.DataTime = datetime(ProduccinMenaka.Var1);
dataset01.Var1 = [];
%%
% cell to num
for ivar = dataset01.Properties.VariableNames(1:end-1)
    if ~isnumeric(dataset01.(ivar{:})(1)) 
        dataset01.(ivar{:}) = arrayfun(@(i) str2double(i{:}),dataset01.(ivar{:}));
    end
end
%%
save('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_01_13_sysclima/A001_UniformFormat/output/dataset01.mat','dataset01')

