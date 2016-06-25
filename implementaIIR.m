function [y,w] = implementaIIR(ordem,k,x,sos,escal,bits)

y = zeros(ordem,k);
w = zeros(ordem,k);

for n=1:1:k
    for j=1:ordem
        a = [qt(sos(j,4),bits) qt(sos(j,5),bits) qt(sos(j,6),bits)];
        b = [qt(sos(j,1),bits) qt(sos(j,2),bits) qt(sos(j,3),bits)];

        if j==1
            if n==1
                continue;
            end
            yAnt = qt(x(n),bits);
        else
            yAnt = qt(y(j-1,n-1),bits);
        end
        
        
        if n>=3
            m=3;
        else
            m=n;
        end
        for i=1:1:m
            if i == 1
                w(j,n) = qt(w(j,n) + yAnt,bits);
            else
                w(j,n) = qt(w(j,n) - qt(a(i)*w(j,n-i+1),bits),bits);
            end
            y(j,n) = qt(y(j,n) + qt(b(i)*w(j,n-i+1),bits),bits);
            w(j,n) = qt(w(j,n)*escal,bits);
        end
    end
end

end