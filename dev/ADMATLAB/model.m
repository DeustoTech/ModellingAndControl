function [x] = model(x,params)
    

w = params{1};
b = params{2};
n = length(w);

x = relu(fullyconnect(x,w{1},b{1}));

for in = 2:n-1
    x = relu(fullyconnect(x,w{in},b{in}));
end
x = fullyconnect(x,w{in+1},b{in+1});


end