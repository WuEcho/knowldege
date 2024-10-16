# Defi相关内容学习




Defi, NFT, Gameri, UAU, SocialFi, Memecoin,Metaverse
EVM链 (polygon, fantom, avax, bsc)
Layer2 (Arbitrum, Optimism, Metis)
跨链桥/协议（Wormhole, Layerzero）
基础设施 （IPFS, The graph, Chainlink）
Web3 (Gitcoin, RabbitHole, ENS)
2024 ETF

## 时间点
2020年5月，Uniswap V2上线
2020年8月，YAM、Yearn，流动性挖矿，一池-二池模型
2020年9月，Binance Smart Chain上线，Heco、Tron，散户大规模玩defi
2020年12月，去中心化稳定币Basis Cash，加密圣杯
2021年夏天，polygon、fantom、avax，时光机原则
2021年9月，Arbitrum上线，L2的defi

## 一个简单的挖矿案例
假设有一个项目，叫“apple finance”。总量10亿枚apple。全部挖矿释放，无预留，持续30天一池：（3亿，比例较小，吸引TVL的同时防止被挖塌）
USDT pool, DAI pool, ETH pool, WBTC pool, UNI pool, COMP pool
二池：（7亿，比例较大，吸引爱好风险的人进场）
APPLE pool, APPLE-DAI LP pool
因为二池必须有APPLE币才能挖，收益高，吸引人们买币进来挖，相当于为币价提供了支撑。

时代背景：当年会玩钱包的用户都很少很少，导致apple这种矿币在中心化交易所上市之后，不会defi的人选择买入，从而承托了泡沫。

Defi 挖矿是高风险的理财/博弈，也是一种被认可的代币分发模型。因为更公平，更奖励核心参与者。
Defi挖矿出圈，培养了一批会使用钱包的用户，为defi各个赛道创造了环境

## Defi各个赛道

 defillama.com
 
 
| 赛道 | 主流应用(EVM技术栈) |
| --- | --- |
| Dex去中心化交易所 | Uniswap/Curve/PancakeSwap |
| Lending去中心化借贷 | Compound/Aave |
| Derivatives衍生品 | GMX/DYDX |
| CDP去中心化稳定币 | MakerDao/Liquity/Ethena |
| Liquid Staking质押 | Lido/SSV |
| Restacking再质押 | EigenLayer/Etherfi |
| RWA现实资产代币化 | Ondo/Marker RWA  |


曾经火过

| 机枪池 | Yearn |
| --- | --- |
| 算法稳定币 | Luna/Basis Cash/AMPL/OHM |
| Insurance 保险 | Nexus |
| 彩票 | Pooltogether |
| 基金 | Indexcorp |

## 去中心化交易所

- UniSwap
V2-无授权，AMM
V3-区间做市，专业化，提高资金效率

- `SushiSwap` 吸血鬼攻击-社区文化-开发部署激进
用户可以质押Uniswap的几种LP，进行sushi代币挖矿，不能提取在某个时间点后，Sushi通过将用户的LP解除，再质押到自己的合约中，实现吸血鬼攻击

- `Curve` 稳定币交易，治理模型
不是AMM，针对稳定币单独设计
3币池 (3pool), usdt-usdc-dai
项目方自己创建 ` ` 池，通过质押veCrv，获得更大的奖励比例

- `1inch` 交易聚合器，价格合适& mev保护
从全网所有swap协议的所有pool计算最佳价格
mev保护-交易走暗池

- `PancakeSwap`、QuickSwap、TraderJoe 等等evm链上出现大量fork
- `DYDX` 订单簿，早期成功的链上杠杆交易
- `GMX`引入`GLP`取代订单簿，代币分发使用`esToken`的方式。熊市里成长壮大起来

## 去中心化借贷
- `Compound`最先提出池子借贷模型 
- `Aave`创新性更强，推出稳定币

## 算法稳定币（2020-2022）
曾经非常重要的赛道，泡沫非常巨大，现在基本消失。
- AMPL 单币，用户余额每天变化，每个用户占总市值的份额不变。
- BasisCash：三币模型，算法稳定币，代码值得看。[代码解析算法稳定币Basis Cash运行机制-登链社区](https://learnblockchain.cn/article/1984)
- OHM：（3,3）囚徒困境模型
- Luna：双币（$LUNA-$UST） 基于用户的套利实现UST稳定
LUNA是空气币，价格波动
$UST<1美元，用户可以销毁`UST`铸造`LUNA`，铸造`LUNA`时一个`UST`当作一美元用。
$UST>1美元，用户还可以销毁`LUNA`铸造`UST`，铸造`UST`时，一个`UST`当做一美元。
Anchor承诺给用户20%APY的收益。吸引圈外用户大量购买UST理财，忽视了风险。
2022年5月崩溃，间接影响了FTX

## EVM公链齐发
- 交易所公链：市安bsc，火币heco.
- EVME: polygon, fantom, avax, tron, evmos, moonriver
- Layer2: Arbitrum, Optimism, Metis. ZKsync

## 时光机原则
一种投资原则。公链曾经同样适用。
当一条新的EVM链出现时，开发者都去做这条链上的对应以太坊的defi几大件，用户也都去参与，因为有利可图。

## Defi项目的生命周期
白皮书（融资）-测试网-正式发射- 流动性挖矿-追溯性空投- 代币正式发行-上CEX-持续迭代

## Defi玩家的分类
空投 airdrop：以小搏大的散户，测试网or正式网前期用户
理财 earn：大户根据平台产品特点，结合风险偏好，精算收益-成本，进行理财or套利挖矿farming：以平台币奖励用户，进行代币分发，吸引TVL

## 现在Defi的变化
1. ALL-in-one 整合化，不再money乐高（例如solana上的各种全功能defi）
2. 技术专业化，hack次数变少
3. 创新变困难，专业的金融知识，完善的激励模型，适应市场玩家的需求 （uniswap V3, GMX，pendle)
4. 旁氏泡沫的项目难再出现
5. 这种改变是好事？坏事

## 如何分析一个defi项目
### 网站
[defillama.com](https://defillama.com/)基本信息介绍和数据
[rootdata](https://www.rootdata.com/)融资信息和项目方信息
[tokenterminal.com](https://tokenterminal.com/)非常详细的数据，适合专业投研


### 指标
- 通用：自由流通市值`Market cap（币价自由流通市值, 未被锁定的处于可以自由流通的币的数量*单个币的价格）`，总稀释市值`FDV(币上限的数量（未被挖出或锁定或未分发的代币）*单个币的价格)`，协议收入`Revenue(收了多少手续费，创造了多少收入)`，代币价格、代币交易量。
- 特别：`TVL`总锁定价值，日活

## 安全
[https://darkhandbook.io/](https://darkhandbook.io/)慢雾安全手册
不看任何陌生人私信，不点陌生链接，任何时候保持怀疑关注最新安全事件

## 参考资料
"how to defi»
《how to defi: advanced》
DeFi史學研究：前Uniswap時代的萌芽產品與關鍵節點
DeFi史學研究：Uniswap開啟的DeFi全盛時代
蓝筹DeFi新叙事：复盘Aave与Compound基本面数据- PANews

