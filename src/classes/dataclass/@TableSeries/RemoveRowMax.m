function newTs = RemoveRowMax(jTs,var,maxgrad)
    
    nTs = length(jTs);
    
    newTs = jTs;
    
    for i = 1:nTs
        f = jTs(i).DataSet.(var);
        
        ind = (maxgrad > f);
        
        newTs(i) = subselect(jTs(i),ind);
    end
end

