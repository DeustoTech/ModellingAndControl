function   PlotPrediction(imodel,ics,varargin)

%% Input Setting
p = inputParser;

addRequired(p,'iNARX')
addRequired(p,'ics');
addOptional(p,'ind',1);
addOptional(p,'OutGroups',{});
addOptional(p,'DisGroups',{});
addOptional(p,'InGroups',{});
addOptional(p,'Nt',[]);
addOptional(p,'normalize',0);
addOptional(p,'init',1);

parse(p,imodel,ics,varargin{:})

r = p.Results;

OutGroups = r.OutGroups;
ind       = r.ind;
InGroups  = r.InGroups;
Nt        = r.Nt;
DisGroups  = r.DisGroups;
normalize = r.normalize;
init = r.init;

%

if isempty(Nt)
    Nt = ics.TableSeries(ind).ndata - 10;
end
%%
if isa(imodel,'NN')
    r = SplitGenData(imodel,ics,'ind',ind,'Nt',Nt);
else
    r = SplitGenData(imodel,ics,'ind',ind,'Nt',Nt,'init',init);
end
YTest = Prediction(imodel,ics,r,Nt);
YTest = full(YTest);

%%
if normalize
    newcs = Data2cs(ics,r.DateTime,r.Input,YTest,r.Disturbances,'denorm',0);
else
    newcs = Data2cs(ics,r.DateTime,r.Input,YTest,r.Disturbances,'denorm',1);
    ics   = DeNormalization(ics);
end
%
xlims = [r.DateTime(1) r.DateTime(end)];
plot2compare([ics newcs],'ind'      ,[ind 1],       ...
                         'OutGroup' ,OutGroups,     ...
                         'InGroups' ,InGroups,      ...
                         'xlim'     ,xlims,         ...
                         'DisGroups',DisGroups)


end

