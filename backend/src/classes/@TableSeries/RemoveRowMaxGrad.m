function newTs = RemoveRowMaxGrad(jTs,var,maxgrad)
    
    nTs = length(jTs);
    
    newTs = jTs;
    
    for i = 1:nTs
        tspan = minutes(jTs(i).DateTime-jTs(i).DateTime(1));
        f = jTs(i).DataSet.(var);
        gr = abs(gradient(f,tspan));
        
        ind = (maxgrad > gr);
        
        newTs(i) = subselect(jTs(i),ind);
    end
end

