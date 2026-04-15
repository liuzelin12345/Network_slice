# Network Slice Deployment (MATLAB)  
项目在随机生成的底层物理网络上，为服务请求选择路径与 VNF 部署方案，并以综合代价最小化为目标完成部署决策。

## 项目目标

- 随机生成物理网络拓扑（接入节点、核心节点、传输节点）。
- 生成切片服务请求（大带宽类/低时延类）。
- 对每个请求进行路径选择与 VNF 部署/共享决策。
- 使用模拟退火搜索更优解，并通过约束校验判断是否可部署。

## 算法思路

1. 生成网络拓扑与节点分类（`generate_network.m`）。
2. 生成服务请求（`generate_service_d.m` / `generate_service_r.m`）。
3. 基于 `dijkstra.m` 预计算候选节点间最短路径。
4. 在 `SA.m` 中迭代生成部署决策（`generate_decision.m`），并用 `cost.m` 计算目标代价。
5. 使用 Metropolis 准则接受新解，降温迭代直到满足终止条件。
6. 通过 `cost_dv.m` 检查时延违约与 VNF 共享容量违约，决定请求是否成功部署。

## 代价函数（核心）

`cost.m` 中目标函数形式为：

- 部署与路径开销：与新部署 VNF 数量、路径长度、带宽相关
- 违约惩罚：
  - 时延超限惩罚
  - VNF 共享容量违约惩罚

## 项目结构

```text
Network_slice/
├── main.m                # 主入口：生成网络、生成请求、逐个部署
├── SA.m                  # 模拟退火求解
├── cost.m                # 代价函数
├── cost_dv.m             # 约束违约检查（d, v）
├── generate_network.m    # 物理网络生成与节点分类
├── generate_service_d.m  # 低时延类请求生成
├── generate_service_r.m  # 大带宽类请求生成
├── generate_decision.m   # 随机生成部署候选解
├── dijkstra.m            # 最短路径计算
├── test.m                # 绘图/实验展示脚本
└── *.fig                 # 实验结果图文件
```

## 运行环境

- MATLAB（R2019a+）

## 快速开始

1. 打开 MATLAB，将当前目录切换到项目根目录。
2. 运行主脚本：

```matlab
main
```
