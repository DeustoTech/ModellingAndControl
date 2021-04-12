function [norm_dataset,Mean,STD] = NormalizedTable(dataset)

    Mean = mean(dataset{:,:});
    STD  = std(dataset{:,:});

    norm_dataset = normalize(dataset);

end

