function [y,w] = implementaIIR(ordem,k,x,sos,escal,bits)

y = zeros(ordem,k);
w = zeros(ordem,k);

for n=1:1:k
    for j=1:ordem
        a = [quantizar(sos(j,4),bits) quantizar(sos(j,5),bits) quantizar(sos(j,6),bits)];
        b = [quantizar(sos(j,1),bits) quantizar(sos(j,2),bits) quantizar(sos(j,3),bits)];
        
        
        if j==1
            yAnt = quantizar(x(n),bits);
        else
            if n~=1
                yAnt = quantizar(y(j-1,n-1),bits);
            else
                yAnt = 0;
            end
        end
        
        if n>=3
            m=3;
        else
            m=n;
        end
        for i=1:1:m
            if i == 1
                w(j,n) = quantizar(w(j,n) + quantizar(yAnt*escal,bits),bits);
            else
                w(j,n) = quantizar(w(j,n) - quantizar(quantizar(a(i)*w(j,n-i+1),bits)*escal,bits),bits);
            end
        end
        
        for i=1:1:m
            y(j,n) = quantizar(y(j,n) + quantizar(b(i)*w(j,n-i+1),bits),bits);
        end
    end
end

end