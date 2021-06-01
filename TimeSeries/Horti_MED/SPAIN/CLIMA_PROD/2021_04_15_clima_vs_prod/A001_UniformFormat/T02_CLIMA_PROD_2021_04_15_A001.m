clear 

load("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/olds/2021_04_21_euskalmet/A000_RelatedFiles/takeclimadata/fulldata.mat')

%%
ds.DateTime = newds.DateTime;
ds.Text     = newds.Tem_dot_Aire_dot__a_150cm;
ds = struct2table(ds);
%%
iTs = TableSeries(ds);
%%
clf
ShowData(iTs);
%%
iTs = RemoveVars(iTs);
iTs = RemoveRowsNan(iTs);
iTs = RemoveRowMaxGrad(iTs,'Text',0.05);
iTs = UniformTimeStamp(iTs,'DT',minutes(15));

hold on 
ShowData(iTs);


%%
%%
load("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/PROD/2020_01_13_PROD/A001_UniformFormat/output/dataset03.mat')
nseasons= length(dataset03);
for i = 1:nseasons
produ_ts(i) = TableSeries((dataset03{i}));
end
%%
clf
color = cool(nseasons);
color = 0.99*color + 0.01; 
parameters_HORTSYS;
GT = @(z) -0.5*tanh(eta_max*(z-Tmax_n)) - 0.5*tanh(eta_min*(Tmin_n-z));

    
for i = 1:nseasons
    initdate = produ_ts(i).DateTime(1) - days(150);
    enddate  = produ_ts(i).DateTime(end);

    ind = (iTs.DateTime > initdate).*(iTs.DateTime < enddate);
    ind = logical(ind);

    subTs = subselect(iTs,ind);
    tspan = days(subTs.tspan);
    Text  = subTs.DataSet.Text;

    Tmax = 35;
    Tmin = 10;
    etamax = 1;
    etamin = 1;


    muText = movmean(GT(Text),15);

    subplot(4,1,1)
    hold on

    plot(subTs.DateTime,subTs.DataSet.Text,'color',color(i,:))
    yline(Tmax);
    yline(Tmin)
%     yyaxis right
%     plot(subTs.DateTime,muText)
    subplot(4,1,2)
    hold on

    maxdays = days(subTs.tspan(end));

    plot(subTs.DateTime,cumsum(muText)/maxdays,'color',color(i,:),'LineWidth',2.5)

    plot(subTs.DateTime,cumsum(1 + 0*muText)/maxdays,'color',color(i,:),'LineStyle','--','LineWidth',2.5)
    subplot(4,1,3)
    hold on

    plot( produ_ts(i).DateTime, produ_ts(i).DataSet.Netokg,'color',color(i,:),'LineWidth',2.5)
    subplot(4,1,4)
    hold on
    plot( produ_ts(i).DateTime, cumsum(produ_ts(i).DataSet.Netokg),'color',color(i,:),'LineWidth',2.5)

end