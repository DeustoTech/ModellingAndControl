clear 
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_05_cesar/A001_UniformFormat/output/idd1.mat')
%
%
idd_train = getexp(idd1,1);
%
% Creamos los datos con el input [u_t,x_t,x_{t-1}]
no = 0;
[inputs_narx,output_narx] = NARXDataFormat(idd_train,no);

%% Entrenamiento
neurons = [10 10];
net = feedforwardnet(neurons);
net = train(net,inputs_narx,output_narx);

%%
clf
plot(output_narx(2:end))
hold on 
plot(inputs_narx(end,2:end))

%%
ind = 2;
idd_test = getexp(idd1,ind);
[inputs_narx_test,output_narx_test] = NARXDataFormat(idd_test,no);

%
if no > 0 
    [~,Nt] = size(inputs_narx_test);

    out  = idd_test.OutputData(1   , : );

    out_pred = zeros(1,Nt);
    iter = 0;
    for it = (no+1):(Nt+no)
        iter = iter + 1;
        in  = idd_test.InputData(it,:);
        out= net([in out]');
        out_pred(iter) = out;
    end
%
    out_narx_test_pred = out_pred;
else
    out_narx_test_pred = net(inputs_narx_test);
end
%
fig = figure('unit','norm','pos',[0 0 0.9 0.8]);
ui1 = uipanel('Parent',fig,'unit','norm','pos',[0 0 0.5 1],'Title','Real','Backgroundcolor','w');
pplot(output_narx_test,inputs_narx_test,idd1,ui1,ds{ind},no);

ui2 = uipanel('Parent',fig,'unit','norm','pos',[0.5 0 0.5 1],'Title','Prediction','Backgroundcolor','w');
pplot(out_narx_test_pred,inputs_narx_test,idd1,ui2,ds{ind},no);

path = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/docs/2021-02-01-SOFC-DataDriven-Model/img/";
%%
figure(5)
clf
subplot(2,1,1)
plot(output_narx_test)
hold on
plot(out_narx_test_pred)
legend({'Real','Pred'})
%
subplot(2,1,2)

ecdf(sqrt((output_narx_test - out_narx_test_pred).^2))
%
% RMSE
RMSE = sqrt( mean((output_narx_test - out_narx_test_pred).^2) );
title("RMSE = "+RMSE)
%print(fig,'-depsc',fullfile(path,'results.eps'))

%%
Real = [];
Prediction = [];
iter = 0;
for ivar = idd1.InputName'
  iter = iter + 1;
  Real.(ivar{:}) = idd_test.InputData(2:end,iter);
end
Real.DateTime = ds{2}.DataTime(2:end);
Real.Tinv = idd_test.OutputData(2:end);
%
Prediction.Tinv = out_narx_test_pred';

Real = struct2table(Real);
Prediction = struct2table(Prediction);
%%
save('NARX.mat','Real','Prediction')
%%
%file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A003_Modelling/output/MODEL01_SOFC.mat';
%genFunction(net,file)


function pplot(odata,idata,idd1,Parent,ds,no)

    fmt = {'FontSize',15};

    ni = length(idd1.InputName);
    nout = length(idd1.OutputName);

    [~,ndata] = size(idata);
    tspan = ds.DataTime(1:end-no);
    
    for ii = 1:ni
        ax{ii}= subplot(2,ni,ii,'Parent',Parent);
        plot(tspan,idata(ii,:)','.-','Parent',ax{ii})
        title(idd1.InputName{ii},fmt{:})
        %legend(idd1.InputName(1),'Interpreter','latex')
        %xlabel('t(minutes)')
        grid on 
    end
    %
    
    %
    for ii = 1:nout
        ax{ii}= subplot(2,nout,nout+ii,'Parent',Parent);
        plot(tspan,odata(ii,:)','.-','Parent',ax{ii})
        title(idd1.OutputName{ii},fmt{:})
        %legend(idd1.InputName(1),'Interpreter','latex')
        xlabel('t(minutes)')
        grid on 
    end
    



end