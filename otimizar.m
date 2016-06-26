function [pronto, ApMin, AsMin]= otimizar(Wp,Ws,Ap,As,numSenoides,ganhoSin,sinW,ApMin,AsMin)
    
    violaPass = 0;
    violaRej = 0;
    deltaAp = 0.005;
    deltaAs = 0.5;

    for n=1:numSenoides
        % Banda de rejeicao
        if sinW(n) <= Ws(1)
            if ganhoSin(n) > (-As)
                violaRej = 1;
            end
        % Banda passante
        elseif sinW(n) >= Wp(1) && sinW(n) <= Wp(2)
            if ganhoSin(n) > 0 || ganhoSin(n) < (-Ap)
                violaPass = 1;
            end
        % Banda de rejeicao
        elseif sinW(n) >= Ws(2)
            if ganhoSin(n) > (-As)
                violaRej = 1;
            end
        end
    end

    pronto = ~violaRej && ~violaPass;

    if (violaPass == 1)
        ApMin = ApMin - deltaAp;
    end
    if (violaRej == 1)
        AsMin = AsMin + deltaAs;
    end
end
