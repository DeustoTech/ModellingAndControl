clear 
load(MainPath+"/TimeSeries/Horti_MED/SPAIN/CLIMA/2020-04-26-SYSCLIMA/A001_UniformFormat/output/Ts_sysclima_01.mat")
%%
iTs = RemoveVars(iTs,'verbose',1,'rmvars',{'EstadoLateralE','Sonda1','Sonda2', ...
                                           'Sonda3','Sonda5','Sonda6', ...
                                           'Aerotermo1Activo','DeltaT','DeltaX', ...
                                           'Troco','RadAcumExt', ...
                                           'DPV','DemPant1'});
%%
iTs = RemoveRowMax(iTs,'Tinv',60);
iTs = RemoveRowMin(iTs,'Tinv',-10);

iTs = RemoveRowMaxGrad(iTs,'Tinv',5);
%%
xlims = [datetime('2018-02-20') datetime('2018-02-25')];
ShowData(iTs,'xlim',[])

%%
clf

dt = 0.05;
start = datetime('2017-02-01');


no_heater = {};
heater = {};

niht = 0;
iht = 0;
%
Temp_span = linspace(-20,20,100);
plots = false;
dataTs = {};

data = [];
for i = 1:300
    figure(1)

    xlims = [start start+3*hours(24)]+(i-1)*hours(24)*3;
   
    subTs = subselect_date(iTs,xlims);
    if subTs.ndata == 0
       fprintf("n: "+i+" ---- none -----\n")
       th(i) =  nan;
       continue 

    end

    tspan = hours(subTs.DateTime-subTs.DateTime(1));
    Tinv = subTs.DataSet.Tinv;
    RadExt = subTs.DataSet.RadExt;

    Text = subTs.DataSet.Text;
    %
    ind = (RadExt>5);

    
    tspan_uniform = tspan(1):dt:tspan(end);
    L =ceil(tspan(end)/dt);
    if length(tspan_uniform) ~= L
       fprintf("n: "+i+" ---- none -----\n")
       th(i) =  nan;

       continue 
       
    end
    
    Diff = Tinv - Text;
    %
    dTinv = gradient(movmean(Tinv,20),tspan);
    dTinv(ind) = nan;
    %
    
    dTinv(abs(dTinv)>1e3) = 0;

    ylim([-15 15])
    mu = mean(dTinv,'omitnan');
    sigma = std(dTinv,'omitnan');
    
    th(i) =  mu+2*sigma;
    if mu+2*sigma > 4
        iht = iht + 1;
        heater{iht} = subTs;
        fprintf("n: "+i+"heater\n")
    else
        niht = niht + 1;
        no_heater{niht} = subTs;
        fprintf("n: "+i+"no heater\n")
    end
    
    ndt = dTinv(~isnan(dTinv));
    nDiff = Diff(~isnan(dTinv));
    data(:,i) = [mean(ndt) std(ndt) skewness(ndt)];
  
    dataTs{i} = subTs;
    
    
    if plots
        clf
        ShowDataSelect(subTs,{11:13,7:8,4:5,[9 10 6],1:2},'window',1,'vertical',1)
    
        cla
        hold on
        plot(subTs.DateTime,Diff)
        yline(0)


        plot(subTs.DateTime,dTinv)
        %

        figure(3)
        clf
        hold on
        histogram(dTinv,'Normalization','probability')
        xlim([-20 20])
        ylim([0 0.5])


        plot(Temp_span,(1/(sqrt(2*pi)*sigma))*exp(-(Temp_span-mu).^2/sigma.^2))
        xline(4,'Color','b','LineWidth',3)
        xline(mu+2*sigma)
        pause(1)
    %
    end
    
end
%%
no_heater = [no_heater{:}];
heater = [heater{:}];

%%
pathfile = fullfile(MainPath,'TimeSeries','Horti_MED','SPAIN','CLIMA', ...
                    '2020-04-26-SYSCLIMA','A001_UniformFormat', ...
                    'output','no_heater.mat');

