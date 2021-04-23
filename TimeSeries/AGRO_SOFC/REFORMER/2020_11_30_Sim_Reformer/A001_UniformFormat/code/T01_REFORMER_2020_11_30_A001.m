clear
%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: /Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A000_RelatedFiles/reformer-data-10000-samples-Ver01.csv
%
% Auto-generated by MATLAB on 11-Jan-2021 12:29:09

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 42, "Encoding", "UTF-8");

% Specify range and delimiter
opts.DataLines = [5, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Steam_Fuel_Ratio", "Air_Fuel_Ratio", "VarName3", "N2_mass", "O2_mass", "CO2_mass", "H2O_mass", "Argon_mass", "C_mass", "H_mass", "VarName11", "N2_mole", "O2_mole", "CO2_mole", "H2O_mole", "Argon_mole", "C_mole", "H_mole", "VarName19", "H2O_C_ratio", "O_C_ratio", "H_C_ratio", "VarName23", "Temperature", "VarName25", "Ar_mass_out", "CH4_mass_out", "CO_mass_out", "CO2_mass_out", "H2_mass_out", "H2O_mass_out", "N2_mass_out", "C_soot_mass_out", "VarName34", "Ar_mole_out", "CH4_mole_out", "CO_mole_out", "CO2_mole_out", "H2_mole_out", "H2O_mole_out", "N2_mole_out", "C_soot_mole_out"];
opts.VariableTypes = ["double", "double", "string", "double", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "string", "double", "string", "double", "double", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["VarName3", "VarName11", "VarName19", "VarName23", "VarName25", "VarName34"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName3", "VarName11", "VarName19", "VarName23", "VarName25", "VarName34"], "EmptyFieldRule", "auto");

% Import the data
reformerdata10000samplesVer01 = readtable("/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A000_RelatedFiles/reformer-data-10000-samples-Ver01.csv", opts);


%% Clear temporary variables
clear opts

dataset01 = reformerdata10000samplesVer01;
save("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset01.mat','dataset01')