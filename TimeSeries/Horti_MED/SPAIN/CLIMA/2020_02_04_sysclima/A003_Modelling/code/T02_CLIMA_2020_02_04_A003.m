
clf
subplot(2,1,1)
minT = 14;

x_Tinv_span = dataset02.Tinv;
f_Text_span = dataset02.Text;
f_Rext_span = dataset02.RadExt;
u_Win_E_span  = dataset02.EstadoCenitalO;
u_Win_O_span  = dataset02.EstadoCenitalE;
u_Win_span = 0.5* u_Win_E_span + 0.5 + u_Win_O_span;
Date  = dataset02.DateTime;
tspan = minutes(dataset02.Time); 

%% Find Heater Signal

%%

cd_min = 0.04;
cd_max = 0.09;

cH = 7e4;
cR = 9e6;

% 
f_Text = @(t) interp1(tspan,f_Text_span,t);
f_R    = @(t) interp1(tspan,f_Rext_span,t);
%

%%%%%

u_Pelet_span = max(double(-x_Tinv_span + minT)',0);
u_Pelet = @(t) interp1(tspan,u_Pelet_span,t);

%%%%%
u_T_span_noPelet =  double(x_Tinv_span - minT)';
u_T_noPelet = @(t) interp1(tspan,u_T_span_noPelet,t);

%%%%%%%%%%
u_Win = @(t) interp1(tspan,u_Win_span,t);

cd = @(u) cd_min + (cd_max - cd_min)*u/100;
%

cpelet1 = 1.5;
cpelet2 = 0.3;
%
dx_Tint  = @(t,X_Tint,u_T) -cd(u_Win(t))*(X_Tint - f_Text(t) ) + 3.6e3* ( 0*u_T/cH + f_R(t)/cR );
du_T     = @(t,u_T)    -cpelet1*u_T + u_Pelet(t)/cpelet2;

%
x_Tint_0 = x_Tinv_span(1);
u_T_0 = 0;

%
%[tspan,X_pred] = ode23(@(t,X) [dx_Tint(t,X(1),X(2)) ; du_T(t,X(2))],tspan,[x_Tint_0 u_T_0]);

%[tspan,X_pred] = ode23(@(t,X) [dx_Tint(t,X(1),u_T_noPelet(t)) ; du_T(t,X(2))],tspan,[x_Tint_0 u_T_0]);

%x_Tin_pred = X_pred(:,1);
%u_T_pred   = X_pred(:,2);
%

clf
subplot(4,1,1)

plot(Date,x_Tinv_span,'color','b','LineWidth',3)
hold on

%plot(Date,x_Tin_pred,'color',[0.4 0.8 0.8],'LineWidth',3)

plot(Date,f_Text_span,'r')
grid on

yline(minT)
legend('$x_{T_{in}}$','$x_{T_{in}}^{pred}$','$f_{T_{ext}}$','FontSize',20,'Interpreter','latex')

subplot(4,1,4)
plot(Date,f_Rext_span)
grid on
%%%%%%%%%%%%%%%%%%%%
subplot(4,1,3)
plot(Date,u_Win_E_span)
hold on
plot(Date,u_Win_O_span)
grid on

subplot(4,1,2)
%plot(Date,u_T_pred)
grid on

