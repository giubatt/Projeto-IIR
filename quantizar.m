% Projeto Filtro IIR 
% Quantizador
% Quantiza a funcao de acordo com a quantidade de bits do parametro
% 
% Autores: Lucas Fernandes e Giuseppe Bastitella
% Data: 25/06/2016
% 
% bits = quantidade de bits da mantissa, vetor = vetor a ser quantizado; 

function [vetor_quantizado] = quantizar(vetor, bits)
    if(bits == 0) 
        vetor_quantizado = vetor;
    else
        vetor_quantizado = round((vetor*2^bits))*(2^(-bits));  
        vetor_quantizado(vetor_quantizado>1) = 1;              % satura em 1 caso o valor ultrapasse 1
        vetor_quantizado(vetor_quantizado<-1) = -1;            % satura em -1 caso ultrapasse -1
    end
end