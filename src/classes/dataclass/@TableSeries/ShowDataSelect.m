function ShowDataSelect(iTableSeries,vars,varargin)

    ds = iTableSeries(1).DataSet;
    %%
    p = inputParser;
    addRequired(p,'iTableSeries')
    addRequired(p,'vars')
    addOptional(p,'window',[])
    addOptional(p,'xlim',[])
    addOptional(p,'vertical',false)

    %
    parse(p,iTableSeries,vars,varargin{:})
    %
    window = p.Results.window;
    xlims =  p.Results.xlim;
    vertical =  p.Results.vertical;

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
        Nt = length(iTs.DateTime);


        for ivar = 1:nvars
            if vertical
                subplot(nvars,1,ivar)
            else
                subplot(sq_vars2,sq_vars,ivar)
            end
            hold on
            if isempty(window)
                plot(iTs.DateTime,iTs.DataSet{:,vars{ivar}},'.-')
            else
                plot(iTs.DateTime(1:window:Nt),iTs.DataSet{1:window:Nt,vars{ivar}},'.-')
            end
            if ~isempty(xlims)
                xlim(xlims)
            end
            grid on
        end
        
    end
    
    for ivar = 1:nvars
        if vertical
            subplot(nvars,1,ivar)
        else
            subplot(sq_vars2,sq_vars,ivar)
        end
        legend(ds.Properties.VariableNames(vars{ivar}),'Interpreter','none','FontSize',8)
    end
        
    hold off
end

