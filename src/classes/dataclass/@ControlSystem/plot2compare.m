function plot2compare(ics_all,varargin)

ics = ics_all(1);

p = inputParser;
addRequired(p,'ics')
addOptional(p,'OutGroups',[])
addOptional(p,'InGroups',[])
addOptional(p,'DisGroups',[])

addOptional(p,'xlim',[])
addOptional(p,'Parent',gcf)

addOptional(p,'ind',[1 1])

parse(p,ics,varargin{:})

InGroups = p.Results.InGroups;
OutGroups = p.Results.OutGroups;

DisGroups = p.Results.DisGroups;
ind       = p.Results.ind;
Parent    = p.Results.Parent;
xlims    = p.Results.xlim;

 
ui1 = uipanel('Parent',Parent,'Unit','norm','pos',[0 2/3 1 1/3]);
ui2 = uipanel('Parent',Parent,'Unit','norm','pos',[0 1/3 1 1/3]);
ui3 = uipanel('Parent',Parent,'Unit','norm','pos',[0 0 1 1/3]);

if isempty(InGroups)
    ax1 = axes('Parent',ui1);
    hold on
end
if isempty( OutGroups )
    ax3 = axes('Parent',ui3);
end
%
if isempty( DisGroups )
    ax2 = axes('Parent',ui2);
    hold on
end


ncolors = max([ics.Nout,ics.Nin,ics.Ndis]);
colors{1} = parula(ncolors);
colors{2} = colors{1}*0.7 + 0.3*[0 0 0];
colors{1} = colors{1}*0.5 + 0.5*[1 1 1];

%
iter = 0;

Ncs = length(ics_all);
LineStyle = {'none','-'};
Marker = {'o','.'};
MS = {10,5};


for ics = ics_all
iter = iter +1;
ds = vertcat(ics.TableSeries(ind(iter)).DataSet);
date = horzcat(ics.TableSeries(ind(iter)).DateTime);
%%



if isempty( InGroups )
    i = 0;
    hold(ax1,'on')

    for ivar = ics.InputVars
        i = i + 1;
        plot(date,ds.(ivar{:}),'Marker',Marker{iter},'Parent',ax1,'LineStyle',LineStyle{iter},'color',colors{iter}(i,:) )
    end
    if ~isempty(xlims)
        xlim(ax1,xlims)
    end
    legend(ax1,ics.InputVars,'Interpreter','none')
    title(ax1,'Inputs')
else
    n = length(InGroups);
    ids = ds(:,ics.InputVars);
    lp = 1;
    for i=1:n
        subplot(1,n,i,'Parent',ui1)
        hold on
        for k = InGroups{i}
        plot(date,ids{:,k},'MarkerSize',MS{iter},'Marker',Marker{iter},'LineStyle',LineStyle{iter},'color',colors{iter}(lp,:))
        lp = lp + 1;
        end
        legend(ics.InputVars{InGroups{i}},'Interpreter','none')
        if ~isempty(xlims)
            xlim(xlims)
        end
    end
end
%%

if ~isempty(ics.DisturbanceVars)
    if isempty( DisGroups )
        hold(ax2,'on')

        i = 0;
        for ivar = ics.DisturbanceVars
            i = i + 1;
            plot(date,ds.(ivar{:}),Marker{iter},'MarkerSize',MS{iter},'Parent',ax2,'LineStyle',LineStyle{iter},'color',colors{iter}(i,:))
        end
        if ~isempty(xlims)
            xlim(ax2,xlims)
        end
        legend(ax2,ics.DisturbanceVars,'Interpreter','none')
        title(ax2,'Disturbances')

    else
        n = length(DisGroups);
        ids = ds(:,ics.DisturbanceVars);
        for i=1:n
            subplot(1,n,i,'Parent',ui2)
            hold on
            
            plot(date,ids{:,DisGroups{i}},'MarkerSize',MS{iter},'LineStyle',LineStyle{iter},'Marker',Marker{iter},'color',colors{iter}(i,:))
            legend(ics.DisturbanceVars{DisGroups{i}},'Interpreter','none')
            if ~isempty(xlims)
                xlim(xlims)
            end
        end
    end
end
%%

if isempty( OutGroups )

    hold(ax3,'on')
    i = 0;
    for ivar = ics.OutputVars
        i = i + 1;
        plot(date,ds.(ivar{:}),Marker{iter},'MarkerSize',MS{iter},'LineStyle',LineStyle{iter},'Parent',ax3,'color',colors{iter}(i,:))
    end
    if ~isempty(xlims)
        xlim(ax3,xlims)
    end
    title(ax3,'Outputs')
    legend(ax3,ics.OutputVars,'Interpreter','none')

else
    n = length(OutGroups);
    ids = ds(:,ics.OutputVars);
    lp = 1;

    for i=1:n
        lms =  1;
        subplot(1,n,i,'Parent',ui3)
        hold on
        ms = linspace(4,18,ics.Nout);
        for k = OutGroups{i}
            plot(date,ids{:,k},'MarkerSize',ms(lms),'LineStyle',LineStyle{iter},'Marker',Marker{iter},'color',colors{iter}(lp,:))
            lp = lp + 1;
            lms = lms + 1;
        end
        legend(ics.OutputVars{OutGroups{i}},'Interpreter','none')
        if ~isempty(xlims)
            xlim(xlims)
        end
    end
    
end
end
