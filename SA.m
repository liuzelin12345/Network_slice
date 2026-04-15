function [bestnode,bestdeploy,deployed,cost1]=SA(sr,dr,Vr,Br,Dr,drr,L,Nc,VNFn,R,PATH)
    %%%%%%%%%%%%%%%%%%%%%%模拟退火算法%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    deployed=0;
    cost1=0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%冷却表参数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N = 100;                        %马可夫链长度
    K = 0.5;                      %衰减参数
    S = 0.01;                       %步长因子
    T=50;                          %初始温度
    YZ = 0.1;                      %容差
    P = 0;                          %Metropolis过程中总接受点
    %%%%%%%%%%%%%%%%%%%%%%%%%%随机选点 初值设定%%%%%%%%%%%%%%%%%%%%%%%%%
    [preD,prenode,predeploy]=generate_decision(L,Vr,Nc,VNFn,sr,dr,PATH);
    [bestD,bestnode,bestdeploy]=generate_decision(L,Vr,Nc,VNFn,sr,dr,PATH);
    %%%%%%%%%%%每迭代一次退火一次(降温), 直到满足迭代条件为止%%%%%%%%%%%%
    deta=abs(cost(prenode,predeploy,Br,Dr,Vr,drr,R,VNFn,PATH)-cost(bestnode,bestdeploy,Br,Dr,Vr,drr,R,VNFn,PATH));
    while (deta > YZ) && (T>1)
        T=K*T;
        %%%%%%%%%%%%%%%%%%%%%在当前温度T下迭代次数%%%%%%%%%%%%%%%%%%%%%%
        for i=1:N  
            %%%%%%%%%%%%%%%%%在此点附近随机选下一点%%%%%%%%%%%%%%%%%%%%%
            [nextD,nextnode,nextdeploy]=generate_decision(L,Vr,Nc,VNFn,sr,dr,PATH);
            %%%%%%%%%%%%%%%%%%%%%%%是否全局最优解%%%%%%%%%%%%%%%%%%%%%%
            if (cost(bestnode,bestdeploy,Br,Dr,Vr,drr,R,VNFn,PATH) > cost(nextnode,nextdeploy,Br,Dr,Vr,drr,R,VNFn,PATH))
                %%%%%%%%%%%%%%%%%%保留上一个最优解%%%%%%%%%%%%%%%%%%%%%
                prenode = bestnode;
                predeploy = bestdeploy;
                %%%%%%%%%%%%%%%%%%%此为新的最优解%%%%%%%%%%%%%%%%%%%%%%
                bestnode =nextnode;
                bestdeploy = nextdeploy;
            end
            %%%%%%%%%%%%%%%%%%%%%%%% Metropolis过程%%%%%%%%%%%%%%%%%%%
            if( cost(prenode,predeploy,Br,Dr,Vr,drr,R,VNFn,PATH) - cost(nextnode,nextdeploy,Br,Dr,Vr,drr,R,VNFn,PATH) > 0 )
                %%%%%%%%%%%%%%%%%%%%%%%接受新解%%%%%%%%%%%%%%%%%%%%%%%%
                prenode = nextnode;
                predeploy = nextdeploy;
                P=P+1;
            else
                changer = -1*(cost(nextnode,nextdeploy,Br,Dr,Vr,drr,R,VNFn,PATH)-cost(prenode,predeploy,Br,Dr,Vr,drr,R,VNFn,PATH))/ T ;
                p1=exp(changer);
                %%%%%%%%%%%%%%%%%%%%%%%%接受较差的解%%%%%%%%%%%%%%%%%%%%
                if p1 > rand        
                    prenode = nextnode;
                    predeploy = nextdeploy;
                    P=P+1;         
                end
            end
            trace(P+1) = cost(bestnode,bestdeploy,Br,Dr,Vr,drr,R,VNFn,PATH);
        end
        deta=abs(cost(prenode,predeploy,Br,Dr,Vr,drr,R,VNFn,PATH)-cost(bestnode,bestdeploy,Br,Dr,Vr,drr,R,VNFn,PATH));
    end
    [d,v]=cost_dv(bestnode,bestdeploy,Br,Dr,Vr,drr,R,VNFn,PATH);
    dv=[d,v]
    if d+v==0
        deployed=1;
        cost1=cost(bestnode,bestdeploy,Br,Dr,Vr,drr,R,VNFn,PATH);
    end
end


