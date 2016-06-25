% Projeto Filtro IIR
% Programa principal
% 
% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 25/06/2016

clc;clear;close;

%% Parametros %
bits = 0;                   % Numero de bits (0 - sem quantizacao)
filterType = 0;             % Tipo do filtro (0 - bw, 1 - cb1, 2 - cb2, 3 - elp)
% -------- %

%% Especificacoes %
fp = [0.6 1.6]*10^3;        % Limites da banda passante
fs = [0.25 2.4]*10^3;       % Limites da banda de rejeicao
ft = 8*10^3;                % Frequencia de amostragem
Ap = 1;                     % Ripple na banda passante
As = 35;                    % Atenuacao minima da banda de rejeicao
% -------- %

%% Pre ajustes %
Wp = 2*pi*(fp/ft);          % Frequencias limite da banda passante normalizadas
Ws = 2*pi*(fs/ft);          % Frequencias limite da banda de rejeicao normalizadas

% Fatores de escalonamento
a0Escal = 6;
gEscal = 20.5;

% Pre distorcao das frequencias
WpDist = 2*ft*tan(Wp/2);
WsDist = 2*ft*tan(Ws/2);

% Modifica Ws para que fique simetrico em relacao a Wp
[WpDist, WsDist] = ajusteSimetria(WpDist, WsDist);   

% Otimiza a especificacao do filtro p/ ter o menor Ap possivel com mesma ordem
[n,Wn,ApMin] = preOtimizacao(WpDist,WsDist,Ap,As,filterType);
% -------- %

%% Nao Quantizado - Impulsos %
if (bits == 0)
    [z, p, k] = gerarFiltro(n,Wn,filterType);
    [zd, pd, kd] = bilinear(z,p,k,ft);
    [sos,g] = zp2sos(zp,pd,kd,'up','two');
    sos = sos/a0Escal;
    k = 345;
    x = [g, zeros(1,k)];
    
    [y,w] = implementaIIR(n,k,x,sos,a0Escal,bits);
    y = y*gEscal;
    
    figure
    freqz(y(Ordempb,1:k)); %Resolucao da dtft eh de 512
    % freqz ftw!
    axis([0 1 -40 10]) % Ajustar eixos
end