# UpGrade - 可升级合约
 
这一讲，我们将介绍可升级合约（`Upgradeable Contract`）。示例用的合约由`OpenZeppelin`中的合约简化而来，可能有安全问题，不要用于生产环境。

## 可升级合约
你理解了代理合约，就很容易理解可升级合约。它就是一个可以更改逻辑合约的代理合约。
![](https://github.com/WuEcho/knowldege/blob/main/%E6%99%BA%E8%83%BD%E5%90%88%E7%BA%A6/47_Upgrade/image/updrade.png)

## 简单实现

下面我们实现一个简单的可升级合约，它包含`3`个合约：代理合约，旧的逻辑合约，和新的逻辑合约。

### 代理合约
这个代理合约比[第46节](https://github.com/WuEcho/knowldege/tree/main/%E6%99%BA%E8%83%BD%E5%90%88%E7%BA%A6/46_ProxyContract)中的简单。我们没有在它的`fallback()`函数中使用内联汇编，而仅仅用了`implementation.delegatecall(msg.data)`;。因此，回调函数没有返回值，

它包含`3`个变量：

- `implementation`：逻辑合约地址。
- `admin`：`admin`地址。
- `words`：字符串，可以通过逻辑合约的函数改变。
它包含`3`个函数：

- `构造函数`：初始化`admin`和逻辑合约地址。
- `fallback()`：回调函数，将调用委托给逻辑合约。
- `upgrade()`：升级函数，改变逻辑合约地址，只能由`admin`调用。


```
// SPDX-License-Identifier: MIT
// wtf.academy
pragma solidity ^0.8.21;

// 简单的可升级合约，管理员可以通过升级函数更改逻辑合约地址，从而改变合约的逻辑。
// 教学演示用，不要用在生产环境
contract SimpleUpgrade {
    address public implementation; // 逻辑合约地址
    address public admin; // admin地址
    string public words; // 字符串，可以通过逻辑合约的函数改变

    // 构造函数，初始化admin和逻辑合约地址
    constructor(address _implementation){
        admin = msg.sender;
        implementation = _implementation;
    }

    // fallback函数，将调用委托给逻辑合约
    fallback() external payable {
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    // 升级函数，改变逻辑合约地址，只能由admin调用
    function upgrade(address newImplementation) external {
        require(msg.sender == admin);
        implementation = newImplementation;
    }
}
```

### 旧逻辑合约
这个逻辑合约包含`3`个状态变量，与保持代理合约一致，防止插槽冲突。它只有一个函数`foo()`，将代理合约中的`words`的值改为"`old`"。

```
// 逻辑合约1
contract Logic1 {
    // 状态变量和proxy合约一致，防止插槽冲突
    address public implementation; 
    address public admin; 
    string public words; // 字符串，可以通过逻辑合约的函数改变

    // 改变proxy中状态变量，选择器： 0xc2985578
    function foo() public{
        words = "old";
    }
}
```

### 新逻辑合约
这个逻辑合约包含`3`个状态变量，与保持代理合约一致，防止插槽冲突。它只有一个函数`foo()`，将代理合约中的`words`的值改为"`new`"。

```
// 逻辑合约2
contract Logic2 {
    // 状态变量和proxy合约一致，防止插槽冲突
    address public implementation; 
    address public admin; 
    string public words; // 字符串，可以通过逻辑合约的函数改变

    // 改变proxy中状态变量，选择器：0xc2985578
    function foo() public{
        words = "new";
    }
}
```


