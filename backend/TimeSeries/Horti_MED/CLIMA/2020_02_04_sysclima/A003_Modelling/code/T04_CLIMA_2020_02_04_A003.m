%% NARX

clear
%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_04_sysclima/A001_UniformFormat/output/traj_1.3.2_without_heater.mat')
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_04_sysclima/A001_UniformFormat/output/traj_1.3.2_with_heater.mat')
%
rng(0)
%%
ds_train = getexp(idd1,1);
ds_test  = getexp(idd1,2);
%
%%
%
ni = 1;
no = 2;
shift = max(ni,no)+1;
%nn = [6*ni+no 5];
%nn = [15 10 5];
nn = [15 15];
net = narxnet(1:ni,1:no,nn);
%
[Us,Ui,Ai,Ys] = preparets2(net,ds_train);
%
net = train(net,Us,Ys,Ui,Ai);
view(net)
%% In test dataset
DataTime = dataset_test.DateTime(shift:end);

net = openloop(net);
[Us,Ui,Ai,Ys] = preparets2(net,ds_test);

Y = net(Us,Ui,Ai);
%
figure(1)
clf
plot(DataTime,[Y{:}]')
hold on

yt = dataset_test.Tinv';

figure(1)
clf
subplot(2,1,1)

Ypred = [Y{:}]';
plot(DataTime,Ypred)
title('open loop - test data | prediction')
legend(idd1.OutputName)


RMSE = sqrt(mean((yt(1,shift:end) - Ypred(:,1)').^2));

subplot(2,1,2)
[tspan,yt,ut] = getdata(ds_test);
plot(DataTime,yt(:,shift:end))
legend(idd1.OutputName)
title("real | x_T^{RMSE} = "+RMSE)

%
%%
net = closeloop(net);
%
[Us,Ui,Ai,Ys] = preparets2(net,ds_test);
%
Y = net(Us,Ui,Ai);
%
Ypred = [Y{:}]';

figure(2)
clf
subplot(2,1,1)
plot(DataTime,Ypred)
title('close loop - test data | prediction')
legend(idd1.OutputName)
grid on
[tspan,yt,ut] = getdata(ds_test);
RMSE = sqrt(mean((yt(1,shift:end) - Ypred(:,1)').^2));

subplot(2,1,2)
plot(DataTime,yt(:,shift:end))
legend(idd1.OutputName)
grid on

title("real | x_T^{RMSE} = "+RMSE)
%%
figure(3)
clf
subplot(4,1,1)
hold on
plot(DataTime,yt(1,shift:end),'r.-')
plot(DataTime,Ypred(:,1)','b.-')
legend('real','pred')
grid on
ylim([5 30])
ylabel('Temperature')
%
subplot(4,1,2)
hold on
plot(DataTime,yt(1,shift:end),'r.-')
plot(DataTime,Ypred(:,1)','b.-')
legend('real','pred')
grid on
xlim([DataTime(1) DataTime(50)])
%
ylim([5 30])
ylabel('Temperature')


subplot(4,1,3)
hold on
plot(DataTime,yt(1,shift:end),'r.-')
plot(DataTime,Ypred(:,1)','b.-')
legend('real','pred')
grid on
ylim([5 30])
ylabel('Temperature')

xlim([DataTime(1) DataTime(100)])
%
subplot(4,1,4)
hold on
plot(DataTime,yt(1,shift:end),'r.-')
plot(DataTime,Ypred(:,1)','b.-')
legend('real','pred')
grid on
ylim([5 30])
ylabel('Temperature')
xlim([DataTime(1) DataTime(150)])

%%
warning('off')
%%  
ControlVars = idd1.InputName;
StateVars   = idd1.OutputName;


nsteps = 1:5:40;
error_steps = zeros(1,length(nsteps));
for jj = 1:length(nsteps)
    %
    NN = 3*nsteps(jj);

    %
    error = zeros(1,NN);
    for ii = 1:NN
        %
       small_ds  = dataset_test(ii:(ii+nsteps(jj)+no-1),:);
       small_idd = Build_Iddata(small_ds,ControlVars,StateVars);
       %
       [Us,Ui,Ai,Ys] = preparets2(net,small_idd);
        %
        Y = net(Us,Ui,Ai);
        %
        Ypred = [Y{:}];

        xT_Real = Ys{end}(1);
        xT_Pred = Ypred(1,end);
        error(ii) = (xT_Real-xT_Pred).^2;
    end
    error_steps(jj) = sqrt(mean(error));
end
%%
figure(4)

plot(nsteps,error_steps,'.-','LineWidth',2,'MarkerSize',18)
xlabel('number of steps')
ylabel('MRSE')
grid on
title('\Delta t = 120 s')
%%