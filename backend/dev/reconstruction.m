clear 

T = 1000;
Nt = 2000;
tspan = linspace(0,T,Nt);

Na = 20;
Nb = 20;
%
coef_a = randsample(2*Na,Na,false); 
coef_a = sort(coef_a);

coef_b = randsample(2*Nb,Nb,false);
coef_b = sort(coef_b);
%
a0 = 1e4*zrand;
an = zrand(Na,1); 
an(end) = 1e2*an(end);
an(end-4) = 1e2*an(end-4);

bn = zrand(Nb,1);
bn(end) = 1e2*bn(end);

% 
u = a0 + sum([an.*cos(2*pi*tspan.*coef_a/T ) ; ...
              bn.*sin(2*pi*tspan.*coef_b/T )] );


u = normalize(u);
u = max(u,0)
%% 
clear ind

L = 10;
for i = 1:2:L
ind{(i+1)/2} = (Nt/L)*(i-1)+randsample(floor(Nt/L),20*L)';
end
ind = sort([ind{:}]);

clf
subplot(4,1,1)
plot(tspan,u,'.-')
grid on
%ylim([-150 150])

subplot(4,1,2)
hold on
plot(tspan(ind),u(ind),'.')
grid on
%ylim([-150 150]) 


%%
u_fcn = @(t,a0,an,bn) a0 + sum([an.*cos(2*pi*t.*coef_a/T ) ; ...
                                bn.*sin(2*pi*t.*coef_b/T )] );

coeff_an_base = (1:50)';
coeff_bn_base = (1:50)';

an_opt = zrand(size(coeff_an_base));
bn_opt = zrand(size(coeff_bn_base));
a0_opt = zrand;

%
u_fcn_base = @(t,a0,an,bn) a0 + sum([an.*cos(2*pi*t.*coeff_an_base/T ) ; ...
                                     bn.*sin(2*pi*t.*coeff_bn_base/T )] );

%%
LR = 0.01;

ip =    plot(tspan,u_fcn_base(tspan,a0_opt,an_opt,bn_opt));
delta = u_fcn_base(tspan(ind),a0_opt,an_opt,bn_opt) - u(ind);

%%
%sign = @(x) tanh(x);
subplot(4,1,3)
iplot_err = plot(0,log(0.5*mean(delta.^2)),'*-');
xlim([1 100000])

subplot(4,2,7)
ap_bar = bar(an_opt);
subplot(4,2,8)
bp_bar = bar(bn_opt);
%
for iter = 1:100000
    
    delta =  u_fcn_base(tspan(ind),a0_opt,an_opt,bn_opt) - u(ind);

    if mod(iter,1000) == 0
        ip.YData = u_fcn_base(tspan,a0_opt,an_opt,bn_opt) ;
        iplot_err.XData(end+1) = iter;
        iplot_err.YData(end+1) = log(0.5*mean(delta.^2));
        %
        ap_bar.YData  = an_opt;
        bp_bar.YData  = bn_opt;
        pause(0.1);
        %
    end

    a0_opt = a0_opt - LR*mean(delta) - LR*1e-2*sign(a0_opt);
    an_opt = an_opt - LR*mean(delta.*cos(2*coeff_an_base.*pi.*tspan(ind)./T),2) - LR*1e-2*sign(an_opt);
    bn_opt = bn_opt - LR*mean(delta.*sin(2*coeff_bn_base.*pi.*tspan(ind)./T),2) - LR*1e-2*sign(bn_opt);
    
end