clear 

parameters;


G_LAI  = @(x_pt,d) d*c1*x_pt./(c2 + x_pt);  
G_fpar = @(x) 1 - exp(-k*x);

F_par = @(x_pt,d) G_fpar(G_LAI(x_pt,d));

tspan = linspace(0,50);
clf

uR = 1e3;
%
Nd = 100;
initcont = 10.^linspace(5,-7,Nd);
color = jet(Nd);
i = 0;
for iint = initcont
    i = i + 1;
    %
    [~,xt{i}] = ode45(@(t,x) uR*F_par(x,d),tspan,iint);
    line(log(xt{i}),tspan,'Color',color(i,:))
    %
    logx{i} = log(xt{i});
end


%