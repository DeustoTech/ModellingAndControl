function r = set_params
    r.Height = 7;
    r.Width = 40;
    r.Depth = 50;
    r.Area = r.Width * r.Depth;
    r.Volumen = r.Area * r.Height;
    r.Cp  = 1006;
    r.rho = 1.2;
    
    r.U = 5.815;
    %r.U = 2.815;

    r.rhocpV = 0.1/(r.rho * r.Cp * r.Volumen);
    r.SS = 2*r.Height *( r.Width + r.Depth ) + r.Area;
    
    r.TasaVen.Acenital = 10;
    r.TasaVen.Cd = 0.6;
    r.TasaVen.Cw = 0.1;

    r.g = 9.8;
    
end

