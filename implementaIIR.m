% Projeto Filtro IIR
% Implementa o filtro na forma direta II

% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 25/06/2016

%in:
% oderm = ordem do filtro
% k = quantidade de zeros em x
% sos = Second-order-sections (retornado pela funcao sos();)
% escal = escalar de a0
% bits = quantidade de bits a ser quantizado

%out:
% y = saida do filtro

function y = implementaIIR(ordem,k,x,sos,escal,bits)

y = zeros(ordem,k);
w = zeros(ordem,k);

% for n=1:1:k
%     for j=1:ordem
%         a = [quantizar(sos(j,4),bits) quantizar(sos(j,5),bits) quantizar(sos(j,6),bits)];
%         b = [quantizar(sos(j,1),bits) quantizar(sos(j,2),bits) quantizar(sos(j,3),bits)];
% 
%         if j==1
%             yAnt = quantizar(x(n),bits);
%         else
%             if n~=1
%                 yAnt = quantizar(y(j-1,n-1),bits);
%             else
%                 yAnt = 0;
%             end
%         end
% 
%         if n>=3
%             m=3;
%         else
%             m=n;
%         end
%         for i=1:1:m
%             if i == 1
%                 w(j,n) = quantizar(w(j,n) + yAnt,bits);
%             else
%                 w(j,n) = quantizar(w(j,n) - quantizar(a(i)*w(j,n-i+1),bits),bits);
%             end
%         end
%         w(j,n) = quantizar(w(j,n)*escal,bits);
% 
%         for i=1:1:m
%             y(j,n) = quantizar(y(j,n) + quantizar(b(i)*w(j,n-i+1),bits),bits);
%         end
%     end
% end

for n=1:1:k

    for j=1:ordem
        b = [quantizar(sos(j,1),bits) quantizar(sos(j,2),bits) quantizar(sos(j,3),bits)];
        a = [quantizar(sos(j,4),bits) quantizar(sos(j,5),bits) quantizar(sos(j,6),bits)];

        if n-2<=0 && n-1<=0 % n=1;
            if j==1
                w(j,n)=(x(1))/(1/escal);
                y(j,n)=quantizar(b(1)*w(j,n),bits);
            else
                w(j,n)=0;
                y(j,n)=0;
            end
        elseif n-2<=0 && n-1>=1 % n=2;
            if j==1
                w(j,n)=quantizar((quantizar(-a(2)*w(j,n-1),bits)+x(2))/(1/escal),bits);
                y(j,n)=quantizar(quantizar(b(1)*w(j,n),bits)+quantizar(b(2)*w(j,n-1),bits),bits);
            else
                w(j,n)=quantizar((y(j-1,n-1)+quantizar(-a(2)*w(j,n-1),bits))/(1/escal),bits);
                y(j,n)=quantizar(quantizar(b(1)*w(j,n),bits)+quantizar(b(2)*w(j,n-1),bits),bits);
            end
        else % n>=3;
            if j==1
                w(j,n)=quantizar((x(n)+quantizar(-a(2)*w(j,n-1),bits)+quantizar(-a(3)*w(j,n-2),bits))/(1/escal),bits);
                y(j,n)=quantizar(quantizar(b(1)*w(j,n),bits)+quantizar(b(2)*w(j,n-1),bits)+quantizar(b(3)*w(j,n-2),bits),bits);
            else
                w(j,n)=quantizar((y(j-1,n-1)+quantizar(-a(2)*w(j,n-1),bits)+quantizar(-a(3)*w(j,n-2),bits))/(1/escal),bits);
                y(j,n)=quantizar(quantizar(b(1)*w(j,n),bits)+quantizar(b(2)*w(j,n-1),bits)+quantizar(b(3)*w(j,n-2),bits),bits);   
            end
        end
    end

end