save(pathfile,'no_heater')
%%
pathfile = fullfile(MainPath,'TimeSeries','Horti_MED','SPAIN','CLIMA', ...
                    '2020-04-26-SYSCLIMA','A001_UniformFormat', ...
                    'output','heater.mat');

save(pathfile,'heater')

%%
clf
%ShowDataSelect(no_heater(1),{11:13,7:8,4:5,[9 10 6],1:2},'window',1,'vertical',1)
ShowDataSelect(heater(6),{11:13,7:8,4:5,[9 10 6],1:2},'window',1,'vertical',1)


%%


k = 4;
err = [];
for k = 1:10
    [idx,C,ss] = kmeans(data',k);
    err(k) = sum(ss);
end
clf
plot(1:10,(err),'.-')
%%
fig =figure(1)
clf
hold on

rng(0)
names = {'mean','std','asym'};
k = 2
colors = hsv(k);

[idx,C,ss,D] = kmedoids(data',k);

for ik = 1:k

        hold on
        plot3(data(1,idx==ik),data(2,idx==ik),data(3,idx==ik),'.','MarkerSize',12,'Color',colors(ik,:))
        view(45,45)
        grid on


end
ax = fig.Children(1);

ll = plot3(data(1,1),data(2,1),data(3,1),'.','MarkerSize',50,'Color','k');

xlabel('mean')
ylabel('std')
zlabel('asym')


grid on
%%

allsubTs = dataTs((idx==4));

for subTs = allsubTs
subTs = subTs{:};
figure(2)
clf
ShowDataSelect(subTs,{11:13,7:8,4:5,[9 10 6],1:2},'window',1,'vertical',1)

tspan = hours(subTs.DateTime-subTs.DateTime(1));

Tinv = subTs.DataSet.Tinv;

dTinv = gradient(movmean(Tinv,20),tspan);
dTinv(ind) = nan;
%

dTinv(abs(dTinv)>1e3) = 0;

figure(3)
clf
hold on
histogram(dTinv,'Normalization','probability')
xlim([-20 20])
ylim([0 0.5])


plot(Temp_span,(1/(sqrt(2*pi)*sigma))*exp(-(Temp_span-mu).^2/sigma.^2))
xline(4,'Color','b','LineWidth',3)
xline(mu+2*sigma)
pause(1)


end
%%


allsubTs = dataTs();

iter = 0;

%ind_no_clear = min(D(:,1),D(:,2)) > 4;
ind_no_clear = abs(D(:,1)-D(:,2))<5;

inht = 0;
iht = 0;

no_heater = {};
heater = {};
for subTs = allsubTs
    
    
    iter = iter +1;
subTs = subTs{:};


    if isempty(subTs)
        continue
    end
    
    if  ind_no_clear(iter)
        continue
    end
figure(2)
clf
ShowDataSelect(subTs,{11:13,7:8,4:5,[9 10 6],1:2},'window',1,'vertical',1)

tspan = hours(subTs.DateTime-subTs.DateTime(1));

Tinv = subTs.DataSet.Tinv;

dTinv = gradient(movmean(Tinv,20),tspan);
dTinv(ind) = nan;
%
ll.XData = data(1,iter);
ll.YData = data(2,iter);
ll.ZData = data(3,iter);

if ind_no_clear(iter)
    ll.Color = 'k';
else
    ll.Color = 'g';

end
    
switch idx(iter)
    case 1
        inht = inht + 1;
        no_heater{inht} = subTs;


    case 2
        iht = iht + 1;
        heater{iht} = subTs;

end

dTinv(abs(dTinv)>1e3) = 0;


end

no_heater = [no_heater{:}];
heater = [heater{:}];

%%
pathfile = fullfile(MainPath,'TimeSeries','Horti_MED','SPAIN','CLIMA', ...
                    '2020-04-26-SYSCLIMA','A001_UniformFormat', ...
                    'output','no_heater.mat');

save(pathfile,'no_heater')
%%
pathfile = fullfile(MainPath,'TimeSeries','Horti_MED','SPAIN','CLIMA', ...
                    '2020-04-26-SYSCLIMA','A001_UniformFormat', ...
                    'output','heater.mat');

save(pathfile,'heater')
