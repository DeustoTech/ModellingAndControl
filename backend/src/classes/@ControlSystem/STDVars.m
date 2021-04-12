function r = STDVars(ics)
    r.in = std(ics.Inputs{:,:},1);
    r.out = std(ics.Outputs{:,:},1);
    r.dist = std(ics.Disturbances{:,:},1);
end

