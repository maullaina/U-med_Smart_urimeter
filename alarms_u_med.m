function result = alarms_u_med(vect_vol,pos)

    if vect_vol(pos) < 60 && vect_vol(pos) >= 45
        msgbox('DIURESIS CORRECT');
        result = 1;
    end

    if vect_vol(pos) < 40 && vect_vol(pos) > 15
        msgbox('OLIGURIA','Altert', 'error');
        result = 2;
    end

    if vect_vol(pos)  <= 15
        msgbox('ANURIA','Altert', 'error');
        result = 3;
    end

    if vect_vol(pos)  < 100 && vect_vol(pos)  > 60
        msgbox('TENDENCY TO POLYURIA','Altert', 'error');
        result = 4;
    end


    if vect_vol(pos)  >= 100
        msgbox('POLYURIA','Altert', 'error');
        result = 5;
    end

    if vect_vol(pos) <=45 && vect_vol(pos)>=40
        msgbox('CORRECT BUT TENDENCY TO OLIGURIA','Altert', 'error'); 
        result = 6;
    end
    
end
