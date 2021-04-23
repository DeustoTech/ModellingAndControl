clear 
parameters;

Tspan = linspace(0,50,500)
%
uT = @(z)  -0.5*tanh(eta_max*(z-Tmax_n)) -0.5*tanh(eta_min*(Tmin_n-z))
uTd = @(z) (Tmin<=z).*(z<Tob).*(z-Tmin)./(Tob-Tmin) + ...
           (Tob<=z).*(z<=Tou) + ...
           (Tou<z).*(z<Tmax).*(Tmax-z)./(Tmax-Tou) ;
%%
f = genfig
axes('FontSize',FontSizeAxes,'TickLabelInterpreter','latex')
hold on 
opt = {'LineWidth',2.5};
plot(Tspan,uT(Tspan),opt{:})
plot(Tspan,uTd(Tspan),'--',opt{:})
%
nopt = {'LineWidth',1.5};
xline(Tmin,nopt{:})
xline(Tmax,nopt{:})
xline(Tou,nopt{:})
xline(Tob,nopt{:})
il = legend('Smooth Version','HortSys','Interpreter','latex')
ntext = {'Interpreter','latex','FontSize',17};
grid on
title('$\mathcal{G}_{T}(u_T)$',ntext{:})
xlabel('$u_T(^\circ C )$',ntext{:})
box
print(f,'../img/uT_sm.eps','-depsc')