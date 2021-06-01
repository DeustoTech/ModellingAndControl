function d = DayOfYear(DateTime)

first = DateTime;
first.Day = 01;
first.Month = 01;

d = days(DateTime - first)+1;
end

