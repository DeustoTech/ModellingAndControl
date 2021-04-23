function DistributionDT(ds)

Time = ds.Properties.DimensionNames{1};
clf
subplot(3,1,1)
plot(minutes(diff(ds.(Time))))
ylabel('\Delta t')
subplot(3,1,2)
histogram(minutes(diff(ds.(Time))),200,'Normalization','probability')
xlabel('mins')
subplot(3,1,3)
histogram(minutes(diff(ds.(Time))),2000,'Normalization','probability')
xlabel('mins')
xlim([0 10])


end

