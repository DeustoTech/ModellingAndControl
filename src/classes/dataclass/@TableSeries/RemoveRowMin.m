function newTs = RemoveRowMax(jTs,var,minvalue)
    
    nTs = length(jTs);
    
    newTs = jTs;
    
    for i = 1:nTs
        f = jTs(i).DataSet.(var);
        
        ind = (minvalue < f);
        
        newTs(i) = subselect(jTs(i),ind);
    end
end

