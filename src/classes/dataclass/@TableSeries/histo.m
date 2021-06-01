function histo(iTableSeries,varargin)

    ds = iTableSeries(1).DataSet;
    %%
    p = inputParser;
    addRequired(p,'iTableSeries')
    addOptional(p,'vars',ds.Properties.VariableNames)
    addOptional(p,'windows',[])
    addOptional(p,'distribution',[])
    addOptional(p,'FontSize',10)
    addOptional(p,'PlotOpts',{})

    %
    parse(p,iTableSeries,varargin{:})
    %
    vars = p.Results.vars;
    windows = p.Results.windows;
    distribution = p.Results.distribution;
    FontSize = p.Results.FontSize;
    PlotOpts = p.Results.PlotOpts;

    %%
    nvars = length(vars);
    sq_vars  = floor(sqrt(nvars));
    sq_vars2 = sq_vars;
    res      = nvars-sq_vars*sq_vars2;
    
    while res > 0
        sq_vars2 = sq_vars2 + 1;
        res      = nvars-sq_vars*sq_vars2;
    end
    
    for iTs = iTableSeries
        ds = iTs.DataSet;
        nt = length(iTs.DateTime);
        for ivar = 1:nvars
           if isempty(distribution)
                subplot(sq_vars2,sq_vars,ivar)
           else
                subplot(distribution(1),distribution(2),ivar)
           end
           hold on
           ax = gca;
           ax.FontSize = FontSize;
           if ~isempty(windows) 
             values = ds.(vars{ivar});
             histogram(values(1:windows:nt),'Normalization','probability',PlotOpts{:}) 
           else
             histogram(ds.(vars{ivar}),'Normalization','probability',PlotOpts{:}) 
           end
           %ylim([0 1])
           title(vars{ivar},'Interpreter','none','FontWeight','normal')
           grid on
        end
    end
    hold off
end

