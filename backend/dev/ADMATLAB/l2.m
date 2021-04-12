function r = l2(params)

w = params{1};
b = params{2};

nlayers = length(w);

all = [];
for il = 1:nlayers
    all = [all;[w{il}(:) ;b{il}(:)]];
end
r = sum(all.^2);

end

