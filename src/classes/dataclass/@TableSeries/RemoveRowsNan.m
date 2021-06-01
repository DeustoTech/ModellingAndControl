function iTs = RemoveRowsNan(iTs)

for i = 1:length(iTs)
    ind = isnan(sum(iTs(i).DataSet{:,:},2));
    if sum(ind)
        fprintf("Table "+i+": We remove "+sum(ind)+" rows of "+length(iTs(i).DateTime)+"\n")
    end
    iTs(i).DataSet(ind,:) = [];
    iTs(i).DateTime(ind)  = [];
end

end

