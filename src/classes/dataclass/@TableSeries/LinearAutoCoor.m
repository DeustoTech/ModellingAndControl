function [MatCoor,MatCoor_boolean,iplot,G] = LinearAutoCoor(Ts,varargin)

    i = 0;
    for iTs = Ts
        i = i + 1;
        ds{i} = iTs.DataSet{:,:}';
    end
    ds =  [ds{:}]';
    %% Managment input variables 
    p = inputParser;

    addRequired(p,'ds')
    addOptional(p,'alpha',0.99)
    addOptional(p,'names',Ts(1).vars)
    addOptional(p,'FontSize',15)
    addOptional(p,'Plots',true);
    %
    parse(p,Ts,varargin{:})
    %
    alpha = p.Results.alpha;
    names = p.Results.names;
    FontSize = p.Results.FontSize;
    Plots = p.Results.Plots;
    %%
    previos = ds(1:end-1,:);
    next    = ds(2:end,:);
    
    %
    new_matrix = [previos next];
    %%
    [MatCoor,~] = corrcoef(new_matrix);
    %~
    MatCoor_boolean = abs(MatCoor) > alpha;

    
    next_names = arrayfun(@(i)[i{:},'_next'],names,'UniformOutput',false);    
    G = digraph(MatCoor_boolean,{names{:} next_names{:}});

    if Plots
        subplot(1,2,1)
        iplot = plot(G);
        iplot.NodeFontSize = FontSize;
        iplot.MarkerSize = 9;
        iplot.EdgeColor = iplot.EdgeColor*0.5 + 0.5*[1 1 1];
        iplot.Interpreter = 'none';
        subplot(1,2,2)
        surf(double(abs(MatCoor)));
        ;view(0,-90);colorbar;colormap jet

    end
end

