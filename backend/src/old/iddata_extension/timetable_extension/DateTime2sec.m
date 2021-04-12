function [myDatetime] = DateTime2sec(DataSet)

DataSet.Date.Format = 'dd.MM.uuuu HH:mm';
DataSet.Time.Format = 'dd.MM.uuuu HH:mm';

myDatetime = DataSet.Date + timeofday(DataSet.Time);

% fijamos a cero  el instante de ti
myDatetime = myDatetime - myDatetime(1) ;


end

