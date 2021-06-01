function   CloseLoopComparison(iNARX,ics,varargin)

%% Input Setting
p = inputParser;

addRequired(p,'iNARX')
addRequired(p,'ics');
addOptional(p,'ind',1);
addOptional(p,'OutGroups',{});
addOptional(p,'InGroups',{});
addOptional(p,'DisGroups',{});
addOptional(p,'xlim',[]);
addOptional(p,'init',[]);

addOptional(p,'Nt',[]);

parse(p,ics,varargin{:})

r = p.Results;

OutGroups = r.OutGroups;
ind       = r.ind;
InGroups  = r.InGroups;
DisGroups = r.DisGroups;
xlims     = r.xlim;
init      = r.init;

if ~isempty(init)
    ics = subselect(ics,ind,init);
end
Nt_win  = r.Nt;


%%
r = SplitGenData(iNARX,ics,'ind',ind);

YTest = GenOpenLoopPred(iNARX,r);

%%
newcs = Data2cs(ics,r.DateTime,r.Input,YTest,r.Disturbances,'denorm',1);
%
ics = DeNormalization(ics);
%
if isempty(xlims)
    xlims = [r.DateTime(1) r.DateTime(Nt_win)];
end
plot2compare([ics newcs],'ind',[ind 1],'OutGroup',OutGroups,'InGroups',InGroups,'xlim',xlims,'DisGroups',DisGroups)


end

