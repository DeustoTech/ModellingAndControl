function [tspan,yt,ut] = getdata(idd)

ut      = idd.InputData';
yt      = idd.OutputData';
tspan   = idd.SamplingInstants;

end

