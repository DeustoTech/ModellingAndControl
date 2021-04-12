function newTs = RemoveVars(Ts,varargin)

%% Managment Input Variables
p = inputParser;

addRequired(p,'iTableSeries');
addOptional(p,'rmvars',{});

parse(p,Ts,varargin{:})


rmvars = p.Results.rmvars;
%%
i = 0;
newTs = Ts;
for iTableSeries = Ts
    i = i + 1;
    %
    Vars =  iTableSeries.DataSet.Properties.VariableNames;
    %
    for ivar = Vars
       if length(unique(iTableSeries.DataSet.(ivar{:}))) == 1 % constannt value must be remove 
           iTableSeries.DataSet.(ivar{:}) = [];
       elseif ismember(ivar{:},rmvars) 
          iTableSeries.DataSet.(ivar{:}) = [];
       end
    end
    newTs(i) = iTableSeries;
end
end

