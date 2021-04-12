function xT = euler(f,x0,T,params)

    import casadi.*
    Nt = 50;
    dt = T/Nt;
    xT = x0;
    for it = 1:Nt
        xT = xT + dt*f(xT,params);
    end
end