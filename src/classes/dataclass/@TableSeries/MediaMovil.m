function  newTS = MediaMovil(TS,n,varargin)

    p = inputParser;
    addRequired(p,'Ts')
    addRequired(p,'n')

    addOptional(p,'exception',{})

    parse(p,TS,n,varargin{:})

    exception = p.Results.exception;
    newTS = TS;

    iter = 0;
    for iTS = TS
        iter = iter + 1;
        for ivar = iTS.vars
            if ismember(ivar{:},exception)
                continue
            end
          newTS(iter).DataSet.(ivar{:}) = movmean(iTS.DataSet.(ivar{:}),n); 
        end
    end
end

