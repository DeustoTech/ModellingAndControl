function [dataset,Mean,STD] = NormalizedTableCell(dataset)

    fulldata = cat(1,dataset{:});

    ind = isnan(fulldata{:,end});

    fulldata(ind,:) = [];

    Mean = mean(fulldata{:,2:end});
    STD  = std(fulldata{:,2:end});

    vars = dataset{1}.Properties.VariableNames(2:end);

    for i = 1:length(dataset)
        nvar = 0;
        for ivar = vars
            nvar = nvar + 1;
            dataset{i}.(ivar{:}) = (dataset{i}.(ivar{:}) - Mean(nvar))/STD(nvar);
        end
    end
end

