function [pronto, ApMin]= otimizar(Wp,Ws,Ap,As,numSenoides,ganhoSin,sinW,ApMin)

    violacao = zeros(1,numSenoides);
    deltaAp = 0.01;

    for n=1:numSenoides
        % Banda de rejeicao
        if sinW(n) <= Ws(1)
            if ganhoSin(n) > (-As)
                violacao(n) = 1;
            end
        elseif sinW(n) >= Wp(1) && sinW(n) <= Wp(2)
            if ganhoSin(n) > 0 || ganhoSin(n) < (-Ap)
                violacao(n) = 1;
            end
        elseif sinW(n) >= Ws(2)
            if ganhoSin(n) > (-As)
                violacao(n) = 1;
            end
        end
    end

    pronto = not(any(violacao));

    if (pronto == 0)
        ApMin = ApMin - deltaAp;
    end
end
