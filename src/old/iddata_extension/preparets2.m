function [Us,Ui,Ai,Ys] = preparets2(net,idd)

[tspan,yt,ut] = getdata(idd);

Nt = length(tspan);

yt_cell = arrayfun(@(it) yt(:,it),1:Nt,'UniformOutput',false);
ut_cell = arrayfun(@(it) ut(:,it),1:Nt,'UniformOutput',false);

[Us,Ui,Ai,Ys] = preparets(net,ut_cell,{},yt_cell);

end

