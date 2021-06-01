function   CloseLoopComparison(iNN,ics,varargin)

%% Input Setting
p = inputParser;

addRequired(p,'iNN')
addRequired(p,'ics');
addOptional(p,'ind',1);
addOptional(p,'Nt',1);
addOptional(p,'OutGroups',{});
addOptional(p,'InGroups',{});
addOptional(p,'DisGroups',{});

parse(p,ics,varargin{:})

r = p.Results;

OutGroups = r.OutGroups;
ind       = r.ind;
InGroups  = r.InGroups;
DisGroups  = r.DisGroups;


Nt_win  = r.Nt;

%%

r = SplitGenData(iNN,ics,'ind',ind);

Nt = length(r.tspan);

if isempty(Nt_win)
    Nt_win = Nt;
end


YTest = GenOutputPrediction(iNN,r);
YTest = full(YTest);

%%
newcs = Data2cs(ics,r.DateTime,r.Input,YTest,r.Disturbances,'denorm',1);
%

xlims = [r.DateTime(1) r.DateTime(Nt_win)];

ics = DeNormalization(ics);
plot2compare([ics newcs],'ind',[ind 1],'OutGroup',OutGroups,'InGroups',InGroups,'xlim',xlims,'DisGroups',DisGroups)


end

