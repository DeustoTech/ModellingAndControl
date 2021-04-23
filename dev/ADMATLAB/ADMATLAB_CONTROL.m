%
clear
%% Parametros 
NInput = 2;
Nlayer = 2;
Nneurons = 10;
NOutput = 2;

w{1} = dlarray(single(zrand(Nneurons,NInput)));
b{1} = dlarray(single(zrand(Nneurons,1)));

i = 1;
for ilayer = 2:Nlayer+1
    i = i + 1;
    w{i} = dlarray(single(zrand(Nneurons,Nneurons)));
    b{i} = dlarray(single(zrand(Nneurons,1)));
end
i = i + 1;
w{i} = dlarray(single(zrand(NOutput,Nneurons)));
b{i} = dlarray(single(zrand(NOutput,1)));

params = {w,b};
%%
ndata = 10000;

xline = 2*(rand(2,1,1,ndata) - 0.5);
%
fline1 = 0.25*sum([2 2]'.*sin(xline.^2),1);
fline2 = 0.25*sum([3 5]'.*xline.^3,1);
%
xline = dlarray(single(xline),'SSCB');

fline = cat(1,fline1,fline2);
fline = reshape(fline,2,ndata);
fline = dlarray(single(fline),'CB');
%%
LR0 = 0.001;
%
vel = [];
%
clf 
hold on
for iter = 1:100000
    
    %
   ind = randsample(ndata,500,true);
    
   [val,grad] = dlfeval(@modelGradients,xline(:,:,:,ind),fline(:,ind),params);
   
   LearningRate = LR0/iter^(1/3);
   [params,vel] = sgdmupdate(params,grad,vel,LearningRate,0.9);
   
   %
   if mod(iter,50) == 0
      figure(1)

       plot(iter,(extractdata(val)),'.')
       pause(0.001)
   end
   if mod(iter,500) == 0
       figure(2)
        clf
        subplot(2,2,1)
        plot3(extractdata(xline(1,:)),extractdata(xline(2,:)),extractdata(fline(1,:))','.')
        zlim([0 1])

        title('f_1(x,y) | real')
        subplot(2,2,2)
        plot3(extractdata(xline(1,:)),extractdata(xline(2,:)),extractdata(fline(2,:))','.')
        title('f_2(x,y) | real')
        zlim([-5 5])

        %%

        fr = model(xline,params);
        subplot(2,2,3)
        title('f_2(x,y) | predict')
        plot3(extractdata(xline(1,:)),extractdata(xline(2,:)),extractdata(fr(1,:))','.')
        zlim([0 1])
        %
        subplot(2,2,4)
        title('f_2(x,y) | predict')
        plot3(extractdata(xline(1,:)),extractdata(xline(2,:)),extractdata(fr(2,:))','.')
        zlim([-5 5])

   end
end
%% plots
