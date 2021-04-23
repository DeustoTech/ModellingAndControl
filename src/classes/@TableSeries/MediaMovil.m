function  newTS = MediaMovil(TS,n)
    newTS = TS;

    iter = 0;
    for iTS = TS
        iter = iter + 1;
        for ivar = iTS.vars
          newTS(iter).DataSet.(ivar{:}) = movmean(iTS.DataSet.(ivar{:}),n); 
        end
    end
end

