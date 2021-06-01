function [HRA] = DateTime2HRA(LocalTime,Longitud,DGMT)

LSTM = 15*DGMT;        % Mardrid GMT+2

%%
d = DayOfYear(LocalTime);
B = (360/365)*d*(-81)*(pi/180);
EoT = 9.88*sin(B) - 7.53*cos(B) - 1.5*sin(B);
%%
TC = 4*(Longitud - LSTM) + EoT;
TC = hours(TC/60);
%%
LST = LocalTime + TC;
%%
newmid = LocalTime;
newmid.Hour = 12;
newmid.Minute = 0;
newmid.Second = 0;
%
HRA = 15*hours(LST-newmid);

end

