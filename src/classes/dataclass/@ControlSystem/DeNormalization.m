function  ics = DeNormalization(ics)


nTs = length(ics.TableSeries);
mu_vars  = ics.Normalization.mean;
std_vars = ics.Normalization.std;

for iTs = 1:nTs
    %
    %
    i = 0;
    for ivar = ics.InputVars
        i = i + 1;
        ics.TableSeries(iTs).DataSet.(ivar{:}) = (ics.TableSeries(iTs).DataSet.(ivar{:}))* std_vars.in(i) +  mu_vars.in(i);
    end
    %
    i = 0;
    for ivar = ics.OutputVars
        i = i + 1;
        ics.TableSeries(iTs).DataSet.(ivar{:}) = (ics.TableSeries(iTs).DataSet.(ivar{:}))* std_vars.out(i) +  mu_vars.out(i);
    end
    %
    i = 0;
    for ivar = ics.DisturbanceVars
        i = i + 1;
        ics.TableSeries(iTs).DataSet.(ivar{:}) = (ics.TableSeries(iTs).DataSet.(ivar{:}))*std_vars.dist(i)  + mu_vars.dist(i);
    end
end

ics.Normalization = NormalizationCS.empty;
end

