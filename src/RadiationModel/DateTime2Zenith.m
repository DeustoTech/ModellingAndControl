function theta = DateTime2Zenith(LocalTime,Longitud,Latitud,DGMT)  
    %
    angle = DateTime2Elevation(LocalTime,Longitud,Latitud,DGMT);

        
    if angle > 0
        theta = 90 - angle ;
    elseif angle <= 0
        theta =  90+abs(angle);
    end
    
end

