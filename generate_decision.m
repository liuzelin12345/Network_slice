function [D,node,deploy]=generate_decision(L,Vr,Nc,VNFn,sr,dr,PATH)
    nodev=[];
    deploy=[];
    y=cell([1,length(Vr)]);    
    s=cell([1,length(Vr)]);
    for i=1:length(y)
        a=zeros([1,length(L)]);
        b=Nc(1,randi(length(Nc)));
        nn=true;
        while nn
            aa=0;
            for j=1:length(nodev)
                if b==nodev(1,j)
                    aa=1;
                end
            end
            if aa==1
                b=Nc(1,randi(length(Nc)));
            end
            if aa==0
                nn=false;
            end
        end
        nodev=[nodev,b];
        n=rand();
        if n<=0.3
            a(1,b)=1;
            y{1,i}=a;
            s{1,i}=zeros([1,length(L)]);
        else
            if VNFn(1,Vr(1,i))>0
                a(1,b)=1;
                s{1,i}=a;
                y{1,i}=zeros([1,length(L)]);
            else
                a(1,b)=1;
                y{1,i}=a;
                s{1,i}=zeros([1,length(L)]);
            end
        end
    end
    for i=1:length(y)
        deploy=[deploy,sum(y{1,i})];
    end

    z=cell([1,length(Vr)+1]);
    node=[sr,nodev,dr];
    for i=1:length(z)
        a=zeros(length(L));
        for j=1:length(PATH)
            for k=1:length(PATH)
                if PATH{j,k}(1,1)==node(i) && PATH{j,k}(1,length(PATH{j,k}))==node(i+1)
                    path=PATH{j,k};
                end
            end
        end
        for j=1:length(path)-1
            a(path(1,j),path(1,j+1))=1;
        end
        z{1,i}=a;
    end
    %约束2
    f1=0;
    while f1==0
        f2=0;
        q=0;
        for i=1:length(s)
            for j=1:length(L)
                if (s{1,i}(1,j)==1)&(y{1,i}(1,j)==1)
                    f2=1;
                    q=i;
                end
            end
        end
        if f2==1
            a=zeros([1,length(L)]);
            b=Nc(1,randi(length(Nc)));
            a(1,b)=1;
            s{1,q}=a;
        end
        if f2==0
            f1=1;
        end
    end
    D={y,s,z};             
end