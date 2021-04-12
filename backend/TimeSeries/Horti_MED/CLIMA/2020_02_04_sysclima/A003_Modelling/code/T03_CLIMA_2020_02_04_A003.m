%%
% Consideramos que hay heater

clear
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_04_sysclima/A003_Modelling/output/coeff.mat')

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_04_sysclima/A001_UniformFormat/output/traj_1.3.2_with_heater.mat')
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
u_T_span_pred = dx_T_dt_span + cd*(x_T_m_span - f_T_m_span) - 3.6e3*( f_R_m_span/cR);

u_T_span_pred =  max(0,u_T_span_pred).*double(x_T_m_span<12);

%%
f_T = @(t) interp1(tspan,f_T_m_span,t);
f_R = @(t) interp1(tspan,f_R_m_span,t);
u_T = @(t) interp1(tspan,u_T_span_pred,t);
%%
dx_T = @(t,x_Tinv) -cd*(x_Tinv - f_T(t)) + 3.6e3*(f_R(t))/cR + u_T(t);
x_T_0 = x_T_span(1);
[~, x_T_span_pred] = ode45(dx_T,tspan,x_T_0);
%%

RMSE = sqrt(mean((x_T_span_pred-x_T_m_span).^2));
%%
fmt = {'Interpreter','latex','FontSize',16}

fig = figure('unit','norm','pos',[0 0 0.7 0.6]);
fig.Renderer = 'painters';

subplot(2,1,1)
plot(Date,x_T_span_pred,'LineWidth',2.5)
hold on 
plot(Date,x_T_m_span,'LineWidth',2.5)
plot(Date,f_T_span,'--','Color',[0.5 0.5 0.5])
title("$RMSE = "+RMSE+" ^\circ C$",fmt{:})
grid on
legend({'$x_{T}^{pred}$','$x_{T}^{real}$','$f_T^{real}$'},fmt{:})
subplot(2,1,2)
plot(Date,u_T_span_pred,'LineWidth',2.5)
legend('$u_T^{pred}$',fmt{:})
%path = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/HortiMED/TemperatureControlGreenHouse"
%print(fullfile(path,'img','model-2.1.1.eps'),'-depsc',fig)