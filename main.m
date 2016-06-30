% Projeto Filtro IIR
% Programa principal
%
% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 25/06/2016

clc;clear;

%% Parametros %
bits = 12;                  % Numero de bits (0 - sem quantizacao)
tipoFiltro = 0;             % Tipo do filtro (0 - bw, 1 - cb1, 2 - cb2, 3 - elp)
tipoTeste = 1;              % Tipo do teste (0 - impulso, 1 - senoides)
numSenoides = 100;           % Numero de senoides
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
[n,Wn,ApMin] = preOtimizacao(WpDist,WsDist,Ap,As,tipoFiltro);
% -------- %

%% Nao Quantizado - Impulsos %
if (tipoTeste == 0)

    %Retorna zeros, polos e ganho do filtro especificado
    [z, p, k, n, Wn] = criarFiltro(WpDist,WsDist,ApMin,As,tipoFiltro);

    %Mapeia o plano analogico (s) no plano digital (z)
    [zd, pd, kd] = bilinear(z,p,k,ft);

    %Converte a representacao zero-polo-ganho de tempo discreto na
    %representacao equivalente de segunda ordem
    [sos,g] = zp2sos(zd,pd,kd,'up','two');

    %Ajusta sos para evitar a saturacao de quantizacao
    sos = sos/a0Escal;
    g = g/gEscal;

    %Preenche x com a quantidade lengthx de zeros
    lengthx = 100;
    x = [g, zeros(1,lengthx)];

    %Implementa o filtro na forma direta II
    y = implementaIIR(n,lengthx,x,sos,a0Escal,bits);

    %Ajusta a entrada com o intuito de evitar a quantizacao de saturacao
    y = y*gEscal;

    %Plota a resposta em frequencia do filtro
    freqz(y(n,1:lengthx));

    % Ajustar eixos
    axis([0 1 -40 10])

    % Plotar gabarito
    gabarito(Wp,Ws,Ap,As)
end

%% Teste com Senoides
if (tipoTeste == 1)
    pronto = 0;
    erro = 0;
    AsMin = As;
    while (pronto==0)        
        % Retorna zeros, polos e ganho do filtro especificado
        [z, p, k, n, Wn] = criarFiltro(WpDist,WsDist,ApMin,AsMin,tipoFiltro);

        % Mapeia o plano analogico (s) no plano digital (z)
        [zd, pd, kd] = bilinear(z,p,k,ft);

        % Converte a representacao zero-polo-ganho de tempo discreto na
        % representacao equivalente de segunda ordem
        [sos,g] = zp2sos(zd,pd,kd,'up','two');

        % Ajusta sos para evitar a saturacao de quantizacao
        sos = sos/a0Escal;

        % Freuencia e maximos de entrada e saida de cada senoide utilizada
        sinXmax = zeros(1,numSenoides);
        sinYmax = zeros(1,numSenoides);
        sinW = zeros(1,numSenoides);

        % THDs calculados usando formula e funcao do matlab
        THD = zeros(1,numSenoides);
        THDmatlab = zeros(1,numSenoides);

        for i=1:numSenoides
            % Criar senoide
            amostras = 1:1:500;
            w = ((i-1)/(numSenoides-1))*pi;
            sinW(i) = w;
            x = (1/gEscal)*cos(w*(amostras-1));
            % Maximo da entrada atual
            sinXmax(i) = max(abs(fft(x)));
            x = g*x;

            % Passa a entrada pelo filtro
            y = implementaIIR(n,max(amostras),x,sos,a0Escal,bits);

            % Maximo da saida atual
            sinYmax(i) = max(abs(fft(y(n,1:max(amostras)))));
            y = y*gEscal;

            % DFT da saida
            yDFT = fft(y(n,1:max(amostras)/2));

            % Fundamental
            fund = find(abs(yDFT) == max(abs(yDFT)));

            % Fundamental normalizada
            fundNorm = (max(amostras)/2)/fund(1);

            % Numero de harmonicos
            numHarm = nextpow2(fundNorm);

            % Harmonicos
            harmonicos = fund(1)*(1:numHarm);

            % Ganho de cada harmonico
            ganhoHarm = yDFT(harmonicos);

            % THD da senoide
            THD(i) = sqrt((sum(abs(ganhoHarm).^2) - (abs(ganhoHarm(1))^2))/abs(ganhoHarm(1))^2);
            THDmatlab(i) = db2mag(thd(y(n,1:max(amostras))));
        end

        % THDs medios
        THDmedio = sum(THD)/length(THD);
        THDmatlabMedio = sum(THDmatlab)/length(THDmatlab);

        % Ganhos de cada senoide
        ganhoSin = sinYmax./sinXmax;
        ganhoSin = 20*log10(ganhoSin);

        [pronto, ApMin, AsMin] = otimizar(Wp,Ws,Ap,As,numSenoides,ganhoSin,sinW,ApMin,AsMin);

        if (n>10 || ApMin <= 0)
            erro = 1;
        end
%         pronto = 1;
        stem((sinW/pi),ganhoSin) % Plotar ganho (dB)
        axis([0 1 -40 10]) % Ajustar eixos
        gabarito(Wp,Ws,ApMin,AsMin) % Plotar gabarito
    end

    if (erro==1)
        disp('ERRO: Nao foi possivel otimizar o filtro.')
    else
        stem((sinW/pi),ganhoSin) % Plotar ganho (dB)
        axis([0 1 -40 10]) % Ajustar eixos
        gabarito(Wp,Ws,Ap,As) % Plotar gabarito
    end
end


