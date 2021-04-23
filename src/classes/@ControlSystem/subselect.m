function jcs = subselect(ics,ind)
%SUBSELECT Summary of this function goes here
%   Detailed explanation goes here

jcs = ics;
jcs.TableSeries = subselect(jcs.TableSeries,ind);
end

