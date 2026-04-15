function [d,v]=cost_dv(node,deploy,Br,Dr,Vr,drr,R,VNFn,PATH)
    Path=[node(1,1)];
    shareVNFn=zeros([1,7]);
    for i=1:length(node)-1
        for j=1:length(PATH)
            for k=1:length(PATH)
                if PATH{j,k}(1,1)==node(i) && PATH{j,k}(1,length(PATH{j,k}))==node(i+1)
                    path=PATH{j,k};
                end
            end
        end
        for j=2:length(path)
            Path=[Path,path(1,j)];
        end
    end
    c=10*sum(deploy)+Br*(length(Path)-1);
    d=2*sum(deploy)+(drr/Br)*(length(Path)-1);
    for i=1:length(R)
        dv=R{1,i}{1,8};
        vr=R{1,i}{1,3};
        for j=1:length(dv)
            if dv(1,j)==0
                shareVNFn(1,vr(1,j))=shareVNFn(1,vr(1,j))+R{1,i}{1,6};
            end
        end
    end
    for i=1:length(deploy)
        if deploy(1,i)==0
            shareVNFn(1,Vr(1,i))=shareVNFn(1,Vr(1,i))+drr;
        end
    end     
    v=0;
    for i=1:length(VNFn)
        if (shareVNFn(1,i)-20*VNFn(1,i)>0)
            v=v+1;
        end
    end
    if d<Dr
        d=0;
    else
        d=d-Dr;
    end  
end