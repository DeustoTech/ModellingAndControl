
function [newTS] = UniformTimeStamp(TableSeries,varargin)
    %
    p = inputParser;
    addRequired(p,'TableSeries')
    addOptional(p,'DT',minutes(1));

    parse(p,TableSeries,varargin{:})

    DT = p.Results.DT;

    %%
    newTS = TableSeries;
    iter = 0;
    for iTableSeries = TableSeries
        DataSet = iTableSeries.DataSet;

        myDatetime = iTableSeries.tspan;
        %% STEP 1 
        % re span con el mínimo tiempo

        new_myDateTime = myDatetime(1):DT:myDatetime(end);
        %% STEP 2
        % interpolamos la tabla  
        new_DataSet = [];

        %new_DataSet.DateTime = new_DateTime';
        for ivar = DataSet.Properties.VariableNames
            new_DataSet.(ivar{:}) = interp1(myDatetime,DataSet.(ivar{:}),new_myDateTime,'linear')';
        end
        new_DataSet = struct2table(new_DataSet);

        iTableSeries.DataSet = new_DataSet;
        iTableSeries.DateTime = iTableSeries.DateTime(1) + new_myDateTime;
        %
        iTableSeries.UniformTimeStamp = true;
        iter = iter + 1;
        newTS(iter) = iTableSeries;
    end
end

