clear all
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_01_13_sysclima/A001_UniformFormat/output/ics01.mat')
%% Normalize 
%
[ics_train,ics_test] = SplitTrain(ics,'percent',2);
%
%%
ics = ics_train;

normalize(ics.Inputs{:,:})

I = reshape(ics.Inputs{:,:}',ics.Nin,1,1,ics.Ndata);
I = dlarray(I,'SSCB');

O = dlarray(ics.Outputs{:,:},'BC');
%%


NInput = ics.Nin;
Nlayer = 3;
Nneurons = 4;
NOutput = ics.Nout;

w{1} = dlarray(single(rand(Nneurons,NInput) -0.5 ));
b{1} = dlarray(single(rand(Nneurons,1)) -0.5);

i = 1;
for ilayer = 2:Nlayer+1
    i = i + 1;
    w{i} = dlarray(single(rand(Nneurons,Nneurons) - 0.5 ));
    b{i} = dlarray(single(rand(Nneurons,1) - 0.5));
end
i = i + 1;
w{i} = dlarray(single(rand(NOutput,Nneurons)) -0.5);
b{i} = dlarray(single(rand(NOutput,1)) - 0.5);

params = {w,b};

%%

LR0 = 0.01;
%
vel = [];
%
clf 
hold on

exist_plot = false;
for iter = 1:5000
    %
    ind = randsample(ics.Ndata,100,true);
   [val,grad] = dlfeval(@modelGradients,I(:,:,:,ind),O(:,ind),params);
   
   LearningRate = LR0/iter^(1/3);
   [params,vel] = sgdmupdate(params,grad,vel,LearningRate,0.9);
   %
   if mod(iter,1) == 0
       if exist_plot
            ip.XData = [ip.XData iter];
            ip.YData = [ip.YData log(extractdata(val))];
       else
            ip = plot(iter,log(extractdata(val)),'.-');
            exist_plot = true;
       end
       pause(0.01)
   end
end