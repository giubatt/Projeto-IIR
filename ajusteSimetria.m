% Projeto Filtro IIR
% Teste de simetria
% Calcula ws e wp que satisfacam a simetria, sem modificar wp
% 
% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 25/06/2016
% 
% in:
% ws = frequencias de banda de rejeicao
% wp = frequencias de banda passante
% 
% out:
% ws = freq de rejeicao simetricas em relacao a wp
% wp = freq de banda passante

function [wp, ws] = ajusteSimetria(wp, ws)
    if ( ws(1)*ws(2) < wp(1)*wp(2) )
        ws(1) = wp(1)*wp(2)/ws(2);
    else
        ws(2) = wp(1)*wp(2)/ws(1);
    end
end