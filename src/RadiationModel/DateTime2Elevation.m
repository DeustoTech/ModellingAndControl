function [alpha] = DateTime2Elevation(LocalTime,Longitud,Latitud,DGMT)

    delta =  Day2Declination(LocalTime);
    HRA = DateTime2HRA(LocalTime,Longitud,DGMT);
    
    angle = (sin((pi/180)*delta)*sin((pi/180)*Latitud) + ....
             cos((pi/180)*delta)*cos((pi/180)*Latitud)*cos((pi/180)*HRA));
    
    alpha = asin(angle)*(180/pi);
    
end

