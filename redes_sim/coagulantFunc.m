function [dosis, status] = coagulantFunc (Ti, Ci)

    if (Ti < 12)
        dosis = 0;
    else

        dosis1 = 76.44 - 0.08533.*Ti - 0.003054.*Ci + 0.004229.*(Ti).^2 ...
                 - 0.002185.*Ti.*Ci + 0.0002715.*(Ci).^2 - 3.174e-06.*(Ti).^2.*Ci ... 
                 + 1.423e-06.*Ti.*(Ci).^2 - 1.513e-07.*(Ci).^3;
             
        a = -3.143e-7;
        b = 0.0005606;
        c = -0.01602;
        d = 75.46;

        dosis2 = a*(Ti).^3 + b*(Ti).^2 + c*(Ti) + d;

        dosis = (dosis1 + dosis2)/2;
    end
    
    if (Ti > 100)
        status = 'Degradado';
    else
        status = 'Normal';
    end
        
end