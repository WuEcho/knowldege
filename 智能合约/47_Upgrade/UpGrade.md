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


## 升级会产生的问题

### 1. 代理和逻辑合约的存储布局不⼀致发⽣⽆法预期的错误
示例如下：
Counter.sol

```
pragma solidity ^0.8.0;
contract Counter {
 uint private counter;
 
 function add(uint256 i) public {
    counter += 1;
 }
 function get() public view returns(uint) {
    return counter;
 }
}
```
CounterProxy.sol

```
pragma solidity ^0.8.0;
contract CounterProxy {
 address impl; /**对比Counter.sol 同样位置不再是counter
 **/
 uint private counter;
 
 function add(uint256 i) public {
    bytes memory callData = abi.encodeWithSignature("add(uint256)", n);
    (bool ok,) = address(impl).delegatecall(callData);
    if(!ok) revert("Delegate call failed");
 }
 
 /**
 这里 原本是想读取`counter`的值，但是因为存储槽位置发生了变化
 从原来想读取的`counter`，变成了读取`impl`
 **/
 function get() public view returns(uint) {
    bytes memory callData = abi.encodeWithSignature("get()");
    (bool ok, bytes memory retVal) = address(impl).delegatecall(callData); 
     if(!ok) revert("Delegate call failed");
    return abi.decode(retVal, (uint256));
 }
}
```

解决办法：1.通过读取固定槽位的值来进行查询

```
function read(bytes32 slot) external view returns(bytes32 data) {
    assembly {
        data := sload(slot) //load from storage
    }
}

function write(bytes32 sloat,uint256 value) extarnal {
    assembly {
        sstore(slot,value) 
    }
}
```
### 2.如何新的合约增加了新的变量

请不要再原有代码的基础上，从头插入，而是向后面添加或者对需要升级的合约地址位置实现**地址槽位**`bytes32(uint(keccak256("eip1967.proxy.implementation"))-1)`  - EIP 1926

示例：

```
/**
0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc是通过bytes32(uint(keccak256("eip1967.proxy.implementation"))-1)计算得出的

**/
bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

function setImplementation(address _logic) internal {
    assembly {
        sstore(IMPLEMENTATION_SLOT,_logic)
    }
}
``` 


### 3.如果想在增加新的方法怎么办

透明代理或者uupd


