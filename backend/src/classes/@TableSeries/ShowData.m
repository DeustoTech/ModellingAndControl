function ShowData(iTableSeries,varargin)

    ds = iTableSeries.DataSet;
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
    
    %
    for ivar = 1:nvars
       subplot(sq_vars2,sq_vars,ivar)
       plot(iTableSeries.DateTime,ds.(vars{ivar}),'.') 
       title(vars{ivar},'Interpreter','none')
    end

end

