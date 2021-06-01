function [Inputs,Outputs,tspan,DateTime] = GenData(iNN,ics,varargin)
%%
            
    p = inputParser;

    addRequired(p,'ics')
    addOptional(p,'ind',[]);

    parse(p,ics,varargin{:})

    ind = p.Results.ind;

    if isempty(ind)
       ind =  1:length(ics.TableSeries);
    end

    %%
    newInputs = arrayfun(@(i)ics.Inputs{i}(:,1:end-1), ...
                         ind,'UniformOutput',0);
    %%
    newOutputs = arrayfun(@(i)ics.Outputs{i}(:,2:end), ...
                         ind,'UniformOutput',0);
    %%
    newDisturbance = arrayfun(@(i)ics.Disturbances{i}(:,1:end-1), ...
                         ind,'UniformOutput',0);
    %%
    Inputs = [[newInputs{:}];[newDisturbance{:}]];
    Outputs = [newOutputs{:}];

end

