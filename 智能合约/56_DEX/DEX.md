# DEX - 去中心化交易所

我们将介绍恒定乘积自动做市商（Constant Product Automated Market Maker, CPAMM），它是去中心化交易所的核心机制，被`Uniswap`，`PancakeSwap`等一系列DEX采用。教学合约由`Uniswap-v2`合约简化而来，包括了`CPAMM`最核心的功能。

## 自动做市商

自动做市商（Automated Market Maker，简称 AMM）是一种算法，或者说是一种在区块链上运行的智能合约，它允许数字资产之间的去中心化交易。AMM 的引入开创了一种全新的交易方式，无需传统的买家和卖家进行订单匹配，而是通过一种预设的数学公式（比如，常数乘积公式）创建一个流动性池，使得用户可以随时进行交易。

