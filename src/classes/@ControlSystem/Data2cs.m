function new_cs = Data2cs(ics,tspan,In,Out,Dis)
    
    %
    newds.DateTime = tspan';
    
    data = [In' Dis' Out'];
    %
    mn  = [ics.Normalization.mean];
    std = [ics.Normalization.std];

    %
    mu    = [mn.in mn.dist mn.out];
    sigma = [std.in std.dist std.out];
    %
    data = data.*sigma + mu;
    i = 0;
    for ivar = ics.Vars
       i = i + 1;
       newds.(ivar{:}) =  data(:,i);
    end
    newds = struct2table(newds);
    newtable = TableSeries(newds);
    %
    unique_tspan = unique(diff(tspan));
    if length(unique_tspan) == 1
        newTS = UniformTimeStamp(newtable,'DT',unique_tspan);
    else
        newTS = UniformTimeStamp(newtable);
    end
    new_cs = ControlSystem(newTS,ics.InputVars,ics.DisturbanceVars,ics.OutputVars);
    
end

