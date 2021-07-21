clear 

name_file = 'StartModellingAndControl.m';
main_path = which(name_file);
main_path = replace(main_path,name_file,'');

cd(main_path)
%% clean 
try 
    rmdir('data') 
catch 
    
end
try 
    rmdir('src/dependences')
catch
end
%% Make a new folders

data_path = fullfile(main_path,'data');
data_depen = fullfile(main_path,'src/dependences');
%
mkdir(data_path)
mkdir(data_depen)

%% download HortiMED data 
unzip('https://github.com/djoroya/HortiMED-Data-Sources/archive/refs/heads/main.zip',data_path)

%% download AGRO SOFC data


%% add all files 
addpath(genpath(pwd))
