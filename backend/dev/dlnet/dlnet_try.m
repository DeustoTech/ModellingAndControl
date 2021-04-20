clear 

%% Train Network Using Custom Training Loop

theta = @(x) 0.5 + 0.5*tanh(10*x);
%
f = @(x,y) 1-theta(x.^2 + y.^2 - sqrt(3));

Ndata = 500;
xData = 4*(rand(Ndata,1)-0.5);
yData = 4*(rand(Ndata,1)-0.5);
InData  = [xData';yData'];
InData = dlarray(reshape(InData,2,1,1,Ndata),'SSCB');
%%
OutData = f(xData,yData)';
OutData = dlarray(reshape(OutData,1,Ndata),'CB');

%% Define Params 
nIn = 2;
nOut = 1;
nHid = 3;
X = dlarray(randn(nIn,1,1,100),'SSCB');
%
pr{1}.weights = dlarray(zrand(nHid,nIn,1,1)); 
pr{1}.bias    = dlarray(zrand(nHid,1));
%
pr{2}.weights = dlarray(zrand(nOut,nHid,1,1)); 
pr{2}.bias    = dlarray(zrand(nOut,1));
%
%%

[y,grad] = modelGradient(InData,OutData,pr);

%%
% Compute fullyconnect
Z = fullyconnect(X,weights,bias);
% Output: Z = 10(C) x 1(B) dlarray double

%% Define Model


%% Define Model Gradients Function
%% Specify Training Options

numEpochs = 50;
miniBatchSize = 500;
%% 
% Specify the options for SGDM optimization. Specify an initial learn rate of 
% 0.01 with a decay of 0.01, and momentum 0.9.

initialLearnRate = 0.01;
decay = 0.01;
momentum = 0.99;
%% Train Model

%% 
% Initialize the training progress plot.

figure
lineLossTrain = animatedline('Color',[0.85 0.325 0.098]);
%ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on
%% 
% Initialize the velocity parameter for the SGDM solver.

velocity = [];
start = tic;

indexs = 1:Ndata;
% Loop over epochs.
clf
hold on

avg_g = [];
avg_sqg = [];

    for it = 1:500
        ind = randsample(indexs,miniBatchSize);
        % Read mini-batch of data.
        dlX = InData (:,:,:,ind);
        dlY = OutData(:,ind);
        %
        % Evaluate the model gradients, state, and loss using dlfeval and the
        % modelGradients function and update the network state.
        [gradients,state,loss] = dlfeval(@modelGradients,dlnet,dlX,dlY);
        dlnet.State = state;
        
        % Determine learning rate for time-based decay learning rate schedule.
        learnRate = initialLearnRate/(1 + decay*it);
        
        % Update the network parameters using the SGDM optimizer.
        %
        [p,avg_g,avg_sqg] = adamupdate(dlnet,gradients,avg_g,avg_sqg,it,learnRate,0.9,0.95);
        % 
        pause(0.001)
        if it == 1 
            ip = plot(it,loss);
        else
            if mod(it,2) == 1
                ip.XData = [ ip.XData  it];
                ip.YData = [ ip.YData  loss];
            end
        end

    end


%%
tspan = linspace(-2,2,100);
[xms,yms] = meshgrid(tspan,tspan);
%
zms = f(xms,yms);

XTest = [xms(:) yms(:)]';
%
%
YTest = forward(dlnet,dlarray(reshape(XTest,2,1,1,100^2),'SSCB'));
YTest = reshape(YTest,100,100);
%
clf
subplot(2,1,1)
hold on
surf(xms,yms,extractdata(YTest))
plot3(xData,yData,extractdata(OutData),'*')
view(45,45)
title('pred')

subplot(2,1,2)
hold on
view(45,45)
surf(xms,yms,reshape(zms(:)',100,100))
plot3(xData,yData,extractdata(OutData ),'*')

title('real')

