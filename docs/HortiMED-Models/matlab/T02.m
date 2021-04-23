
%
clear 
parameters

x_ptt_span = linspace(0,5e2,1000);
%
Nd = 11;
dspan = linspace(0,3,Nd);
color = jet(Nd);
%
f = genfig;
axes('FontSize',FontSizeAxes,'TickLabelInterpreter','latex')
G_LAI  = @(x_ptt,d) d*c1*x_ptt./(c2 + x_ptt);  
G_fpar = @(x,d) 1 - exp(-k*x);

i = 0;
for id = dspan 
    i = i + 1;
    line(x_ptt_span,G_fpar(G_LAI(x_ptt_span,id)),'Color',color(i,:),'LineWidth',2)
end

opts = {'Interpreter','latex','FontSize',FontSize};
xlabel('$x_{pt}[J/s]$',opts{:})
title('$\mathcal{F}_{par}(x_{pt}) [m^2/m^2]$',opts{:})
ic = colorbar('TickLabelInterpreter','latex');
ic.Label.String = '$d$';
ic.Label.Interpreter ='latex';
ic.Label.FontSize = FontSize;
ic.TickLabels =arrayfun(@(i) num2str(dspan(i)),1:Nd,'UniformOutput',false)';

colormap(color)
grid on 
box
print(f,'../img/F_x_pt.eps','-depsc')
%%