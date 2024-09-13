# ERC20

### 什么是 ERC20

ERC20 是 Ethereum 网络上最出名且应用最广的代币标准之一。它提供了一个统一的接口标准，用于创建可互换代币，这些代币可以用来代表任何事物，从货币到积分等。

该标准定义了一组 API（应用程序编程接口），涉及到代币在智能合约中的转移方式，如何获取数据（比如各账户的代币余额），以及如何接收、记录和使用这些代币。

### ERC20 核心方法和事件

标准的ERC20合约包含如下几种：

- 3个查询
    - `balanceOf`: 查询指定地址的token数量
    - `allowance`: 查询指定地址对另一个地址的剩余授权额度
    - `totalSupply`: 查询当前合约的Token总量

- 2个交易
    - `transfer`: 从当前调用者地址发送指定数量的Token到指定地址
        - 由于是写入方法因此会抛出一个`Transfer`事件
    - `transferFrom`: 当向另外一个合约地址存款时，对方合约必须调用transferFrom 才可以把Token拿到自己的合约中

- 2个事件
    - `Transfer`
    - `Approval`
      
- 1个授权
    - `approval`: 授权指定地址可以操作调用者的最大Token数量    


### 代码示例


```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract BaseERC20 {
    string public name; 
    string public symbol; 
    uint8 public decimals; 

    uint256 public totalSupply; 

    mapping (address => uint256) balances; 

    mapping (address => mapping (address => uint256)) allowances; 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        name = "MyToken"; 
        symbol = "MTK"; 
        decimals = 18; 
        totalSupply = 100000000 * 10 ** uint256(decimals);

        balances[msg.sender] = totalSupply;  
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];    
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");

        balances[msg.sender] -= _value;    
        balances[_to] += _value;   

        emit Transfer(msg.sender, _to, _value);  
        return true;   
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value, "ERC20: transfer amount exceeds balance");
        require(allowances[_from][msg.sender] >= _value,"ERC20: transfer amount exceeds allowance");

        balances[_from] -= _value; 
        balances[_to] += _value; 

        allowances[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value); 
        return true; 
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] = _value; 
        emit Approval(msg.sender, _spender, _value); 
        return true; 
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
}
```

### 使用 OpenZeppelin 创建 ERC20 代币

[OpenZeppelin](https://docs.openzeppelin.com/contracts/5.x/)是一个开源的区块链开发框架，它提供了安全的合约模板来简化开发过程。

示例：

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 导入 OpenZeppelin 提供的 ERC20 标准合约
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 创建一个新的合约，继承自 OpenZeppelin 的 ERC20 合约
contract MyToken is ERC20 {
    // 构造函数将初始化 ERC20 供应量和代币名称
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        // 通过 _mint 函数铸造初始供应量的代币到部署合约的地址
        _mint(msg.sender, initialSupply);
    }
}
```

