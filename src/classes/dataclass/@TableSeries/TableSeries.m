
classdef TableSeries
    %TABLESERIES object to save time series
    
    properties
        DateTime
        DataSet
    end
    
    properties (Dependent = true)
        tspan
        vars
        ndata
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
            obj = Sort(obj);
            %
            obj = RemoveRepeatMs(obj);
        end
        function r = get.tspan(obj)
            r = obj.DateTime - obj.DateTime(1);
        end    
        function r = get.vars(obj)
            r =  obj.DataSet.Properties.VariableNames;
        end
        function r = get.ndata(obj)
           r = size(obj.DataSet,1);
        end
    end

end

