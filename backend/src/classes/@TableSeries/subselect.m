function jTs = subselect(iTs,ind)
%SUBSELECT Summary of this function goes here
%   Detailed explanation goes here

jTs = iTs;
jTs.DateTime = iTs.DateTime(ind);
jTs.DataSet  = iTs.DataSet(ind,:);

end

