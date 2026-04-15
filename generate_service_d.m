function [sr,dr,Vr,Br,Dr,drr]=generate_service_d(Na)
    sr=Na(randi(length(Na)));
    n=false;
    while n==false
        dr=Na(randi(length(Na)));
        if sr~=dr
            n=true;
        end
    end
    N=randi([2,5]);
    Vr=[];
    for i=1:N
        a=randi(7);
        nn=true;
        while nn
            aa=0;
            for j=1:length(Vr)
                if a==Vr(1,j)
                    aa=1;
                end
            end
            if aa==1
                a=randi(7);
            end
            if aa==0
                nn=false;
            end
        end
        Vr=[Vr,a];
    end
    Br=randi([3,5]);
    Dr=unifrnd(15,18);
    drr=randi([1,2]);
end