function gabarito(wp,ws,Ap,As)
line([0 ws(1)/pi],[-As -As]);
line([ws(1)/pi ws(1)/pi],[-As 40]);
line([wp(1)/pi wp(1)/pi],[-40 -Ap]);
line([wp(1)/pi wp(1)/pi],[0 40]);
line([wp(1)/pi wp(2)/pi],[-Ap -Ap]);
line([wp(1)/pi wp(2)/pi],[0 0]);
line([wp(2)/pi wp(2)/pi],[-40 -Ap]);
line([wp(2)/pi wp(2)/pi],[0 40]);
line([ws(2)/pi ws(2)/pi],[-As 40]);
line([ws(2)/pi 1],[-As -As]);
end
