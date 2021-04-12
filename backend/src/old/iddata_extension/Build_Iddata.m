function idd1 = Build_Iddata(dataset,ControlVars,StateVars)


%
if iscell(dataset)
    ds_control = cell(1,length(dataset));
    ds_state = cell(1,length(dataset));
    ds_time = cell(1,length(dataset));

    %
    i = 0;

    for idat = dataset
        i = i + 1;
        ds_control{i} = idat{:}{:,ControlVars};
        ds_state{i} = idat{:}{:,StateVars};
        ds_time{i} = seconds(idat{:}.Time);
    end
else
    ds_time    = seconds(dataset.Time);
    ds_state   = dataset{:,StateVars};
    ds_control = dataset{:,ControlVars};
end
idd1 = iddata(ds_state,ds_control);
%
idd1.SamplingInstants = ds_time;
idd1.InputName = ControlVars;
idd1.OutputName = StateVars;

end

