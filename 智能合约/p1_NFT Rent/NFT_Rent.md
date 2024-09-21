# 实战项目 NFT_Rent nft租赁

## 开发流程

1. 明确需求
2. 后台数据采集
3. 开发测试
4. 部署测试 + 审计
5. 可升级合约 
6. 提升TVL
7. 发行Token 

Token 一般包含：

- 1.经济模型，即份额的分配
- 2.治理
- 3.提案投票
- 4.更改合约 包括升级和参数修改 时间锁保证合约不会被随意升级
- 5.空投 
    - 白名单
    - 默克尔树 
- 6.做市 上dex
- 7.为了增加交易池深度，作质押挖矿 
    - 本币`token`质押 领固定收益
    - 质押 `LP Token`  给一定份额的本币`token`质押
- 8.cex


## 业务功能

- 1. 展示热门NFT集合
- 2. 浏览上架出租的NFT
- 3. 自定义费用，时间，押金，上架NFT
- 4. 自付费用和租金（任意token）来租下NFT
- 5. 到期归还NFT,赎回押金
- 6. 每逾期1天收取1%费用，从押金中扣除
- 7. 逾期12天后，出租方强制进行清算，放弃NFT,获取全部押金

## 治理代币功能

- 1. IDO发行代币
- 2. 空投代币
- 3. 白名单领取代币
- 4. 治理提案
- 5. 质押LP挖矿

## 项目结构
来取模板[openspace-nft](https://github.com/zhanglehui0612/openspace-nft),项目结构：

```
|--- contracts: 合约模块
|--- theGraph: 链上数据定制
 --- web：前端 
```
## 启动
在`web`目录下，使用命令`pnpm dev`

## 前端

前端启动步骤：

 - 1. 安装nodejs：[查看如下链接](https://nodejs.org/en/download/package-manager)
 - 2. 安装pnmp: `npm install -g pnpm`

## 安装viem
同样在`web`目录下：
`pnpm i viem`


## 前端托管

https://vercel.com.home


## 钱包链接

使用[wagmi](https://wagmi.sh/vue/guides/connect-wallet),

### 安装
在`web`目录下执行如下命令：
`pnpm add @wagmi/vue viem@2.x @tanstack/vue-query`

### 配置信息

- 1. 在`web`的`src`目录下创建`config.ts`文件，并粘贴如下内容：

```
import { http, createConfig } from 'wagmi'
import { mainnet, sepolia } from 'wagmi/chains'

export const config = createConfig({
  chains: [mainnet, sepolia],
  transports: {
    [mainnet.id]: http(),
    [sepolia.id]: http(),
  },
})

[wagmi config](https://wagmi.sh/react/getting-started)
``` 

- 2. 在`web`的`pages`目录下的`_app.tsx`文件中，添加如下内容 

```
import { WagmiProvider } from 'wagmi'
import { config } from './config' //上面的config.ts所在路径

function App() {
  return (
    <WagmiProvider config={config}>
      {/** ... */}
    </WagmiProvider>
  )
}
```


