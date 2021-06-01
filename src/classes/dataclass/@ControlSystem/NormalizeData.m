function  [mu_vars,std_vars] = NormalizeData(ics)

mu_vars  = MeanVars(ics);
std_vars = STDVars(ics);

if ismember(0,[std_vars.in std_vars.out std_vars.dist])
   error('Some variable is constant') 
end
end

