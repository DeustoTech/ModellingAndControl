function [iTableSeries] = RemoveRepeatMs(iTableSeries)

myDateTime = iTableSeries.DateTime;
%
mindt = min(diff(myDateTime));

if mindt == 0
    bo_ind = diff(myDateTime) == mindt;
    % removemos medidas repetidas en el mismo segundo
    % esto es para tener una sola medida en cada tiempo 
    % dado que nuestro error de medida de tiempo es del segundo
    iTableSeries.DateTime(bo_ind) = [];
    iTableSeries.DataSet(bo_ind,:) = [];
end

end

