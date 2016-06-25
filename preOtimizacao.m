% Projeto Filtro FIR Passa Baixa
% Pre-otimizacao
% Calcula o menor Ap que continue com a mesma ordem do filtro

% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 28/05/2016

function [n, Wn, Ap] = preOtimizacao(Wp, Ws, Ap, As, filterType)
    if (filterType == 0)        % Butterworth
        [n,Wn,Ap] = butterFolga(Wp, Ws, Ap, As, filterType);
        
    elseif (filterType == 1)    % Chebyshev 1
        [n,Wn,Ap] = cheb1Folga(Wp, Ws, Ap, As, filterType);
        
    elseif (filterType == 2)    % Chebyshev 2
        [n,Wn,Ap] = cheb2Folga(Wp, Ws, Ap, As, filterType);
        
    elseif (filterType == 3)    % Eliptico
        [n,Wn,Ap] = ellipFolga(Wp, Ws, Ap, As, filterType);
    end
end