clear  all
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/heater.mat')
iTs = heater;
iTs = Concat(iTs);
%%
iTs = RemoveRowMax(iTs,'Tinv',60);
iTs = RemoveVars(iTs,'verbose',1,'rmvars',{'AlarmaVto'});
iTs = cut(iTs,minutes(30));
iTs = UniformTimeStamp(iTs,'DT',minutes(2));
iTs = MediaMovil(iTs,2);
%
iTs = UniformTimeStamp(iTs,'DT',minutes(10));
%
iTs = iTs(4);
iTs = subselect(iTs,1:300  );
%iTs = iTs(1);
%iTs = subselect(iTs,1:800 );

%iTs.DataSet.EstadoCenitalO(1:2600) = 0;
%iTs.DataSet.EstadoCenitalE(1:2600) = 0;

%iTs.DataSet.EstadoCenitalO(1:1400) = 0;
%iTs.DataSet.EstadoPant1(1:1400) = 0;
%iTs.DataSet.Vviento(1:1400) = 0;

%%
ControlVars  = {'EstadoCenitalE','EstadoCenitalO','EstadoPant1'};
Disturbances = {'DireccinViento','RadInt','Text','Vviento','AlarmaLluvia'};
StateVars    = {'HRInt','Tinv'};
ics = ControlSystem(iTs,ControlVars,Disturbances,StateVars); 
%%
iTs = ics.TableSeries;
%
%%

%%
figure(2)
clf
pplots = true;

params = set_params;
x_Tinv_pred = ComputePred(iTs,pplots,params);
%%


