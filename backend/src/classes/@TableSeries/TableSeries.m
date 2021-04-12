classdef TableSeries
    %TABLESERIES object to save time series
    
    properties
        DateTime
        DataSet
        mean
        std
    end
    
    properties (Dependent = true)
        tspan
        vars
    end
    
    properties (Hidden)
        UniformTimeStamp = false
    end
    methods
        function obj = TableSeries(data)
            %TABLESERIES Save a data with time dependent
            obj.DateTime = data.DateTime;
            data.DateTime = [];
            obj.DataSet =  data;
            %
            obj = RemoveRepeatMs(obj);
        end
        function r = get.tspan(obj)
            r = obj.DateTime - obj.DateTime(1);
        end    
        function r = get.vars(obj)
            r =  obj.DataSet.Properties.VariableNames;
        end
    end

end

