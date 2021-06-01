function r = ImgDocPath
    file = 'StartModellingAndControl.m';
    r    =  replace(which(file),file,''); 
    r    = fullfile(r,'docs/HortiMED-Models/img');
end