%%
clear;
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_01_13_sysclima/A001_UniformFormat/output/dataset02.mat')
%%
vars = {'Text','RadExt','Tinv'}
ind = 136:5000;
tspan = hours(dataset02.DataTime(ind) - dataset02.DataTime(ind(1)));
% Ventanas 
figure(1)
clf
subplot(2,1,1)
grid on
hold on 
plot( dataset02.DataTime(ind) ,dataset02.Text(ind),'.-')
plot( dataset02.DataTime(ind) ,dataset02.Tinv(ind),'.-')
legend({'Text','Tint'})
subplot(2,1,2)
grid on
hold on
plot( dataset02.DataTime(ind) ,dataset02.EstadoCenitalE(ind),'.-')
plot( dataset02.DataTime(ind) ,dataset02.EstadoCenitalO(ind),'.-')
legend('Este','Oeste')
%
cmin = 0.5;
cmax = 1.8;

c_fun = @(V) cmin + (cmax-cmin)*(V/100);

F_T = @(Tin,Text,heat,V) -c_fun(V)*(Tin - Text) + heat;



Text_span = dataset02.Text(ind);
heat_span = 0*tspan + 1.5;
V_span = (dataset02.EstadoCenitalE(ind) + dataset02.EstadoCenitalO(ind))/2;
%V_span = 100 - V_span;
Text_fun = @(t) interp1(tspan,Text_span,t);
heat_fun = @(t) interp1(tspan,heat_span,t);
V_fun = @(t) interp1(tspan,V_span,t);


Tin_0 = Text_span(1) + 1;

[tpsan,Tin_span] = ode45(@(t,Tin) F_T(Tin,Text_fun(t),heat_fun(t),V_fun(t)),tspan,Tin_0);

%
figure(2)
clf
subplot(2,1,1)

plot(dataset02.DataTime(ind),Text_span,'.-')
%
hold on 
plot(dataset02.DataTime(ind),Tin_span,'.-')
plot( dataset02.DataTime(ind) ,dataset02.Tinv(ind),'.-')

legend('T_{ext}','T_{in}','T_{in real}')

grid on
subplot(2,1,2)
grid on
hold on
plot( dataset02.DataTime(ind) ,V_span,'.-')
legend('media')