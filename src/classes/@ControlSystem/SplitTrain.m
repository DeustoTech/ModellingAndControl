function [ics_train,ics_test] = SplitTrain(ics,varargin)
    p = inputParser;
    addRequired(p,'ics')
    addOptional(p,'percent',80)

    %
    parse(p,ics,varargin{:})
    %
    percent     = p.Results.percent;
    %
    ndata = length(ics.TableSeries.DateTime);
    nsplit = floor(ndata*percent/100);
    %
    ics_train = subselect(ics,1:nsplit);
    ics_test  = subselect(ics,nsplit+1:ndata);

end

