function [Ti, Ci, DSA, To, Co] = loadData()

    data = {load('abr2813.mat'), load('abr2913.mat'), load('abr3013.mat'), ...
        load('sep0915'), load('sep1015'), load('sep1115')};
    
    Ti=[]; Ci=[]; DSA=[]; To=[]; Co=[];
    i = 1;
    
    % degradado
    % rr=[1 2 1 2];
    % falla
    %x = load('falla');
    %rr = [3 5 3 5];
    
    while i < 5
        r = randi([1 6],1,1)
        %ideal
        %r = 4;
        %degradado y falla
        %r = rr(i);
        
%         %falla
%         Ti = x.Ti;
%         Ci = x.Ci;
%         DSA = x.DSA;
        
        if i==1
            x = data(r);
            Ti = x{1}.Ti;
            Ci = x{1}.Ci;
            DSA = x{1}.DSA;
            To = x{1}.To;
            Co = x{1}.Co;
        else
            x = data(r);
            Ti = [Ti; x{1}.Ti];
            Ci = [Ci; x{1}.Ci];
            DSA = [DSA; x{1}.DSA];
            To = [To; x{1}.To];
            Co = [Co; x{1}.Co];
        end
        i = i+1;
    end
end