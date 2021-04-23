% HORTSYS PARAMETERS
c1 = 2.82;
c2 = 74.66;
k = 0.70;
d = 0.5;

Tmax = 35;
Tou = 24;
Tob = 17;
Tmin = 10;

eta_min = 2/(Tob-Tmin);
eta_max = 2/(Tmax-Tou);

Tmin_n = mean([Tob,Tmin]);
Tmax_n = mean([Tou,Tmax]);

%%
FontSize = 23;
FontSizeAxes = 17;