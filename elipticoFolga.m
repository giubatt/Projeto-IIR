%Projeto Filtro IIR
%Ajusta a ordem do fitro Eliptico
%Retorna ordem e valor do ripple na banda passente ajustado
%para o valor mínimo na ordem gerada por ellipord()

%Nome: Lucas Fernandes e Giuseppe Batistella 

%Data: 25/06/2016
%in: 
%Wp = Frequencia de corte na banda passante
%Ws = Frequencia de corte na banda de rejeicao
%Ap = Ripple na banda passante
%As = Atenuacao na banda de rejeicao


%out:
%Apmin = ripple na banda apos o ajuste de folga
%Wn = O escalar ou vetor das correspondentes frequencias de corte

function [n,Wn,Apmin] = elipticoFolga(Wp,Ws,Ap,As)

    %[n,Wn] = ellipord(Wp,Ws,Rp,Rs,'s')encontra a menor ordem 'n' e a frequecia de corte Wn para o filtro analogico Eliptico.
    [n,Wn] = ellipord(Wp,Ws,Ap,As,'s');
    N = n+1;    
    while n<N         %Ajusta Ap ate a ordem aumentar 
        Ap = Ap-0.0001;             
        [n,Wn] = ellipord(Wp,Ws,Ap,As,'s');  
    end
    Ap = Ap+0.0001;         %Retorna ao valor que Ap possuia da ordem aumentar
    n = n-1;                %Retorna a ordem inicialmente gerada por ellipord()
    [n,Wn] = ellipord(Wp,Ws,Ap,As,'s');
    
end