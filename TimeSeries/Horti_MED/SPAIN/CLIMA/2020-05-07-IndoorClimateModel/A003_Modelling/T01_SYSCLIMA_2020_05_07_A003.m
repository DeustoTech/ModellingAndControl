clear  all
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/no_heater.mat')
iTs = no_heater;
iTs = Concat(iTs);
%%
iTs.DataSet.DireccinViento = cos(iTs.DataSet.DireccinViento);

%%
iTs = RemoveRowMax(iTs,'Tinv',60);
iTs = RemoveVars(iTs,'verbose',1,'rmvars',{'AlarmaLluvia','AlarmaVto'});
iTs = cut(iTs,minutes(30));
iTs = UniformTimeStamp(iTs,'DT',minutes(2));
iTs = MediaMovil(iTs,10,'exception', {'EstadoCenitalE','EstadoCenitalO','EstadoPant1'});
%
iTs = UniformTimeStamp(iTs,'DT',minutes(5));
%%

VdotViento = {};

iter = 0;
for iiTs = iTs 
    iter = iter + 1;
    tspan = hours(iiTs.DateTime-iiTs.DateTime(1));
    VdotViento{iter} = gradient(iiTs.DataSet.Vviento,tspan);
    iTs(iter).DataSet.VdotViento = VdotViento{iter} ;
    iTs(iter).DataSet.TasaVentila = VdotViento{iter}./iiTs.DataSet.Vviento;
end

%iTs = iTs(5);
%%
ControlVars  = {'EstadoCenitalE','EstadoCenitalO','EstadoPant1'};
%ControlVars  = {'EstadoCenitalO','EstadoPant1'};

Disturbances = {'Text','DireccinViento','RadExt','TasaVentila'};
%Disturbances = {'RadInt','Text','Vviento'};

StateVars    = {'Tinv','HRInt','RadInt'};
ics = ControlSystem(iTs,ControlVars,Disturbances,StateVars); 
%%
[mu_vars,std_vars] = NormalizeData(ics);
%
mu_vars.dist(1) = mu_vars.in(1);
std_vars.dist(1) = std_vars.in(1);

%%
ics = SetNormalization(ics,mu_vars,std_vars);

%% Select model
model = 'NARX';
%model = 'NARX_norm';
%model = 'NN';
%model = 'RNN';
%% compile
switch model
    case 'NARX_norm'
        No = 3;
        imodel = NARX_norm('No',No);
        imodel.NLayers = 3;

    case 'NARX'
        No = 3;
        imodel = NARX('No',No);
        imodel.NLayers = 2;
    case 'NN'
        imodel = NN();
        imodel.NLayers = 3;
    case 'RNN'
        imodel = RNN();
end

%%
imodel = compile(imodel,ics,'MiniBatchSize',32);
%%
figure(2)
opts = {'LR',1e-3,'MaxIter',10000};

%imodel.params.num = imodel.params.num*2;
imodel = train(imodel,ics,'opts',opts);

        
%% train 
%%
%figure(1)
%ind = 4;
%PlotPrediction(imodel,ics,'ind',1,'OutGroups',{1,2},'InGroups',{1,2,3},'Nt',[],'DisGroups',{1,2,3,4})
newcs = ics;
%newcs.TableSeries(7).DataSet.EstadoPant1(1:1450) = 1.444;
ind = 1;
%newcs.TableSeries(ind).DataSet.EstadoCenitalO(1:550) = 4;
%newcs.TableSeries(ind).DataSet.EstadoCenitalO(1:250) = 1.4;

clf
PlotPrediction(imodel,newcs,'ind',ind,'OutGroups',{1,2,3},'InGroups',{1,2,3},'Nt',30,'DisGroups',{1,2,3,4},'normalize',0,'init',1)

%%

fig = figure(1);
clf 
ErrorPlotPrediction(imodel,ics,'Nt',30,'ylims',{[-5,15],[-10,50],[0 1000]})

%print(fig,"Error_"+model+".eps",'-depsc')

