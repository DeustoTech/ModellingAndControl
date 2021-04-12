function plot(ics,ind)

ds = vertcat(ics.TableSeries(ind).DataSet);
date = horzcat(ics.TableSeries(ind).DateTime);
%
subplot(3,1,1)
hold on
for ivar = ics.InputVars
    plot(date,ds.(ivar{:}))
end
legend(ics.InputVars)
title('Inputs')
%
subplot(3,1,2)
hold on
for ivar = ics.DisturbanceVars
    plot(date,ds.(ivar{:}))
end
legend(ics.DisturbanceVars)
title('Disturbances')
%
subplot(3,1,3)
hold on
for ivar = ics.OutputVars
    plot(date,ds.(ivar{:}))
end
legend(ics.OutputVars)
title('Outputs')
