clear 
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_03_08_build_data/A001_UniformFormat/output/dataset01.mat')
%
dataset01.VarName1 = datetime(dataset01.VarName1);
dataset01.Properties.VariableNames{1} = 'DateTime';
%%
rmvars = {'DeltaX','Sonda1','Sonda2','Sonda3','Sonda5','Sonda6', ...
          'Troco','RadAcumExt','DPV','DeltaT','MaxHR','TVentilacin','DemPant1',...
          'AlarmaVto','AlarmaLluvia'};
dataset02 = RemoveVarNames(dataset01,'rmvars',rmvars);
%%
clf
[MatCoor,MatCoor_boolean,iplot,G] = LinearCoorAna(dataset02(:,2:end),'alpha',0.95,'FontSize',12);
%%
clf
vars = dataset02.Properties.VariableNames(2:end);
nvars  = length(vars);
sqn = floor(sqrt(nvars)) + 1;
i = 0;
for ivar = vars
    i = i + 1;
    subplot(sqn,sqn,i)
    scatter(dataset02.Tinv,dataset02.Text,[],dataset02.(ivar{:}))
    title(ivar{:})
    colorbar
    xlabel('Tinv')
    ylabel('Text')
end
%
%%
InputVars    = {'EstadoCenitalO','EstadoCenitalO','EstadoPant1'                };
OutputsVars  = {'Tinv'          ,'HRInt'         ,'RadInt'                    };
DisturVars   = {'Text'          ,'Vviento'       ,'DireccinViento'  ,'RadExt'};
%
iCS = ControlSeries(dataset02,InputVars,DisturVars,OutputsVars);
%
%%