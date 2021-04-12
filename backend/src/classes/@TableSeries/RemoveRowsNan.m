function iTs = RemoveRowsNan(iTs)

for i = 1:length(iTs)
    ind = isnan(sum(iTs(i).DataSet{:,:},2));
    iTs(i).DataSet(ind,:) = [];
    iTs(i).DateTime(ind)  = [];
end

end

