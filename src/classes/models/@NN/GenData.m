function [Inputs,Outputs,tspan,DateTime] = GenData(iNN,ics,varargin)
%%
            
    p = inputParser;

    addRequired(p,'ics')
    addOptional(p,'ind',[]);
    addOptional(p,'Nt',[]);

    parse(p,ics,varargin{:})

    Nt = p.Results.Nt;
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

    tspan  = arrayfun(@(i)ics.tspan{i}(:,2:end), ...
                ind ,'UniformOutput',0);
    tspan = [tspan{:}]';

    DateTime = arrayfun(@(i)ics.DateTime{i}(:,2:end), ...
                    ind ,'UniformOutput',0);
    DateTime = [DateTime{:}]';
    
    
    %%
    if ~isempty(Nt)
       DateTime = DateTime(1:Nt);
       tspan    = tspan(1:Nt);
       Inputs   = Inputs(:,1:Nt);
       Outputs  = Outputs(:,1:Nt);
    end
end

