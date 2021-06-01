function [delta] = Day2Declination(LocalTime)

d = DayOfYear(LocalTime);
delta = - 23.45*cos((360/365)*(d+10)*(pi/180));

end

