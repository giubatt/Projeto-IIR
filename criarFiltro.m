%Projeto Filtro IIR
%Retorna zeros, polos e ganho do filtro especificado 

%Nome: Lucas Fernandes e Giuseppe Batistella 

%Data: 25/06/2016
%in: 
%n = ordem do filtro
%Wn = O escalar ou vetor das correspondentes frequencias de corte
%tipoFiltro = tipo do filtro a ser gerado

%out:
%z = zeros
%p = polos
%k = ganho

function [z,p,k] = criarFiltro(n,Wn,tipoFiltro)

    if (tipoFiltro == 0) %Filtro ButterWorth
        
        [z,p,k] = butter(n,Wn,'bandpass','s');
        
    elseif (tipoFiltro == 1) %Filtro Chebyshev 1
        
        [z,p,k] = cheby1(n,Apmod,Wn,'bandpass','s');
         
    elseif (tipoFiltro == 2) %Filtro Chebyshev 2
        
        [z,p,k] = cheby2(n,As,Wn,'bandpass','s');
            
    elseif (tipoFiltro == 3) %Filtro eliptico
        
        [z,p,k] = ellip(n,Apmod,As,Wn,'bandpass','s');

    end
end