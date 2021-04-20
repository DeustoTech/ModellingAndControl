clear 

Tmin = 10;
Tob  = 17;
Tou  = 24;
Tmax = 30;
%
ndays = 200;
tspan = linspace(0,ndays,2000);
%
theta = @(x) 0.5 + 0.5*tanh(10*x);
sat = @(x) x.*theta(x);
%

uT = -5 + sat(20*sin(2*pi*tspan)) + ...
     (30*sin(2*pi*tspan/800)) + ...
     rand(size(tspan));


ndt = 2000/ndays;

%% 
i_ini = 1:ndt:2000;
i_end = i_ini + ndt - 1;
%
%
uT_mean = arrayfun(@(i) mean(uT(i_ini(i):i_end(i))),1:ndays);

%% ode aproach
uT_fcn = @(t) interp1(tspan,uT,t,'nearest');

[~,uT_ode] = ode23(@(t,x) [(uT_fcn(t) - x(1))],tspan,14);
%%
clf
subplot(3,1,1)
plot(tspan,uT)
%
subplot(3,1,2)
hold on
grid on
plot(tspan(i_end),uT_mean,'*') 
plot(tspan,movmean(uT,ndt),'.-')
plot(tspan,uT_ode,'b.-')
yline(Tmax)
yline(Tmin)
yline(Tob)
yline(Tou)


%%


TT = @(T) (T - Tmin)./(Tob - Tmin).*(Tmin<=T).*(T<Tob) + ...
            (Tob<=T).*(T<=Tou) + ...
           (Tmax - T)./(Tmax - Tou).*(Tou<T).*(T<=Tmax)  ;
       

%
TT_mean = arrayfun(@(i) mean(TT(uT(i_ini(i):i_end(i)))),1:ndays);
TT_mean_mov = movmean(TT(uT),ndt);

subplot(3,1,3)
hold on
plot(tspan(i_end),TT_mean,'*')
plot(tspan,TT_mean_mov,'r.-')
