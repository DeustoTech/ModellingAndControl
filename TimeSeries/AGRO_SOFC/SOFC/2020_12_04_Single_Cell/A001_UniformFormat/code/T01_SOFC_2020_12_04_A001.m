clear 
inds = [1:20 26 28 32 44 50:54];


%pathfolder = [pwd,'/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/SPS_Data/'];

pathfolder = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A000_RelatedFiles/SPS_Data";

files = dir(pathfolder);

iter = 0;
for ifiles = files(3:end)'
    
    if ~contains(ifiles.name,'.txt')
        continue
    end
    iter = iter + 1;
    DT  = DataSOFC(ifiles.name);

    DataSOFCtable{iter} = DT(:,inds);
    DataSOFCtable{iter}.Date.Format = 'dd.MM.uuuu HH:mm';
    DataSOFCtable{iter}.Time.Format = 'dd.MM.uuuu HH:mm';
    DataSOFCtable{iter}.DateTime = DataSOFCtable{iter}.Date + timeofday(DataSOFCtable{iter}.Time);
    %     
    DataSOFCtable{iter}.Date = [];
    DataSOFCtable{iter}.Time = [];

    DataSOFCtable{iter} = TableSeries(DataSOFCtable{iter});
end

fileout = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset01.mat';

dataset01 = DataSOFCtable;
save(fileout,'dataset01')
