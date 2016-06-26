% Projeto Filtro IIR
% Programa principal
%
% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 25/06/2016

% clc;clear;close;

%% Parametros %
bits = 16;                  % Numero de bits (0 - sem quantizacao)
tipoFiltro = 2;             % Tipo do filtro (0 - bw, 1 - cb1, 2 - cb2, 3 - elp)
tipoTeste = 0;              % Tipo do teste (0 - impulso, 1 - senoides)
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
gEscal = 8.44;

% Pre distorcao das frequencias
WpDist = 2*ft*tan(Wp/2);
WsDist = 2*ft*tan(Ws/2);

% Modifica Ws para que fique simetrico em relacao a Wp
[WpDist, WsDist] = ajusteSimetria(WpDist, WsDist);

% Otimiza a especificacao do filtro p/ ter o menor Ap possivel com mesma ordem
[n,Wn,ApMin] = preOtimizacao(WpDist,WsDist,Ap,As,tipoFiltro);
% -------- %

%% Nao Quantizado - Impulsos %
if (tipoTeste == 0)
    %Retorna zeros, polos e ganho do filtro especificado
    [z, p, k] = criarFiltro(n,Wn,ApMin,As,tipoFiltro);
    %Mapeia o plano analogico (s) no plano digital (z)
    [zd, pd, kd] = bilinear(z,p,k,ft);
    %Converte a representacao zero-polo-ganho de tempo discreto na
    %representacao equivalente de segunda ordem
    [sos,g] = zp2sos(zd,pd,kd,'up','two');
    %Ajusta sos para evitar a saturacao de quantizacao
    sos = sos/a0Escal;
    g = g/gEscal;
    %Preenche x com a quantidade lengthx de zeros
    lengthx = 400;
    x = [g, zeros(1,lengthx)];
    %Implementa o filtro na forma direta II
    y = implementaIIR(n,lengthx,x,sos,a0Escal,bits);
    %Ajusta a entrada com o intuito de evitar a quantizacao de saturacao
    y = y*gEscal;

    %Plota a resposta em frequencia do filtro
    freqz(y(n,1:lengthx)); %Resolucao da dtft eh de 512
    % Ajustar eixos
    axis([0 1 -40 10])
    % Plotar gabarito
    gabarito(Wp,Ws,Ap,As)
elseif (tipoTeste == 1)
    
end
