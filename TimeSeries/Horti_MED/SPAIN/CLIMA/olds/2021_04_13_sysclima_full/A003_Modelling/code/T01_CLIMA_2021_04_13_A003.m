%% Train Network Using Custom Training Loop
% This example shows how to train a network that classifies handwritten digits 
% with a custom learning rate schedule.
% 
% If |trainingOptions| does not provide the options you need (for example, a 
% custom learning rate schedule), then you can define your own custom training 
% loop using automatic differentiation.
% 
% This example trains a network to classify handwritten digits with the _time-based 
% decay_ learning rate schedule: for each iteration, the solver uses the learning 
% rate given by $\rho_t =\frac{\rho_0 }{1+k\;t}$, where _t_ is the iteration number, 
% $\rho_0$ is the initial learning rate, and _k_ is the decay.
%% Load Training Data
% Load the digits data as an image datastore using the |imageDatastore| function 
% and specify the folder containing the image data.

dataFolder = fullfile(toolboxdir('nnet'),'nndemos','nndatasets','DigitDataset');
imds = imageDatastore(dataFolder, ...
    'IncludeSubfolders',true, ....
    'LabelSource','foldernames');
%% 
% Partition the data into training and validation sets. Set aside 10% of the 
% data for validation using the |splitEachLabel| function.

[imdsTrain,imdsValidation] = splitEachLabel(imds,0.9,'randomize');
%% 
% The network used in this example requires input images of size 28-by-28-by-1. 
% To automatically resize the training images, use an augmented image datastore. 
% Specify additional augmentation operations to perform on the training images: 
% randomly translate the images up to 5 pixels in the horizontal and vertical 
% axes. Data augmentation helps prevent the network from overfitting and memorizing 
% the exact details of the training images.

inputSize = [28 28 1];
pixelRange = [-5 5];
imageAugmenter = imageDataAugmenter( ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain,'DataAugmentation',imageAugmenter);
%% 
% To automatically resize the validation images without performing further data 
% augmentation, use an augmented image datastore without specifying any additional 
% preprocessing operations.

augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
%% 
% Determine the number of classes in the training data.

classes = categories(imdsTrain.Labels);
numClasses = numel(classes);
%% Define Network
% Define the network for image classification.

layers = [
    imageInputLayer(inputSize,'Normalization','none','Name','input')
    convolution2dLayer(5,20,'Name','conv1')
    batchNormalizationLayer('Name','bn1')
    reluLayer('Name','relu1')
    convolution2dLayer(3,20,'Padding','same','Name','conv2')
    batchNormalizationLayer('Name','bn2')
    reluLayer('Name','relu2')
    convolution2dLayer(3,20,'Padding','same','Name','conv3')
    batchNormalizationLayer('Name','bn3')
    reluLayer('Name','relu3')
    fullyConnectedLayer(numClasses,'Name','fc')
    softmaxLayer('Name','softmax')];
lgraph = layerGraph(layers);
%% 
% Create a |dlnetwork| object from the layer graph.

dlnet = dlnetwork(lgraph)
%% Define Model Gradients Function
% Create the function |modelGradients|, listed at the end of the example, that 
% takes a |dlnetwork| object, a mini-batch of input data with corresponding labels 
% and returns the gradients of the loss with respect to the learnable parameters 
% in the network and the corresponding loss.
%% Specify Training Options
% Train for ten epochs with a mini-batch size of 128.

numEpochs = 10;
miniBatchSize = 512;
%% 
% Specify the options for SGDM optimization. Specify an initial learn rate of 
% 0.01 with a decay of 0.01, and momentum 0.9.

initialLearnRate = 0.01;
decay = 0.01;
momentum = 0.9;
%% Train Model

mbq = minibatchqueue(augimdsTrain,...
    'MiniBatchSize',miniBatchSize,...
    'MiniBatchFcn',@preprocessMiniBatch,...
    'MiniBatchFormat',{'SSCB',''});
%% 
% Initialize the training progress plot.

figure
lineLossTrain = animatedline('Color',[0.85 0.325 0.098]);
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on
%% 
% Initialize the velocity parameter for the SGDM solver.

velocity = [];
%% 
% Train the network using a custom training loop. For each epoch, shuffle the 
% data and loop over mini-batches of data. For each mini-batch:
%% 
% * Evaluate the model gradients, state, and loss using the |dlfeval| and |modelGradients| 
% functions and update the network state.
% * Determine the learning rate for the time-based decay learning rate schedule.
% * Update the network parameters using the |sgdmupdate| function.
% * Display the training progress. 

iteration = 0;
start = tic;

