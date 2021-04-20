function y = model(x,pr)

    x = fullyconnect(x,pr{1}.weights,pr{1}.bias);
    x = relu(x);
    y = fullyconnect(x,pr{2}.weights,pr{2}.bias);

end

