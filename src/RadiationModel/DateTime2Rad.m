function rad = DateTime2Rad(DateTime,Longitud,Latitud,DGMT)

    theta = DateTime2Zenith(DateTime,Longitud,Latitud,DGMT) ;
    
    if theta > 90
        rad = 0;
    else
        AM = 1/cos(theta*(pi/180));
        %rad = 1e3*1.353*0.7^(AM^2.1);
        %rad = 1e3*1.353*0.70^(AM^0.678);
        rad = 1e3*1.353*0.68^(AM^1.5);

    end


end

