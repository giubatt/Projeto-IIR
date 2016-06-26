function [y,w] = implementaIIR(ordem,k,x,sos,escal,bits)

y = zeros(ordem,k);
w = zeros(ordem,k);

for n=1:1:k
    for j=1:ordem
        a = [sos(j,4) sos(j,5) sos(j,6)];
        b = [sos(j,1) sos(j,2) sos(j,3)];
        
        
        if j==1
            yAnt = x(n);
        else
            if n~=1
                yAnt = y(j-1,n-1);
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
                w(j,n) = w(j,n) + yAnt*escal;
            else
                w(j,n) = w(j,n) - a(i)*w(j,n-i+1)*escal;
            end
        end
        
        for i=1:1:m
            y(j,n) = y(j,n) + b(i)*w(j,n-i+1);
        end
    end
end

end