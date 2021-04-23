function iTs = Sort(iTs)
    [~,ind] = sort(iTs.DateTime);
    %
    iTs.DataSet = iTs.DataSet(ind,:);
    iTs.DateTime = iTs.DateTime(ind,:);

end

