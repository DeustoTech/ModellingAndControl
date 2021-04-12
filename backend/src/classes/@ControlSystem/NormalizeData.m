function  [Inputs,Outputs,Dist] = NormalizeData(ics)


Inputs = ics.Inputs{:,:};
Outputs = ics.Outputs{:,:};
Dist = ics.Disturbances{:,:};

%
if ~isempty(ics.Normalization)
   Inputs = (Inputs - ics.Normalization.mean.in)./ics.Normalization.std.in;
   Outputs = (Outputs - ics.Normalization.mean.out)./ics.Normalization.std.out;
   Dist = (Dist - ics.Normalization.mean.dist)./ics.Normalization.std.dist;
end

end

