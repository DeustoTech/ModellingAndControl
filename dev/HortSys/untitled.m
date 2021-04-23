clear 

Tmin = 10;
Tob  = 17;
Tou  = 24;
Tmax = 30;
%
ndays = 50;
tspan = linspace(0,ndays,2000);
%
theta = @(x) 0.5 + 0.5*tanh(10*x);
sat = @(x) x.*theta(x);
%

uT = -5 + sat(20*sin(rand*2*pi*tspan)) + ...
     (30*sin(2*pi*tspan/(800*rand))) + ...
     1*rand(size(tspan));


ndt = 2000/ndays;

%% 
i_ini = 1:ndt:2000;
i_end = i_ini + ndt - 1;
%
%
uT_mean = arrayfun(@(i) mean(uT(i_ini(i):i_end(i))),1:ndays);

%% ode aproach
uT_fcn = @(t) interp1(tspan,uT,t,'linear','extrap');


[tspan_ode,uT_ode] = ode45(@(t,x)  (uT_fcn(t) - uT_fcn(t-1)),tspan(ndt+1:end),uT_mean(1));
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
plot(tspan_ode,uT_ode,'b.-')
yline(Tmax)
yline(Tmin)
yline(Tob)
yline(Tou)

legend('Discrete','Movil Mean','ode')
%%


TT = @(T) (T - Tmin)./(Tob - Tmin).*(Tmin<=T).*(T<Tob) + ...
            (Tob<=T).*(T<=Tou) + ...
           (Tmax - T)./(Tmax - Tou).*(Tou<T).*(T<=Tmax)  ;
       

%
TT_mean = arrayfun(@(i) mean(TT(uT(i_ini(i):i_end(i)))),1:ndays);
TT_mean_mov = movmean(TT(uT),ndt);

subplot(3,1,3)
hold on
plot(tspan(i_end),TT_mean,'-*')
plot(tspan,TT_mean_mov,'r.-')
