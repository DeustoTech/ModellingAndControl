classdef ControlSystem
    %CONTROLSERIES 
    
    
    properties (SetAccess = protected)
        TableSeries
        InputVars
        DisturbanceVars
        OutputVars 
    end
    
    properties
        Normalization  NormalizationCS
    end
    
    properties (Dependent = true , Hidden = true)
       Ndata
       Ndis
       Nin
       Nout
       %
       Inputs
       Outputs
       Disturbances
    end
    
    methods
        function obj = ControlSystem(iTableSeries,InputVars,DisturbanceVars,OutputVars)
            %CONTROLSERIES 
            obj.InputVars         =  InputVars;
            obj.DisturbanceVars   =  DisturbanceVars;
            obj.OutputVars        =  OutputVars;
            %
            obj.TableSeries = iTableSeries;
            %
            %
            if ~iTableSeries(1).UniformTimeStamp
                error('You must uniformed TimeStamp')
            end
            %
            vars = iTableSeries(1).vars;
            %
            if sum(ismember(InputVars,vars)) ~= length(InputVars)
                error('Some problem in InputVars ')
            end
            if sum(ismember(OutputVars,vars)) ~= length(OutputVars)
                error('Some problem in OutputVars ')
            end
            if sum(ismember(DisturbanceVars,vars)) ~= length(DisturbanceVars)
                error('Some problem in DisturbanceVars ')
            end
        end
        function r = get.Ndis(obj)
            r = length(obj.DisturbanceVars);
        end
        function r = get.Nin(obj)
            r = length(obj.InputVars);
        end
        function r = get.Nout(obj)
            r = length(obj.OutputVars);
        end
        function r = get.Ndata(obj)
            r = size(obj.TableSeries.DataSet,1);
        end
        %
        function r = get.Inputs(obj)
            r = obj.TableSeries.DataSet(:,obj.InputVars);
        end
        function r = get.Outputs(obj)
            r = obj.TableSeries.DataSet(:,obj.OutputVars);
        end
        function r = get.Disturbances(obj)
            r = obj.TableSeries.DataSet(:,obj.DisturbanceVars);
        end
    end
end

