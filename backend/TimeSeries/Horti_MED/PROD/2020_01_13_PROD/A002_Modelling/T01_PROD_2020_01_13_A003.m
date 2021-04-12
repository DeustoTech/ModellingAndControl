%%
clear 
% Parametros 
Tmin = 0;   % minimum Temperature 
Tmax = 30;  % maximun Temperature 
Tob = 10;   % lower ox_Pmal temperature 
Tou = 20;   % upper ox_Pmal temperature.
%
k = 1; % Extinction coefficient
%
c1 = 1;
c2 = 1;
% 
RUE = 4.01; % Radiation use efficiency (Gallardo 2014)
%
a = 7.55; % N concentration in dry biomass at end of the exponential growth period 
b = -0.15; % slope of the realationship
%% Variables Intermedias
F_TT = @(u_T) (    (Tmin<=u_T).*( u_T<Tob  )    ).*(    (u_T-Tmin)/(Tob-Tmin)  ) + ...
            (    (Tob<=u_T ).*( u_T<=Tou )    ).*(             1             ) + ...
            (    (Tou<u_T  ).*( u_T<=Tmax)    ).*(    (Tmax-u_T)/(Tmax-Tou)  )    ;
       
%
%Tspan = linspace(-50,50,100)
%plot(Tspan,TT(Tspan))

F_PAR = @(u_R) 0.5*u_R;
%
F_LAI =  @(x_P) (c1*x_P*d)/(c2 + x_P);
F_fPAR = @(x_P) 1 - exp(-k*F_LAI(x_P));
%
%
%% Variables de Esu_Tdo 
dx_P   = @(u_T,u_R,x_P) u_T*F_PAR(u_R)*F_fPAR(F_LAI(x_P));
dx_D   = @(u_R,x_P)     RUE*F_fPAR(F_LAI(x_P))*PAR(u_R);

per_dN =  @(u_R,x_P) a*dx_D(u_R,F_LAI(x_P))^(-b);
%
dx_N = @(N,u_R,x_P) (per_dN(N,u_R,x_P)/100)*dx_D(u_R,x_P);
%
%%
ETc = @(x_P,u_R,B) A*F_fPAR(x_P)*u_R*F_LAI(x_P)*VPD*B;
