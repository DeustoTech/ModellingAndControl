clear 
ndata = 5000;
xspan = 2*(rand(1,ndata) - 0.5);
yspan = 2*(rand(1,ndata) - 0.5);
%
XData = [xspan;yspan]';
%
YData = 2*xspan.^2 +  2*yspan.^2;
YData = YData';

%%
N = 2;

layers = [   imageInputLayer([1 1 2])
             fullyConnectedLayer(10)
             softmaxLayer
             fullyConnectedLayer(1)
             regressionLayer ];
            
%%
miniBatchSize  = 512;
options = trainingOptions('adam', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',200, ...
    'InitialLearnRate',1e-1, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.5, ...
    'LearnRateDropPeriod',50, ...
    'Shuffle','every-epoch', ...
    'Plots','none', ...
    'Verbose',true);
%
net = trainNetwork(reshape(XData',1,1,2,ndata),YData,layers,options);

%%
tspan = linspace(-1,1,50);
[xms, yms] = meshgrid(tspan,tspan);

XTest = [xms(:),yms(:)];
%%
YTest = predict(net,reshape(XTest',1,1,2,50^2));

clf
surf(xms,yms,reshape(YTest,50,50))
hold on
plot3(XData(:,1),XData(:,2),YData,'.','MarkerSize',15)