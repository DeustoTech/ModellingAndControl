function dxdt = dyn(x)
    
    k1 = 1.0;
    k2 = 0.5;
    k3 = 0.0;
    
    dx1 = -k1*x(1) + k3*x(3);
    dx2 = -k2*x(2)+k1*x(1);
    dx3 = +k2*x(2) - k3*x(3);
    
    dxdt = [dx1;dx2;dx3];
end

