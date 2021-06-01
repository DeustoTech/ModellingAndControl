function [MatCoor,MatCoor_boolean,iplot,G] = LinearCoor(Ts,varargin)

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
    [MatCoor,P] = corrcoef(ds);
    %
    MatCoor_boolean = abs(MatCoor) > alpha;

    G = digraph(MatCoor_boolean,names);

    if Plots
        iplot = plot(G,'Layout','force');
        iplot.NodeFontSize = FontSize;
        iplot.MarkerSize = 9;
        iplot.EdgeColor = iplot.EdgeColor*0.5 + 0.5*[1 1 1];
        iplot.Interpreter = 'none';
    end
end

