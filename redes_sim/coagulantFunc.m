function [dosis, status] = coagulantFunc (Ti, Ci)

    if (Ti < 12)
        dosis = 0;

    elseif (Ti >= 94)
        a = -3.143e-7;
        b = 0.0005606;
        c = -0.01602;
        d = 75.46;
        
        dosis1 = 76.44 - 0.08533.*Ti - 0.003054.*Ci + 0.004229.*(Ti).^2 ...
                 - 0.002185.*Ti.*Ci + 0.0002715.*(Ci).^2 - 3.174e-06.*(Ti).^2.*Ci ... 
                 + 1.423e-06.*Ti.*(Ci).^2 - 1.513e-07.*(Ci).^3;
        dosis2 = a*(Ti).^3 + b*(Ti).^2 + c*(Ti) + d;
        dosis = (dosis1 + dosis2)/2;

    else
        p00 =      -136.4 ;
        p10 =       27.99 ;
        p01 =       2.909;
        p20 =      -1.319;
        p11 =     -0.2884;
        p30 =     0.02669;
        p21 =     0.00865;
        p40 =  -0.0001926 ;
        p31 =  -8.122e-05 ;

        x=Ti; y=Ci;

        dosis = p00 + p10.*x + p01.*y + p20.*x.^2 + p11.*x.*y + p30.*x.^3 + p21.*x.^2.*y + p40.*x.^4 + p31.*x.^3.*y;
            
    end
    
    if (Ti > 100)
        status = 'Degradado';
    else
        status = 'Normal';
    end
        
end