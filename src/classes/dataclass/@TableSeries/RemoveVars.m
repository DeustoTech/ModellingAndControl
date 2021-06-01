function newTs = RemoveVars(Ts,varargin)

%% Managment Input Variables
p = inputParser;

addRequired(p,'iTableSeries');
addOptional(p,'rmvars',{});
addOptional(p,'verbose',0);

parse(p,Ts,varargin{:})

verbose = p.Results.verbose;

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
          if verbose
            fprintf("Ha sido eliminado la variable: "+ivar{:}+"\n")
          end
       elseif ismember(ivar{:},rmvars) 
          iTableSeries.DataSet.(ivar{:}) = [];
          if verbose
            fprintf("Ha sido eliminado la variable: "+ivar{:}+"\n")
          end
       end
    end
    newTs(i) = iTableSeries;
end
end

