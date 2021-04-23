function newTs = Concat(iTs)

full = vertcat(iTs.DataSet);
fulltime = horzcat(iTs.DateTime);
iTs(1).DataSet = full; 
iTs(1).DateTime = fulltime; 

newTs = iTs(1);
end

