clear

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_05_cesar/A000_RelatedFiles/ttFeb2019.mat')

dataset01 = timetable2table(ttFeb2019);
name_vars = dataset01.Properties.VariableNames;

dataset01.Properties.VariableNames{1} = 'DataTime';
dataset01 = dataset01(:,{'DataTime','Text','RadExt','Vviento','HRInt','RadInt','Tinv','EstadoCenitalE'});

tt = [];
tt.Time = dataset01.DataTime - dataset01.DataTime(1);
tt = struct2table(tt);

%%
%sub_data = normalize(dataset01(:,2:end));
sub_data = dataset01(:,2:end);

dataset01_pre = dataset01;
dataset01_pre(:,2:end) = sub_data;
%
MN = mean(dataset01{:,2:end});
ST = std(dataset01{:,2:end});
%%
dataset02 = [tt dataset01_pre];
%%
len_train = 4320;
len_test  = 2160;
nn = 11400;
ds_train = dataset02((1:len_train)+nn,:);

ds_test = dataset02((nn+len_train+1):(nn+len_train+len_test),:);
%
clf
subplot(2,1,1)
plot(ds_train.DataTime,ds_train.Tinv)

subplot(2,1,2)
plot(ds_test.DataTime,ds_test.Tinv)

%%
dataset03 = {ds_train,ds_test};

ControlVars = {'RadExt','Vviento','RadInt','HRInt','EstadoCenitalE','Text'};
StateVars = {'Tinv'};
idd1 = Build_Iddata(dataset03,ControlVars,StateVars);

ds = dataset03;
save('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/Horti_MED/CLIMA/2020_02_05_cesar/A001_UniformFormat/output/idd1.mat','idd1','ds','MN','ST')

%%
fig = figure('unit','norm','pos',[0 0 0.4 0.5]);
clf
hold on
fmt = {'Interpreter','tex','FontSize',15};
is = scatter(ds_train.EstadoCenitalE,ds_train.Text,[],ds_train.Tinv,'.');
is.SizeData = 200;
ic = colorbar;
colormap('jet')
title('Dataset Input Distribution',fmt{:})
ylabel('Text[ºC]',fmt{:})
xlabel('Cenital[%]',fmt{:})
ic.Label.String = 'Tinv[ºC]';
%ic.Label.Interpreter = 'latex';
ic.Label.FontSize = 15;
%
P = [ds_train.EstadoCenitalE,ds_train.Text];
[k,av] = convhull(P);
ip = plot(P(k,1),P(k,2),'LineWidth',2,'Color','k','LineStyle','--');
grid on 
%
is.Parent.XAxis.FontSize= 15;
is.Parent.YAxis.FontSize= 15;
is.Parent.XAxis.TickLabelInterpreter= 'tex';
is.Parent.YAxis.TickLabelInterpreter= 'tex';
legend([is ip],{'Dataset points','Convex Hull'},'Location','south','Interpreter','latex','FontSize',15)
print(fig,'convex-hull.eps','-depsc')