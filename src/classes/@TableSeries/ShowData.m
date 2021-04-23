function ShowData(iTableSeries,varargin)

    ds = iTableSeries(1).DataSet;
    %%
    p = inputParser;
    addRequired(p,'iTableSeries')
    addOptional(p,'vars',ds.Properties.VariableNames)
    %
    parse(p,iTableSeries,varargin{:})
    %
    vars = p.Results.vars;
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
        for ivar = 1:nvars
           subplot(sq_vars2,sq_vars,ivar)
           hold on

           plot(iTs.DateTime,ds.(vars{ivar}),'.-') 
           title(vars{ivar},'Interpreter','none')
        end
    end
    hold off
end

