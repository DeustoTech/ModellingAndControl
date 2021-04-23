clear 
load("" + MainPath + 'TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset02.mat')

[~,~,~,nexp] = size(idd1);
%
ind_exp = randsample(nexp,50,0)';
idd_train = getexp(idd1,ind_exp);
%
ind_exp = randsample(nexp,20,0)';
idd_test = getexp(idd1,ind_exp);
%%
