
count_node=50; %网络节点数量
N=1;         %网络服务请求数量
n=1;           %迭代变量
R1={};         %网络切片1的请求集合(大带宽)
R2={};         %网络切片2的请求集合(低延迟)
a1=0.5;        %网络切片1的优先级
a2=0.7;        %网络切片2的优先级
r1=0;n1=1;     %网络切片1的服务接受统计
r2=0;n2=1;     %网络切片2的服务接受统计
q=1;           %q=1代表网络切片1，q=2代表网络切片2
R={};          %已部署的请求集合
VNFn=[0,0,0,0,0,0,0];   %已部署的VNF数量
Cost=[];        %部署成本集合
% VNFn=VNFnCopy
% R=RCopy
% Cost=CostCopy


%生成底层物理网络
[L,Na,Nc,Nt]=generate_network(count_node);
Nn=zeros([1,count_node]);
%生成请求集合
for i=1:N
    [sr,dr,Vr,Br,Dr,drr]=generate_service_d(Na);
    r={sr,dr,Vr,Br,Dr,drr};
    R2{1,i}=r;
end
% for i=1:N/2
%     [sr,dr,Vr,Br,Dr,drr]=generate_service_r(Na);
%     r={sr,dr,Vr,Br,Dr,drr};
%     R1{1,i}=r;
%     [sr,dr,Vr,Br,Dr,drr]=generate_service_d(Na);
%     r={sr,dr,Vr,Br,Dr,drr};
%     R2{1,i}=r;
% end
%依次部署
while n<=N
    %选择网络服务请求
%     if (2*a1*r1/N>=2*a2*r2/N)|(n2<=50)
%         sr=R2{1,n2}{1};
%         dr=R2{1,n2}{2};
%         Vr=R2{1,n2}{3};
%         Br=R2{1,n2}{4};
%         Dr=R2{1,n2}{5};
%         drr=R2{1,n2}{6};
%         n2=n2+1;
%         q=2;
%     else
%         sr=R1{1,n1}{1};
%         dr=R1{1,n1}{2};
%         Vr=R1{1,n1}{3};
%         Br=R1{1,n1}{4};
%         Dr=R1{1,n1}{5};
%         drr=R1{1,n1}{6};
%         n1=n1+1;
%         q=1;
%     end
    sr=R2{1,n2}{1};
    dr=R2{1,n2}{2};
    Vr=R2{1,n2}{3};
    Br=R2{1,n2}{4};
    Dr=R2{1,n2}{5};
    drr=R2{1,n2}{6};
    n2=n2+1;
    %构建单跳调度图
    Node=[sr,Nc,dr];
    C=zeros(length(Nc)+2);
    PATH={};
    for i=1:length(C)
        for j=1:length(C)
            [min,path]=dijkstra(L,Node(i),Node(j));
            PATH{i,j}=path;
        end
    end
    %SA算法求解
    [bestnode,bestdeploy,deployed,cost]=SA(sr,dr,Vr,Br,Dr,drr,L,Nc,VNFn,R,PATH);
    [n,deployed]
    %保存结果
    if deployed==1
        r={sr,dr,Vr,Br,Dr,drr,bestnode,bestdeploy};
        R{1,length(R)+1}=r;
        for i=1:length(Vr)
            VNFn(1,Vr(1,i))=VNFn(1,Vr(1,i))+bestdeploy(1,i);
        end
        Cost=[Cost,cost];
        if q==1
            r1=r1+1;
        else
            r2=r2+1;
        end
    end
   
    %更新网络
    for i=1:length(R)
        node=R{1,i}{1,7};
        deploy=R{1,i}{1,8};
        for j=1:length(deploy)
            Nn(1,node(1,j+1))=Nn(1,node(1,j+1))+deploy(1,j);
        end
    end
%     for i=1:length(Nn)
%         if Nn(1,i)==5
%             index=find(Nc==i);
%             Nc(index)=[];
%         end
%     end
    n=n+1;
end

    
    
    
    
       
    
