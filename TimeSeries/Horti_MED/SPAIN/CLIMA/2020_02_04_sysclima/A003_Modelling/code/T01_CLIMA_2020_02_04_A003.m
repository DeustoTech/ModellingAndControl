%%

clear
load("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/2020_02_04_sysclima/A001_UniformFormat/output/traj_1.3.2_without_heater.mat')
%%
tspan = minutes(dataset.Time);
Date = dataset.DateTime;
% 
AlarmRain = dataset.AlarmaLluvia;
uwe = dataset.EstadoCenitalE;
uwo = dataset.EstadoCenitalO;

%%
memo = 10;
%
x_T_span     = dataset.Tinv;
x_T_m_span   = movmean(x_T_span,memo);
%
%%
f_T_span   = dataset.Text;
f_T_m_span = movmean(f_T_span,memo);

f_R_span   = dataset.RadExt;
f_R_m_span   = movmean(f_R_span,memo);

dx_T_dt_span  = gradient(x_T_m_span,tspan);

%%
A = [ -(x_T_m_span-f_T_m_span) 3.6e3*f_R_m_span];

coeffs = pinv(A)*dx_T_dt_span;

cd = coeffs(1);
cR = 1/coeffs(2);

path =  "" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/2020_02_04_sysclima/A003_Modelling/output'
save(fullfile(path,'coeff.mat'),'cd','cR')
%%
f_T = @(t) interp1(tspan,f_T_m_span,t);
f_R = @(t) interp1(tspan,f_R_m_span,t);

%%
dx_T = @(t,x_Tinv) -cd*(x_Tinv - f_T(t)) + 3.6e3*(f_R(t))/cR;
x_T_0 = x_T_span(1);
[~, x_T_span_pred] = ode45(dx_T,tspan,x_T_0);
%%

RMSE = sqrt(mean((x_T_span - x_T_span_pred).^2));

fmt = {'Interpreter','latex','FontSize',25}
figure(1);
clf
subplot(4,1,1)
plot(Date,x_T_span_pred,'LineWidth',2.5)
hold on 
plot(Date,x_T_m_span,'LineWidth',2.5)
plot(Date,f_T_span,'--','Color',[0.5 0.5 0.5])
title("RMSE = "+RMSE+" ºC")
grid on
legend({'$x_{T}^{pred}$','$x_{T}^{real}$','$f_T^{real}$'},fmt{:})

subplot(4,1,2)
plot(Date,f_R_m_span)
ylabel('$Radiation$',fmt{:})
grid on

subplot(4,1,3)
plot(Date,AlarmRain)
ylim([-0.5 1.5])

subplot(4,1,4)
hold on
plot(Date,uwo)
plot(Date,uwe)
grid on
%%
fmt = {'Interpreter','latex','FontSize',16}

fig = figure('unit','norm','pos',[0 0 0.7 0.5]);
fig.Renderer = 'painters';

subplot(4,1,[1 2 3])
plot(Date,x_T_span_pred,'LineWidth',2.5)
hold on 
plot(Date,x_T_m_span,'LineWidth',2.5)
ylabel('Temperature')
plot(Date,f_T_span,'--','Color',[0.5 0.5 0.5])
title("$RMSE = "+RMSE+" ^\circ C$",fmt{:})
grid on
legend({'$x_{T}^{pred}$','$x_{T}^{real}$','$f_T^{real}$'},fmt{:})
yticklabels([])
subplot(4,1,4)
plot(Date,f_R_m_span,'LineWidth',2.5)
ylabel('Radiation')

grid on
legend({'$f_{r}$'},fmt{:})

path = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/HortiMED/TemperatureControlGreenHouse"
print(fullfile(path,'img','model-2.1.1.eps'),'-depsc',fig)