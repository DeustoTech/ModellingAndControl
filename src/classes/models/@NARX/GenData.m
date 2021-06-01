function [Inputs,Outputs,tspan,DateTime] = GenData(iNARX,ics,varargin)

p = inputParser;

addRequired(p,'ics')
addOptional(p,'ind',[]);
addOptional(p,'Nt',[]);
addOptional(p,'init',1);

addOptional(p,'DeltaOutput',0);

parse(p,ics,varargin{:})


no = iNARX.No;
ind = p.Results.ind;
DeltaOutput = p.Results.DeltaOutput;

if isempty(ind)
   ind =  1:length(ics.TableSeries);
end

%% {x_t, u_t}  forall t \in {1,...,N_t}-> {x_{t+1} x_{t},x_{t-1}, u_t} \forall t \in {1,...,N_t-1}

newOutputs = cell(1,length(ics.TableSeries));

iter = 0;
for iou = ics.Outputs
    iter = iter + 1;
    %
    P = arrayfun(@(i) iou{:}(:,(no-i+1):(end-i))',1:no,'UniformOutput',false);
    newOutputs{iter} = [P{:}]';
end



newInputs = arrayfun(@(i)[ics.Inputs{i}(:,no:(end-1));newOutputs{i}], ...
                ind ,'UniformOutput',0);

newDisturbance = arrayfun(@(i)ics.Disturbances{i}(:,no:(end-1)), ...
                ind ,'UniformOutput',0);


newOutputs = arrayfun(@(i)ics.Outputs{i}(:,(no+1):end), ...
                ind ,'UniformOutput',0);

%
tspan  = arrayfun(@(i)ics.tspan{i}(:,no:end-1), ...
                ind ,'UniformOutput',0);
tspan = [tspan{:}]';

DateTime = arrayfun(@(i)ics.DateTime{i}(:,no:end-1), ...
                ind ,'UniformOutput',0);
DateTime = [DateTime{:}]';
%

Inputs = [[newInputs{:}];[newDisturbance{:}]];
Outputs = [newOutputs{:}];


%
if DeltaOutput
    preOutput = arrayfun(@(i)ics.Outputs{i}(:,no:(end-1)), ...
                ind ,'UniformOutput',0);

    preOutput = [preOutput{:}];
    %
    Outputs = Outputs - preOutput;
end

end

