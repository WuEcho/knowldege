# CorssChainBridge 跨链桥

这一节，我们介绍跨链桥，能将资产从一条区块链转移到另一条区块链的基础设施，并实现一个简单的跨链桥。

## 1. 什么是跨链桥
跨链桥是一种区块链协议，它允许在两个或多个区块链之间移动数字资产和信息。例如，一个在以太坊主网上运行的`ERC20`代币，可以通过跨链桥转移到其他兼容以太坊的侧链或独立链。

同时，跨链桥不是区块链原生支持的，跨链操作需要可信第三方来执行，这也带来了风险。近两年，针对跨链桥的攻击已造成超过20亿美元的用户资产损失。

## 2. 跨链桥的种类
跨链桥主要有以下三种类型：

- `Burn/Mint`：在源链上销毁（`burn`）代币，然后在目标链上创建（`mint`）同等数量的代币。此方法好处是代币的总供应量保持不变，但是需要跨链桥拥有代币的铸造权限，适合项目方搭建自己的跨链桥。
- `Stake/Mint`：在源链上锁定（`stake`）代币，然后在目标链上创建（`mint`）同等数量的代币（凭证）。源链上的代币被锁定，当代币从目标链移回源链时再解锁。这是一般跨链桥使用的方案，不需要任何权限，但是风险也较大，当源链的资产被黑客攻击时，目标链上的凭证将变为空气。
- `Stake/Unstake`：在源链上锁定（`stake`）代币，然后在目标链上释放（`unstake`）同等数量的代币，在目标链上的代币可以随时兑换回源链的代币。这个方法需要跨链桥在两条链都有锁定的代币，门槛较高，一般需要激励用户在跨链桥锁仓。

## 3. 搭建一个简单的跨链桥(仅是个简单的示例)

为了更好理解这个跨链桥，我们将搭建一个简单的跨链桥，并实现`Goerli`测试网和`Sepolia`测试网之间的`ERC20`代币转移。我们使用的是`burn`/`mint`方式，源链上的代币将被销毁，并在目标链上创建。这个跨链桥由一个智能合约（部署在两条链上）和一个`Ethers.js`脚本组成。

### 3.1 跨链代币合约
首先，我们需要在`Goerli`和`Sepolia`测试网上部署一个`ERC20`代币合约，`CrossChainToken`。这个合约中定义了代币的名字、符号和总供应量，还有一个用于跨链转移的`bridge()`函数。

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CrossChainToken is ERC20, Ownable {
    
    // Bridge event
    event Bridge(address indexed user, uint256 amount);
    // Mint event
    event Mint(address indexed to, uint256 amount);

    /**
     * @param name Token Name
     * @param symbol Token Symbol
     * @param totalSupply Token Supply
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) payable ERC20(name, symbol) Ownable(msg.sender) {
        _mint(msg.sender, totalSupply);
    }

    /**
     * Bridge function
     * @param amount: burn amount of token on the current chain and mint on the other chain
     */
    function bridge(uint256 amount) public {
        _burn(msg.sender, amount);
        emit Bridge(msg.sender, amount);
    }

    /**
     * Mint function
     */
    function mint(address to, uint amount) external onlyOwner {
        _mint(to, amount);
        emit  Mint(to, amount);
    }
}
```

这个合约有三个主要的函数：

- `constructor()`: 构造函数，在部署合约时会被调用一次，用于初始化代币的名字、符号和总供应量。

- `bridge()`: 用户调用此函数进行跨链转移，它会销毁用户指定数量的代币，并释放`Bridge`事件。

- `mint()`: 只有合约的所有者才能调用此函数，用于处理跨链事件，并释放Mint事件。当用户在另一条链调用`bridge()`函数销毁代币，脚本会监听Bridge事件，并给用户在目标链铸造代币。


