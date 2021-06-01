function x_Tinv_pred = ComputePred(iTs,pplots,params)

ds = iTs.DataSet;
tspan = seconds(iTs.tspan);

x_Tinv = ds.Tinv;
%x_Hinv = ds.HRInt;
x_Rinv = ds.RadInt;
%% dis
d_Text = ds.Text;
d_Rext = ds.RadExt;
d_VV = ds.Vviento;
d_VD = ds.DireccinViento;
d_LL = ds.AlarmaLluvia;
%% Controles
u_ce  = ds.EstadoCenitalE;
u_co  = ds.EstadoCenitalO;
u_pa  = ds.EstadoPant1;
%

%%

%Ft = @(t) interp1(tspan,[d_Text x_Rinv u_ce u_co u_pa],t);
Ft = griddedInterpolant(tspan,[d_Text x_Rinv u_ce u_co u_pa d_VV d_LL]);


%%
%plot(Tinv_span, Tinv2u(Tinv_span))
%%

    x_Tinv_0 = x_Tinv(1);

    options = odeset('RelTol',1e-3,'AbsTol',1e-3);


    %[~,xt] = ode15s(@(t,x_Tinv) F(x_Tinv,Ft(t),params), ...
    %                                   tspan,[x_Tinv_0;x_Tinv_0;0],options);
    
    [~,xt] = ode15s(@(t,x_Tinv) F(x_Tinv,Ft(t),params), ...
                                       tspan,[x_Tinv_0;x_Tinv_0;0]);
    %
    x_Tinv_pred = xt(:,1);
    x_h = xt(:,2);
    s_h = xt(:,3);

    DateTime = iTs.DateTime;
    
    
    %%
    Tspan = linspace(0,30);
    plot(Tspan,Tinv2u(Tspan,1))
    %%
    %xl = [datetime('2017-04-11 16:00:00') datetime('2017-04-14 02:00:00')];
    if pplots
        clf
        uip = uipanel('Parent',gcf,'unit','norm','pos',[-0.14 -0.1 1.2 1.17]);
        subplot(6,1,1,'Parent',uip)
        hold on
        plot(DateTime,x_Tinv,'r--')
        plot(DateTime,d_Text,'b--')
        plot(DateTime,x_h,'Marker','.')


        plot(DateTime,x_Tinv_pred,'r','LineWidth',2,'Marker','.')
        %xlim(xl)
        %
        legend('Tinv','Text','Theater','Tinv_pred','Interpreter','none')
        grid on

        subplot(6,1,2,'Parent',uip)
        hold on
        plot(DateTime,u_co,'Marker','.')
        plot(DateTime,u_ce,'Marker','.')
        legend('CenitalO','CenitalE')
               % xlim(xl)

        grid on

        subplot(6,1,3,'Parent',uip)
        hold on
        plot(DateTime,d_Rext,'Marker','.')
        plot(DateTime,x_Rinv,'Marker','.')
        legend('RadExt','RadInt')
           %     xlim(xl)

        grid on

        subplot(6,1,4,'Parent',uip)
        plot(DateTime,u_pa,'Marker','.')
             %   xlim(xl)

        legend('Pant')

%         subplot(6,1,5,'Parent',uip)
%         plot(DateTime,d_VV,'Marker','.')
%            %     xlim(xl)
% 
%         legend('Velocidad Viento')
%         
%         subplot(6,1,6,'Parent',uip)
%         plot(DateTime,cos(d_VD*(pi/180)),'Marker','.')
%         yyaxis right
%         plot(DateTime,d_VD,'Marker','.')
%          % xlim(xl)
% 
%         legend('cos','Direc Viento')
        
        subplot(6,1,5,'Parent',uip)

        plot(DateTime,d_LL,'Marker','.')
        legend('Alarma Lluvia')

        subplot(6,1,6,'Parent',uip)
        plot(DateTime,s_h,'Marker','.')

    end
end

function [dx] = F(x,Ft,p)
        
    Tinv = x(1);
    xh  = x(2);
    sh = x(3);
    %
    Text = Ft(1);
    Rad  = Ft(2);
    u_ce = Ft(3);
    u_co = Ft(4);
    u_pa = Ft(5);
    d_VV = Ft(6);
    d_LL = Ft(7);
    %%
    DT = Text-Tinv;
    %%
    ts = p.TasaVen;
    
    perc = (u_co + u_co)/200;
    
    
    G = perc*ts.Acenital*0.5*ts.Cd* ...
            sqrt(0.5*p.Height* p.g * abs(DT)*p.Height/(Text+273) + ts.Cw*d_VV^2);
    %%
    dxTinv = p.rhocpV * p.SS * ( (p.U  ) * DT )  + ...
             p.rhocpV * p.Area * Rad  + ...
             G/p.Volumen*DT  + 1e-3*(xh-Tinv); 
    
 
    s = Tinv2u(xh,sh);
    
    
    dxh  =  1.8*(Tinv-xh) + 1.8*(Text-xh) + 1e1*s;
    
    dsh = 1e3*(-sh + s);
    
    %dxh = 0;
    
    dx = [dxTinv ;dxh;dsh];
    %
    
end


function r = Tinv2u(ix,s)

    a = 10;
    b = 15;
    %
    
    x0 = (b-a)*s + a;
    r =  sigmoi(-ix+x0);
end



function r = relu(x)
    r = x.*(0.5+0.5*tanh(50*x));
end

function r = sigmoi(x)
    r = (0.5+0.5*tanh(50*x));
end


function r = win(x,a,b)
    r = sigmoi(x-a).*sigmoi(b-x);
end