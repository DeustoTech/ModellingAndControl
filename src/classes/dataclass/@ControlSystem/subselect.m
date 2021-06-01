function jcs = subselect(ics,ind1,ind2)
%SUBSELECT Summary of this function goes here
%   Detailed explanation goes here

jcs = ics;
jcs.TableSeries(ind1) = subselect(jcs.TableSeries(ind1),ind2);
end

