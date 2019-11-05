function sedimentFunc (qi1, T, Tprev)

    global s;
    valveIndex1 = s.getLinkIndex('2');
    valveIndex2 = s.getLinkIndex('13');
    
    if (T < 12) %&& Tprev >= 12)
        q = qi1 + 0.12;
        s.setLinkSettings(valveIndex1, q);
        
    elseif (T>=97) % && Tprev<100)
        %q = qi1 + 0.503;
        q = 0;
        s.setLinkSettings(valveIndex1, q);
        
    else %&& (Tprev<12 || Tprev>=100))
        q = qi1 + 0.2;
        s.setLinkSettings(valveIndex1, q);
        
    
    end
    
end