% Projeto Filtro IIR
% Programa principal

% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 25/06/2016

clc;clear;close;

%% Especificacoes %
fp = [0.6 1.6]*10^3;	% Limites da banda passante
fs = [0.25 2.4]*10^3;	% Limites da banda de rejeicao
ft = 8*10^3;            % Frequencia de amostragem
Ap = 1;                 % Ripple na banda passante
As = 35;                % Atenuacao minima da banda de rejeicao
% -------- %

