function [denorm_dataset] = deNormalizedTable(dataset,Mean,STD)

    denorm_dataset = (STD.*dataset{:,:} + Mean);
    denorm_dataset = array2table(denorm_dataset,'VariableNames',dataset.Properties.VariableNames);
    
end

