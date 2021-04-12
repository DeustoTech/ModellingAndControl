%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: /Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_04_sysclima/A000_RelatedFiles/E0_2016_2017_2018_2019_Menaka.xlsx
%    Worksheet: E0_S1_2019
%
% Auto-generated by MATLAB on 04-Feb-2021 15:06:57

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 30);

% Specify sheet and range
opts.Sheet = "E0_S1_2019";
opts.DataRange = "A3:AD74667";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "Text", "HRExt", "RadExt", "Vviento", "DireccinViento", "RadAcumExt", "AlarmaLluvia", "AlarmaVto", "Tinv", "Troco", "RadInt", "DemPant1", "EstadoPant1", "TVentilacin", "EstadoCenitalE", "EstadoCenitalO", "MaxHR", "MinHR", "DeltaX", "DeltaT", "DPV", "HRInt", "Ventiladores2Activo", "Sonda1", "Sonda2", "Sonda3", "Sonda5", "Sonda6"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, "VarName1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "VarName1", "EmptyFieldRule", "auto");

% Import the data
E02016201720182019MenakaS5 = readtable("/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_03_08_build_data/A000_RelatedFiles/E0_2016_2017_2018_2019_Menaka.xlsx", opts, "UseExcel", false);


%% Clear temporary variables
dataset01 = E02016201720182019MenakaS5;
save('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_03_08_build_data/A001_UniformFormat/output/dataset01.mat','dataset01')
