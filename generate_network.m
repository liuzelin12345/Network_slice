function [L,Na,Nc,Nt]=generate_network(count_node)
    %接入节点：核心节点：传输节点 2：3：5
    s=randi(count_node,1,3*count_node);
    t=randi(count_node,1,3*count_node);
    % 消除回环
    for i=1:3*count_node
        if s(1,i)==t(1,i)
            n=false;
            while n==false
               t(1,i)=randi(count_node);
               if s(1,i)~=t(1,i)
                   n=true;
               end
            end

        end
    end
    % 生成邻接矩阵
    L=zeros(count_node);
    for i=1:3*count_node
        L(s(i),t(i))=1;
        L(t(i),s(i))=1;
    end
    B=zeros(1,count_node);
    for i=1:count_node
        B(i)=sum(L(i,:));
    end
    [B,N]=sort(B);
    Na=N(1,1:count_node*0.2);
    N=N(1,count_node*0.2+1:count_node);
    N=N(randperm(length(N)));
    Nc=N(1,1:count_node*0.3);
    Nt=N(1,count_node*0.3+1:length(N));  
end

% g=graph(G);
% plot(g);

