function  ics = SetNormalization(ics,mu_vars,std_vars)

if ~isempty(ics.Normalization)
    ics = DeNormalization(ics);
end
nTs = length(ics.TableSeries);

for iTs = 1:nTs
    %
    %
    i = 0;
    for ivar = ics.InputVars
        i = i + 1;
        ics.TableSeries(iTs).DataSet.(ivar{:}) = (ics.TableSeries(iTs).DataSet.(ivar{:}) - mu_vars.in(i))/std_vars.in(i);
    end
    %
    i = 0;
    for ivar = ics.OutputVars
        i = i + 1;
        ics.TableSeries(iTs).DataSet.(ivar{:}) = (ics.TableSeries(iTs).DataSet.(ivar{:}) - mu_vars.out(i))/ std_vars.out(i);
    end
    %
    i = 0;
    for ivar = ics.DisturbanceVars
        i = i + 1;
        ics.TableSeries(iTs).DataSet.(ivar{:}) = (ics.TableSeries(iTs).DataSet.(ivar{:}) - mu_vars.dist(i))/ std_vars.dist(i);
    end
end

ics.Normalization = NormalizationCS(mu_vars,std_vars);

end

