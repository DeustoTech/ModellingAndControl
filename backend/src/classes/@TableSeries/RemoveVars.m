function iTableSeries = RemoveVars(iTableSeries,varargin)

%% Managment Input Variables
p = inputParser;

addRequired(p,'iTableSeries');
addOptional(p,'rmvars',{});

parse(p,iTableSeries,varargin{:})

rmvars = p.Results.rmvars;
%%
Vars =  iTableSeries.DataSet.Properties.VariableNames;

for ivar = Vars

   if length(unique(iTableSeries.DataSet.(ivar{:}))) == 1 % constannt value must be remove 
       iTableSeries.DataSet.(ivar{:}) = [];
   elseif ismember(ivar{:},rmvars) 
      iTableSeries.DataSet.(ivar{:}) = [];
   end
end

end

