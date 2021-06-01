function jTs = subselect_date(iTs,date)
%SUBSELECT Summary of this function goes here
%   Detailed explanation goes here

ind = (iTs.DateTime >date(1)).*(iTs.DateTime < date(2));
ind = logical(ind);
jTs = iTs;
jTs.DateTime = iTs.DateTime(ind);
jTs.DataSet  = iTs.DataSet(ind,:);

end

