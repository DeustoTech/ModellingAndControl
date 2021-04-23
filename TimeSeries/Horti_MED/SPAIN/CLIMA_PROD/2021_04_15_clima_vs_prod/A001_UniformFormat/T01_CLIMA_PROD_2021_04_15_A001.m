clear all
%
path_file =  '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset02.mat';
load(path_file)
%
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/PROD/2020_01_13_PROD/A001_UniformFormat/output/dataset03.mat')
%%
clima_ts = iTs_list;
for i = 1:6
produ_ts(i) = TableSeries((dataset03{i}));
end
%%
clf
subplot(4,1,1)
dates = [datetime('01-Jul-2016') datetime('01-Jan-2021')];
%
hold on 
grid on
for i = 1:6
    plot(produ_ts(i).DateTime,produ_ts(i).DataSet.Netokg,'.-')
end
xlim(dates)

j = 1;
for ivar = {'Tinv','Text'}
    j = j + 1;
    subplot(4,1,j)
    hold on
    grid on
    for i = 1:13
        plot(clima_ts(i).DateTime,clima_ts(i).DataSet.(ivar{:}),'.')
    end
    title(ivar{:})
    xlim(dates)
    ylim([0 50])
    yline(30)
    yline(10)

end

subplot(4,1,4)
hold on
grid on
for i = 1:13
    plot(clima_ts(i).DateTime,clima_ts(i).DataSet.Tinv -clima_ts(i).DataSet.Text ,'.')
end
xlim(dates)


%%
fullds = vertcat(clima_ts.DataSet);
fullts = vertcat(clima_ts.DateTime);
tspan = days(fullts -fullts(1))';
Text = fullds.Text';

mT = mean(Text);
sT = std(Text);
%Text = (Text - mT)/sT;
%%
plot(fullts,Text,'.')
%%
clf 

T = 365.2422 ;
coeff_an_base = floor(T*[ 1:T ].^(-1))';
coeff_bn_base = floor(T*[ 1:T ].^(-1))';

%
an_opt = zrand(size(coeff_an_base));
bn_opt = zrand(size(coeff_bn_base));
a0_opt = zrand;
 %
u_fcn_base = @(t,a0,an,bn) a0 + sum([an.*cos(2*pi*t.*coeff_an_base/T ) ; ...
                                     bn.*sin(2*pi*t.*coeff_bn_base/T )] );



LR = 0.001;
unum = u_fcn_base(tspan,a0_opt,an_opt,bn_opt);
delta = unum - Text;


clf
subplot(3,1,1)
hold on


plot(tspan,Text,'.');
%
newtspan = linspace(tspan(1),tspan(end),1e4);


unumfull = u_fcn_base(newtspan,a0_opt,an_opt,bn_opt);
ip =    plot(newtspan,unumfull);

%
subplot(3,1,2)
iplot_err = plot(0,log(0.5*mean(delta.^2)),'*-');
xlim([1 10000])

subplot(3,2,5)
ap_bar = bar(an_opt);
subplot(3,2,6)
bp_bar = bar(bn_opt);
%
Nt = length(tspan);
MinibachSize = 1000;

alphaL1 = 1e-4;
for iter = 1:10000
    
    
    ind = randsample(Nt,MinibachSize);
    delta =  u_fcn_base(tspan(ind),a0_opt,an_opt,bn_opt) - Text(ind);

    if mod(iter,100) == 0
        unumfull = u_fcn_base(newtspan,a0_opt,an_opt,bn_opt);

        ip.YData = unumfull ;
        iplot_err.XData(end+1) = iter;
        iplot_err.YData(end+1) = log(0.5*mean(delta.^2));
        %
        ap_bar.YData  = an_opt;
        bp_bar.YData  = bn_opt;
        pause(0.01);
        %
    end 

    a0_opt = a0_opt - LR*mean(delta) - LR*alphaL1*(a0_opt);
    an_opt = an_opt - LR*mean(delta.*cos(2*coeff_an_base.*pi.*tspan(ind)./T),2) - LR*alphaL1*(an_opt);
    bn_opt = bn_opt - LR*mean(delta.*sin(2*coeff_bn_base.*pi.*tspan(ind)./T),2) - LR*alphaL1*(bn_opt);
    
end


