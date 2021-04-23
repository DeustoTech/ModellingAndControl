function jTs = cut(iTs,TH)
    ind =days(diff(iTs.DateTime)) > TH;
    ind = find(ind);
    ind = ind; 
    init = 1+[1 ;ind];
    ends = [ind; length(iTs.DateTime)]-1;
    
    for i = 1:length(init)
        jTs(i) = subselect(iTs,[init(i):ends(i)]);
    end
end

