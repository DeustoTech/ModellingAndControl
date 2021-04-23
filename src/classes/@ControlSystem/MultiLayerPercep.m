function MultiLayerPercep(ics)
%NN

Nin  = ics.Nin + ics.Ndis;
Nout = ics.Nout;
%
NNeurons = 2*Nin;
NLayers = 3;

[F_sym,in_sym,out_sym,p] = MultiLayer(Nin,NNeurons,NLayers,Nout);
%%
pred  = F_sym(in_sym,p.all);
loss  = (pred - out_sym)'*(pred - out_sym);
%
FLoss = casadi.Function('loss',{in_sym,out_sym,p.all},{loss});
%
[Inputs,Outputs,Dist] = NormalizeData(ics);
%
Inputs = [Inputs Dist];

opt_params =  momentumGD(FLoss,Inputs,Outputs,in_sym,out_sym,p.all);
%

mu_in  = [ics.Normalization.mean.in ics.Normalization.mean.dist];
std_in = [ics.Normalization.std.in ics.Normalization.std.dist];
%
mu_out  = ics.Normalization.mean.out;
std_out = ics.Normalization.std.out;
%

end

