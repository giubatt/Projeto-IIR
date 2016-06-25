% Projeto Filtro FIR Passa Baixa
% Pre-otimizacao
% Calcula o menor Ap que continue com a mesma ordem do filtro
% 
% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 28/05/2016
% 
% in:
% Wp = limites de banda passante
% Ws = limites de banda de rejeicao
% Ap = ripple na banda passante
% As = atenuacao minima na banda de rejeicao
% filterType = tipo de filtro (0 - bw, 1 - cb1, 2 - cb2, 3 - elp)
% 
% out:
% n = ordem do filtro
% Wn = frequencias de corte do filtro
% ApMin = minimo ripple passante do filtro

function [n, Wn, ApMin] = preOtimizacao(Wp, Ws, Ap, As, filterType)
    if (filterType == 0)        % Butterworth
        [n,Wn,ApMin] = butterFolga(Wp, Ws, Ap, As, filterType);
        
    elseif (filterType == 1)    % Chebyshev 1
        [n,Wn,ApMin] = cheb1Folga(Wp, Ws, Ap, As, filterType);
        
    elseif (filterType == 2)    % Chebyshev 2
        [n,Wn,ApMin] = cheb2Folga(Wp, Ws, Ap, As, filterType);
        
    elseif (filterType == 3)    % Eliptico
        [n,Wn,ApMin] = ellipFolga(Wp, Ws, Ap, As, filterType);
    end
end