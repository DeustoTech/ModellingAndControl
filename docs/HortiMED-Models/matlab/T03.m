% HORTSYS PARAMETERS
c1 = 2.82;
c2 = 74.66;
k = 0.70;
d = 0.5;
%

F = @(x) 0.5 - 0.5*exp( - (c1*k*d*x)./(c2+x));

xspan = linspace(0,1500,100);
figure(1)
fmt = {'Interpreter','latex','FontSize',20};
fmt_xy = [fmt(:)',{'FontSize'},{15}];
clf
hold on
plot(xspan,F(xspan))
grid on
st = 0.5-0.5*exp(-c1*k*d);
yline(st)
title('$\mathcal{F}(x_{pt})$',fmt{:})
xlabel('$x_{pt}[kJ]$',fmt_xy{:})
text(1000,0.015+st,'$\frac{1}{2}-\frac{1}{2}e^{-c_1 k d}$',fmt{:})
%%

ode45()