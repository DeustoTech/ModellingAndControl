%
clear
%% Parametros 
NInput = 2;
Nlayer = 2;
Nneurons = 3;
NOutput = 2;

w{1} = dlarray(single(rand(Nneurons,NInput)));
b{1} = dlarray(single(rand(Nneurons,1)));

i = 1;
for ilayer = 2:Nlayer+1
    i = i + 1;
    w{i} = dlarray(single(rand(Nneurons,Nneurons)));
    b{i} = dlarray(single(rand(Nneurons,1)));
end
i = i + 1;
w{i} = dlarray(single(rand(NOutput,Nneurons)));
b{i} = dlarray(single(rand(NOutput,1)));

params = {w,b};
%%
ndata = 1000;

xline = 2*(rand(2,1,1,ndata) - 0.5);
%
fline1 = sum([4 2]'.*sin(xline.^2),1);
fline2 = sum([4 7]'.*xline.^3,1);
%
xline = dlarray(single(xline),'SSCB');

fline = cat(1,fline1,fline2);
fline = reshape(fline,2,ndata);
fline = dlarray(single(fline),'CB');
%%
LR0 = 0.1;
%
vel = [];
%
clf 
hold on
for iter = 1:5000
    
    %
   ind = randsample(ndata,200,true);
    
   [val,grad] = dlfeval(@modelGradients,xline(:,:,:,ind),fline(:,ind),params);
   
   LearningRate = LR0/iter^(1/3);
   [params,vel] = sgdmupdate(params,grad,vel,LearningRate,0.9);
   
   %
   if mod(iter,10) == 0
       plot(iter,log(extractdata(val)),'.')
       pause(0.01)
   end
end
%% plots
figure(1)
clf
subplot(2,2,1)
plot3(extractdata(xline(1,:)),extractdata(xline(2,:)),extractdata(fline(1,:))','.')
title('f_1(x,y) | real')
subplot(2,2,2)
plot3(extractdata(xline(1,:)),extractdata(xline(2,:)),extractdata(fline(2,:))','.')
title('f_2(x,y) | real')

%%

fr = model(xline,params);
subplot(2,2,3)
title('f_2(x,y) | predict')

plot3(extractdata(xline(1,:)),extractdata(xline(2,:)),extractdata(fr(1,:))','.')
subplot(2,2,4)
title('f_2(x,y) | predict')
plot3(extractdata(xline(1,:)),extractdata(xline(2,:)),extractdata(fr(2,:))','.')
