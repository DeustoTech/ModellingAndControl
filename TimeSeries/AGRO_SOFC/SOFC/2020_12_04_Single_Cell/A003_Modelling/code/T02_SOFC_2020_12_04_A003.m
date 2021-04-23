clear 
load("" + MainPath + 'TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset02.mat')

[~,~,~,nexp] = size(idd1);
%
ind_exp = randsample(nexp,20,0)';
idd_train = getexp(idd1,ind_exp);
%
ind_exp = randsample(nexp,20,0)';
idd_test = getexp(idd1,ind_exp);

%%
no = length(idd_train.OutputName);
ni = length(idd_train.InputName);


na = 4*eye(no); % note: na must be ny-by-ny!
nb = 4*ones(no,ni); % nb must be ny-by-nu 
%nc = 1*ones(no,1); % nc must be ny-by-1
nk = ones(no,ni); % nk must be ny-by-nu

sys = arx(idd_train,[na nb nk]);
%%
compare(idd_train,sys,5)
