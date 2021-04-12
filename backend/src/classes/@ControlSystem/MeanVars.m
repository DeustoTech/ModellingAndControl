function r = MeanVars(ics)
    r.in = mean(ics.Inputs{:,:},1);
    r.out = mean(ics.Outputs{:,:},1);
    r.dist = mean(ics.Disturbances{:,:},1);
end

