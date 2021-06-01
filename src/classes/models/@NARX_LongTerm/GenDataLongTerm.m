function [InputMatrix,OutputMatrix] = GenDataLongTerm(iNARX,ics,varargin)

p = inputParser;

addRequired(p,'ics')
addOptional(p,'ind',[]);

parse(p,ics,varargin{:})
%
ind = p.Results.ind;
%%
if isempty(ind)
   ind =  1:length(ics.TableSeries);
end
%%
no = iNARX.No;
Nt = iNARX.Nt;

newDist = {};
newInput = {};
newDelay = {};
newOutputs = {};

for i = ind

    Dist = ics.Disturbances{i};
    Input = ics.Inputs{i};
    Output = ics.Outputs{i};
    amount_in = size(Dist,2) - Nt - no;

    if length(ics.tspan) > amount_in
        continue
    end

    newDist    = [newDist    arrayfun(@(j) [Dist(  : , (no+j-1):(no+j+Nt-2))], 1:amount_in ,'UniformOutput',0)];
    newInput   = [newInput   arrayfun(@(j) [Input( : , (no+j-1):(no+j+Nt-2))], 1:amount_in ,'UniformOutput',0)];
    newDelay   = [newDelay   arrayfun(@(j) [Output(: , (no+j)  :-1:(j+1))]   , 1:amount_in ,'UniformOutput',0)];
    newOutputs = [newOutputs arrayfun(@(j) [Output(: , (no+j)  : (no+j+Nt-1))] , 1:amount_in ,'UniformOutput',0)];

end
%%
nrows = length(newDist);

InputMatrix = zeros(no*ics.Nout + Nt*ics.Nin + Nt*ics.Ndis,nrows);
OutputMatrix = zeros(ics.Nout*Nt,nrows);

for k = 1:nrows
    InputMatrix(:,k) = [newDelay{k}(:) ; newInput{k}(:); newDist{k}(:)];
    OutputMatrix(:,k) = newOutputs{k}(:);
end

end

