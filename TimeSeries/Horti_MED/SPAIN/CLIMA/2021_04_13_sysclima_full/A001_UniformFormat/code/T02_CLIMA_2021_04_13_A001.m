clear 

list = ["E0_S2_2016", ...
        "E0_S1_2017","E0_S2_2017", ...
        "E0_S1_2018","E0_S2_2018", ...
        "E0_S1_2019"]
%%
i = 1;
for il = list
    i = i + 1;
    il
    ds{i} = T01_CLIMA_2021_04_13_A001(il);
end
%%
full= vertcat(ds{2:end});
%%
save("" + MainPath + 'TimeSeries/Horti_MED/SPAIN/CLIMA/2021_04_13_sysclima_full/A001_UniformFormat/output/dataset01.mat','ds','full')
