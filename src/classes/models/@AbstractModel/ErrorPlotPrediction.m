function   ErrorPlotPrediction(iNARX,ics,varargin)

%% Input Setting
p = inputParser;

addRequired(p,'iNARX')
addRequired(p,'ics');
addOptional(p,'OutGroups',{});
addOptional(p,'DisGroups',{});
addOptional(p,'InGroups',{});
addOptional(p,'ylims',{});

addOptional(p,'Nt',[]);

parse(p,iNARX,ics,varargin{:})

r = p.Results;

OutGroups = r.OutGroups;
InGroups  = r.InGroups;
Nt        = r.Nt;
DisGroups  = r.DisGroups;
ylims  = r.ylims;

if isempty(Nt)
    Nt = 5;
end

nds = length(ics.TableSeries);

error = zeros(ics.Nout,Nt,nds);

no_cs = DeNormalization(ics);
i = 0;

nds = 50;
for ind = 1:nds
%%
        try
        r = SplitGenData(iNARX,ics,'ind',ind,'Nt',Nt);

        YTest = Prediction(iNARX,ics,r,Nt);
        YTest = full(YTest);

        %%

        newcs = Data2cs(ics,r.DateTime,r.Input,YTest,r.Disturbances,'denorm',1);
        %

            error(:,:,ind -i) = no_cs.Outputs{ind}(:,2:Nt+1) - newcs.Outputs{1}(:,1:Nt);
            %error(:,:,ind-i) = abs(error(:,:,ind-i)./no_cs.Outputs{ind}(:,2:Nt+1));
        catch 
            i = i + 1;
            continue
        end
end
error = sqrt(error.^2);
error= error(:,:,1:(nds-i));
%
error_mean = mean(error,3);

tspan = minutes(ics.tspan{1}(1:Nt));
for idim = 1:ics.Nout
    subplot(2,ics.Nout,2*idim)
    hold on
    arrayfun(@(i)plot(tspan,error(idim,:,i)','Color',[0.8 0.8 1.0],'LineWidth',2,'MarkerSize',10,'Marker','.'),1:nds-i);
    errorbar(tspan,error_mean(idim,:),std(error(idim,:,:),[],3)/2,'color','r','Marker','.','MarkerSize',15,'LineWidth',2)
    grid on
    legend(ics.OutputVars{idim},'FontSize',15,'Interpreter','none')
    xlabel('Minutes')
    if isempty(ylims)
        ylim([0 Inf])
    else
        ylim(ylims{idim})
    end
end

%%

ics = DeNormalization(ics);
Outputs = [ics.Outputs{:}]';

for idim = 1:ics.Nout
    subplot(2,ics.Nout,2*idim-1)
    histogram(Outputs(:,idim),'Normalization','probability')
    title(ics.OutputVars{idim},'Interpreter','none')
end
%%

end

