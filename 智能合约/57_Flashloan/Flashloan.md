# Flashloan - 闪电贷


## 闪电贷
闪电贷（Flashloan）是`DeFi`的一种创新，它允许用户在一个交易中借出并迅速归还资金，而无需提供任何抵押。

闪电贷利用了以太坊交易的原子性：一个交易（包括其中的所有操作）要么完全执行，要么完全不执行。如果一个用户尝试使用闪电贷并在同一个交易中没有归还资金，那么整个交易都会失败并被回滚，就像它从未发生过一样。因此，`DeFi`平台不需要担心借款人还不上款，因为还不上的话就意味着钱没借出去；同时，借款人也不用担心套利不成功，因为套利不成功的话就还不上款，也就意味着借钱没成功。

## 闪电贷实战
我们分别介绍如何在`Uniswap V2`，`Uniswap V3`，和`AAVE V3`的实现闪电贷合约。

### 1. Uniswap V2闪电贷
[Uniswap V2 Pair](https://github.com/Uniswap/v2-core/blob/master/contracts/UniswapV2Pair.sol#L159)合约的`swap()`函数支持闪电贷。与闪电贷业务相关的代码如下：

```
function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
    // 其他逻辑...

    // 乐观的发送代币到to地址
    if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out);
    if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out);

    // 调用to地址的回调函数uniswapV2Call
    if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);

    // 其他逻辑...

    // 通过k=x*y公式，检查闪电贷是否归还成功
    require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
}
```

