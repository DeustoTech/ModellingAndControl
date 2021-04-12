function iTs = RemoveRowsNan(iTs)

ind = isnan(sum(iTs.DataSet{:,:},2));
iTs.DataSet(ind,:)= [];
iTs.DateTime(ind)= [];

end

