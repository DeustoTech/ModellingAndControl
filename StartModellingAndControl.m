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

%%
try
    casadi.SX.sym('s');
catch
    disp('CasADi will be download ...')
    casADi_folder = fullfile(main_path,'src','dependences','CasADi');
    if ~exist(casADi_folder,'dir')
        mkdir(casADi_folder)
    end
    if ismac
        untar('https://github.com/casadi/casadi/releases/download/3.5.1/casadi-osx-matlabR2015a-v3.5.1.tar.gz',casADi_folder)
    elseif ispc
        unzip('https://github.com/casadi/casadi/releases/download/3.5.1/casadi-windows-matlabR2016a-v3.5.1.zip',casADi_folder)
    elseif isunix
        untar('https://github.com/casadi/casadi/releases/download/3.5.1/casadi-linux-matlabR2014b-v3.5.1.tar.gz',casADi_folder)
    end
    addpath(genpath(main_path))

end
%% add all files 
addpath(genpath(pwd))