% Loop over epochs.
for epoch = 1:numEpochs
    % Shuffle data.
    shuffle(mbq);
    
    % Loop over mini-batches.
    while hasdata(mbq)
        iteration = iteration + 1;
        
        % Read mini-batch of data.
        [dlX, dlY] = next(mbq);
        
        % Evaluate the model gradients, state, and loss using dlfeval and the
        % modelGradients function and update the network state.
        [gradients,state,loss] = dlfeval(@modelGradients,dlnet,dlX,dlY);
        dlnet.State = state;
        
        % Determine learning rate for time-based decay learning rate schedule.
        learnRate = initialLearnRate/(1 + decay*iteration);
        
        % Update the network parameters using the SGDM optimizer.
        [dlnet,velocity] = sgdmupdate(dlnet,gradients,velocity,learnRate,momentum);
        
        % Display the training progress.
        D = duration(0,0,toc(start),'Format','hh:mm:ss');
        addpoints(lineLossTrain,iteration,loss)
        title("Epoch: " + epoch + ", Elapsed: " + string(D))
        drawnow
    end
end
%% Test Model
% Test the classification accuracy of the model by comparing the predictions 
% on the validation set with the true labels.
% 
% After training, making predictions on new data does not require the labels. 
% Create |minibatchqueue| object containing only the predictors of the test data:
%% 
% * To ignore the labels for testing, set the number of outputs of the mini-batch 
% queue to 1.
% * Specify the same mini-batch size used for training.
% * Preprocess the predictors using the |preprocessMiniBatchPredictors| function, 
% listed at the end of the example.
% * For the single output of the datastore, specify the mini-batch format |'SSCB'| 
% (spatial, spatial, channel, batch).

numOutputs = 1;
mbqTest = minibatchqueue(augimdsValidation,numOutputs, ...
    'MiniBatchSize',miniBatchSize, ...
    'MiniBatchFcn',@preprocessMiniBatchPredictors, ...
    'MiniBatchFormat','SSCB');
%% 
% Loop over the mini-batches and classify the images using |modelPredictions| 
% function, listed at the end of the example.

predictions = modelPredictions(dlnet,mbqTest,classes);
%% 
% Evaluate the classification accuracy.

YTest = imdsValidation.Labels;
accuracy = mean(predictions == YTest)
%% Model Gradients Function
% The |modelGradients| function takes a |dlnetwork| object |dlnet|, a mini-batch 
% of input data |dlX| with corresponding labels |Y| and returns the gradients 
% of the loss with respect to the learnable parameters in |dlnet|, the network 
% state, and the loss. To compute the gradients automatically, use the |dlgradient| 
% function.

function [gradients,state,loss] = modelGradients(dlnet,dlX,Y)

[dlYPred,state] = forward(dlnet,dlX);

loss = crossentropy(dlYPred,Y);
gradients = dlgradient(loss,dlnet.Learnables);

loss = double(gather(extractdata(loss)));

end
%% Model Predictions Function
% The |modelPredictions| function takes a |dlnetwork| object |dlnet|, a |minibatchqueue| 
% of input data |mbq|, and the network classes, and computes the model predictions 
% by iterating over all data in the |minibatchqueue| object. The function uses 
% the |onehotdecode| function to find the predicted class with the highest score.

function predictions = modelPredictions(dlnet,mbq,classes)

predictions = [];

while hasdata(mbq)
    
    dlXTest = next(mbq);
    dlYPred = predict(dlnet,dlXTest);
    
    YPred = onehotdecode(dlYPred,classes,1)';
    
    predictions = [predictions; YPred];
end

end
%% Mini Batch Preprocessing Function
% The |preprocessMiniBatch| function preprocesses a mini-batch of predictors 
% and labels using the following steps:
%% 
% # Preprocess the images using the |preprocessMiniBatchPredictors| function.
% # Extract the label data from the incoming cell array and concatenate into 
% a categorical array along the second dimension.
% # One-hot encode the categorical labels into numeric arrays. Encoding into 
% the first dimension produces an encoded array that matches the shape of the 
% network output.

function [X,Y] = preprocessMiniBatch(XCell,YCell)

% Preprocess predictors.
X = preprocessMiniBatchPredictors(XCell);

% Extract label data from cell and concatenate.
Y = cat(2,YCell{1:end});

% One-hot encode labels.
Y = onehotencode(Y,1);

end
%% Mini-Batch Predictors Preprocessing Function
% The |preprocessMiniBatchPredictors| function preprocesses a mini-batch of 
% predictors by extracting the image data from the input cell array and concatenate 
% into a numeric array. For grayscale input, concatenating over the fourth dimension 
% adds a third dimension to each image, to use as a singleton channel dimension.

function X = preprocessMiniBatchPredictors(XCell)

% Concatenate.
X = cat(4,XCell{1:end});

end
%% 
% _Copyright 2019 The MathWorks, Inc._