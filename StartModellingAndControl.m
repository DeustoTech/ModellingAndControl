

main_path = which('StartModellingAndControl.m');
main_path = replace(main_path,'StartModellingAndControl.m','');
mkdir(fullfile(main_path,'Data'))

%%

r = websave('Data/DATASOURCES.zip','https://drive.google.com/u/0/uc?id=1OiTq6zIqg1yiTl_EkcKuH7O7hGFUqhmK&export=download');
unzip('Data/DATASOURCES.zip','Data/')

addpath(genpath(pwd))
