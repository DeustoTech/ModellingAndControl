function new_cs = Data2cs(ics,tspan,In,Out,Dis,varargin)
    
    % 
    p = inputParser;

    addRequired(p,'ics');
    addRequired(p,'tspan');
    addRequired(p,'In');
    addRequired(p,'Out');
    addRequired(p,'Dis');
    addOptional(p,'denorm',0);

    %%
    parse(p,ics,tspan,In,Out,Dis,varargin{:})

    r = p.Results;

    denorm = r.denorm;

    %
    newds.DateTime = tspan';
    
    data = [In' Dis' Out'];
    %

    %
    if denorm
        mn  = [ics.Normalization.mean];
        std = [ics.Normalization.std];  
        mu    = [mn.in mn.dist mn.out];
        sigma = [std.in std.dist std.out];
        data = data.*sigma + mu;
    end
    i = 0;
    for ivar = ics.Vars
       i = i + 1;
       newds.(ivar{:}) =  data(:,i);
    end
    newds = struct2table(newds);
    newtable = TableSeries(newds);
    %
    unique_tspan = uniquetol(minutes(diff(tspan)),1e-2);
    if length(unique_tspan) == 1
        newTS = UniformTimeStamp(newtable,'DT',minutes(unique_tspan));
    else
        newTS = UniformTimeStamp(newtable);
    end
    new_cs = ControlSystem(newTS,ics.InputVars,ics.DisturbanceVars,ics.OutputVars);
    
end

