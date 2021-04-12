T = 5;
L = 500
Fz = 120;
tspan = linspace(0,T,L);
%
fline = sin(2*pi*tspan)*0.5 + ...
        sin(2*pi*tspan/3)*0.5;

clf
subplot(2,1,1)
plot(tspan,fline)
subplot(2,1,2)
ifline = fft(fline);
plot(tspan,abs(ifline)/T)