function plot(ics,varargin)

p = inputParser;
addRequired(p,'ics')
addOptional(p,'OutGroups',[])
addOptional(p,'InGroups',[])

addOptional(p,'Parent',gcf)

addOptional(p,'ind',1)

parse(p,ics,varargin{:})

InGroups = p.Results.InGroups;

OutGroups = p.Results.OutGroups;
ind       = p.Results.ind;
Parent    = p.Results.Parent;

ds = vertcat(ics.TableSeries(ind).DataSet);
date = horzcat(ics.TableSeries(ind).DateTime);
%%

ui1 = uipanel('Parent',Parent,'Unit','norm','pos',[0 2/3 1 1/3]);
if isempty( InGroups )
    ax1 = axes('Parent',ui1);
    hold on
    for ivar = ics.InputVars
        plot(date,ds.(ivar{:}),'Marker','.','Parent',ax1,'LineStyle','-')
    end
    legend(ics.InputVars,'Interpreter','none')
    title('Inputs')
else
    n = length(InGroups);
    ids = ds(:,ics.InputVars);
    for i=1:n
        subplot(1,n,i,'Parent',ui1)
        plot(date,ids{:,InGroups{i}},'Marker','.','LineStyle','-')
        legend(ics.InputVars{InGroups{i}},'Interpreter','none')
    end
end
%%
ui2 = uipanel('Parent',Parent,'Unit','norm','pos',[0 1/3 1 1/3]);
ax2 = axes('Parent',ui2);

hold on
for ivar = ics.DisturbanceVars
    plot(date,ds.(ivar{:}),'.','Parent',ax2,'LineStyle','-')
end
legend(ics.DisturbanceVars,'Interpreter','none')
title('Disturbances')
%%
ui3 = uipanel('Parent',Parent,'Unit','norm','pos',[0 0 1 1/3]);

if isempty( OutGroups )
    ax3 = axes('Parent',ui3);

    hold on
    for ivar = ics.OutputVars
        plot(date,ds.(ivar{:}),'.','LineStyle','-','Parent',ax3)
    end
    title('Outputs')
    legend(ics.OutputVars,'Interpreter','none')

else
    n = length(OutGroups);
    ids = ds(:,ics.OutputVars);
    for i=1:n
        subplot(1,n,i,'Parent',ui3)
        plot(date,ids{:,OutGroups{i}},'LineStyle','-','Marker','.')
        legend(ics.OutputVars{OutGroups{i}},'Interpreter','none')
    end
end
