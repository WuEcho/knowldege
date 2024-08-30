应用
###1.ERC20
IERC20是ERC20代币标准的接口合约，规定了ERC20代币需要实现的函数和事件。

**事件**
IERC20定义了2个事件：Transfer事件和Approval事件，分别在转账和授权时被释放
 
    
```
 /**
     * @dev 释放条件：当 `value` 单位的货币从账户 (`from`) 转账到另一账户 (`to`)时.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);
    /**
     * @dev 释放条件：当 `value` 单位的货币从账户 (`owner`) 授权给另一账户 (`spender`)时.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
```
    
**函数**
IERC20定义了6个函数，提供了转移代币的基本功能，并允许代币获得批准，以便其他链上第三方使用。

- totalSupply()返回代币总供给
- balanceOf()返回账户余额
- transfer()转账
- allowance()返回授权额度
- approve()授权
- transferFrom()授权转账

###2.erc721
**IERC721事件**
IERC721包含3个事件，其中Transfer和Approval事件在ERC20中也有。

- Transfer事件：在转账时被释放，记录代币的发出地址from，接收地址to和tokenid。
- Approval事件：在授权时释放，记录授权地址owner，被授权地址approved和tokenid`。
- ApprovalForAll事件：在批量授权时释放，记录批量授权的发出地址owner，被授权地址operator和授权与否的approved。


**IERC721函数**

- balanceOf：返回某地址的NFT持有量balance。
- ownerOf：返回某tokenId的主人owner。
- transferFrom：普通转账，参数为转出地址from，接收地址to和tokenId。
- safeTransferFrom：安全转账（如果接收方是合约地址，会要求实现ERC721Receiver接口）。参数为转出地址from，接收地址to和tokenId。
- approve：授权另一个地址使用你的NFT。参数为被授权地址approve和tokenId。
- getApproved：查询tokenId被批准给了哪个地址。
- setApprovalForAll：将自己持有的该系列NFT批量授权给某个地址operator。
- isApprovedForAll：查询某地址的NFT是否批量授权给了另一个operator地址。
- safeTransferFrom：安全转账的重载函数，参数里面包含了data。

###3.erc1155
下面是ERC1155的元数据接口合约IERC1155MetadataURI：

```
/**
 * @dev ERC1155的可选接口，加入了uri()函数查询元数据
 */
interface IERC1155MetadataURI is IERC1155 {
    /**
     * @dev 返回第`id`种类代币的URI
     */
    function uri(uint256 id) external view returns (string memory);
```

**IERC1155事件**

- TransferSingle事件：单类代币转账事件，在单币种转账时释放。
- TransferBatch事件：批量代币转账事件，在多币种转账时释放。
- ApprovalForAll事件：批量授权事件，在批量授权时释放。
- URI事件：元数据地址变更事件，在uri变化时释放。

**IERC1155函数**

- balanceOf()：单币种余额查询，返回account拥有的id种类的代币的持仓量。
- balanceOfBatch()：多币种余额查询，查询的地址accounts数组和代币种类ids数组的长度要相等。
- setApprovalForAll()：批量授权，将调用者的代币授权给operator地址。。
- isApprovedForAll()：查询批量授权信息，如果授权地址operator被account授权，则返回true。
- safeTransferFrom()：安全单币转账，将amount单位id种类的代币从from地址转账给to地址。如果to地址是合约，则会验证是否实现了onERC1155Received()接收函数。
- safeBatchTransferFrom()：安全多币转账，与单币转账类似，只不过转账数量amounts和代币种类ids变为数组，且长度相等。如果to地址是合约，则会验证是否实现了onERC1155BatchReceived()接收函数。


###发送ETH
**transfer**

- 用法是transfer(发送ETH数额)。
- transfer()的gas限制是2300，足够用于转账，但对方合约的fallback()或receive()函数不能实现太复杂的逻辑。
- transfer()如果转账失败，会自动revert（回滚交易）。、

**send**

- 用法是send(发送ETH数额)。
- send()的gas限制是2300，足够用于转账，但对方合约的fallback()或receive()函数不能实现太复杂的逻辑。
- send()如果转账失败，不会revert。
- send()的返回值是bool，代表着转账成功或失败，需要额外代码处理一下。

**call**

- 用法是call{value: 发送ETH数额}("")。
- call()没有gas限制，可以支持对方合约fallback()或receive()函数实现复杂逻辑。
- call()如果转账失败，不会revert。
- call()的返回值是(bool, data)，其中bool代表着转账成功或失败，需要额外代码处理一下。



1.对智能合约可以加锁进行并发。
2.智能合约深层次相关，递归相关性阐述。
3.交易不仅要from-to，to-from

###ERC 20 代币合约 

要想遵循erc20代币合约需要按照下面的方法来定义的。

1.name - 返回string类型的ERC20代币的名字

```js
function name() constant returns(string name)
```

2.symbol - 返回string类型ERC20代币的符号，简称

```js
function symbol() constant returns(string symbol)
```

3.decimals - 支持几位小数点、如果设置为3.也就是支持0.001

```js
function decimals() constan returns(uint8 decimals)
```

4.totalSupply - 发行代币的总量，可以通过这个函数获取

```js
function totalSupply() constant returns(uint256 totalSupply)
```


5.balanceOf - 输入地址，可以获取该地址代币余额

```js
function balanceOf(address _owner) constant returns(uint256 balance)
```

6.transfer - 调用transfer函数将自己的token转账给_to地址，_value为转账个数

```js
function transfer(address _to,uint256 _value) returns(bool success)
```

7.approve - 批准_spender账户从自己的账户转移_value个token.可以多次转移.

```js
function approve(address _spender,uint256 _value) returns(bool success)
```

8.transferFrom - 与approve搭配使用，approve批注之后，调用transferFrom函数来转移token

```js
function transferFrom(address _from,address _to,uint256 _value) returns(bool success)
```

9.allowance - 返回_spender还能提取token的个数

```js
function allowance(address _owner,address _spender) constant returns(uint256 remaining)
```

Events

1.Transfer - 当成功转移token时,一定要触发Transfer事件

indexed修饰事件时：将参数作为topic存储

```js
event Transfer(address indexed _from,address indexed _to,uint256 _value)
```

2.Approval - 当调用approval函数成功时，一定要触发Approval事件

```js
event Approval(address indexed _owner,address indexed _spender,uint256 _value)
```


###ERC20标准
合约中实现这些标准接口函数

```js
contract ERC20 {
    function totalSupply() constant returns (uint totalSupply);
    function balanceof(address _owner) constant returns (uint balance);
    function transfer(address _to,uint _value) returns (bool success);
    function transferFrom(address _from,address _to,unit _value) returns (bool success);
    function approve(address _spender,uint _value) returns (bool success);
    function allowance(address _owner,address _spender) constant returns (uint remaining);
    
    event Trasnfer(address indexed _from,address indexed _to,uint _value);
    event Approveal(address indexed _owner,address indexed _spender,uint _value);
    
    string public constant name = "Token Name";
    string public constant symblo = "SYM";
    unit8 public constant decimals = 10; //大部分都是10
}

```



代币实例

```js
pragma solidity ^0.4.8;
contract SafeMath{
     //public < internal > private
     //internal修饰的函数只能在合约的内部或子合约中使用
    function safeMul(uint256 a,uint256 b) internal pure  returns(uint256){
        uint256 c = a * b;
        //assert 断言保证函数参数返回值是true,否则抛异常
        assert(a != 0 || c / a == b);
        return c;
    }
    
    function safeDiv(uint256 a, uint256 b) internal pure returns(uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return c;
    }
    
    function safeSub(uint256 a, uint256 b) internal pure returns(uint256){
        assert(a >= b);
        assert(b >= 0);
        return a - b;
    }
    
    function safeAdd(uint256 a,uint256 b) internal pure returns(uint256){
        uint256 c = a + b;
        assert(c >=a && c >=b);
        return c;
    }  
}

contract HBC is SafeMath{
    
    string  public name;
    string  public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    
    address public owner;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public freezeOf;
    //授权   授权人              被授权人    授权金额
    mapping(address => mapping(address => uint256)) public allowonce;
    
    event Transfer(address indexed from,address indexed to,uint256 value);
    
    event Burn(address indexed from,uint256 value);
    
    event Freeze(address indexed from, uint256 value);
    
    event Unfreeze(address indexed from,uint256 value);
    
    //构造函数 
    constructor( 
       uint256 _initialSupply, //发行总量
       string memory _tokenName,//token的名字
       uint8 _decimalUnits,//最小分割 
       string memory _tokenSymbol
    ) public {
        decimals = _decimalUnits;
        balanceOf[msg.sender] = _initialSupply * 10 ** 18;
        totalSupply = _initialSupply * 10 ** 18;
        name = _tokenName;
        symbol = _tokenSymbol;
        owner = msg.sender;
    }
    
    //某个人花自己的币
     function transfer(address _to,uint256 _value) public {
        require(_to !=address(0x0));
        require(_value > 0);
        require(balanceOf[msg.sender] > _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender],_value);
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
        emit Transfer(msg.sender,_to,_value);
    }
    
     //授权
     function approve(address _spender, uint256 _value) public returns(bool succ){
       require(_value > 0);
       allowonce[msg.sender][_spender] = _value;
       return true;
    }
    
    function transferFrom(address _from,address _to, uint256 _value) public returns(bool succ){
        require(_to != address(0x00));
        require(_value > 0);
        require(balanceOf[_from] > _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        require(allowonce[_from][msg.sender] > _value);
        
        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from],_value);
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
        allowonce[_from][msg.sender] = SafeMath.safeSub(allowonce[_from][msg.sender],_value);
        emit Transfer(_from,_to,_value);
        return true;
    }
    
     
     function burn(uint256 _value)  public returns(bool succ){
        require(balanceOf[msg.sender] > _value);
        require(_value > 0);
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender],_value);
        totalSupply = SafeMath.safeSub(balanceOf[msg.sender],_value);
       //支持并推荐使用emit EventName()来明确地调用事件。为了让事件较常规函数调用更突出，应该是用emit EventName()而不是EventName()来调用事件。
        emit Burn(msg.sender,_value);
        return true;
    }
    
    function freeze(uint256 _value) public returns(bool succ){
        require(balanceOf[msg.sender] > _value);
        require(_value > 0);
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender],_value);
        freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender],_value);
        emit Freeze(msg.sender,_value);
        return true;
    }

    function unfreeze(uint256 _value) public returns(bool succ){
        require(freezeOf[msg.sender] > _value);
        require(_value > 0);
        freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender],_value);
        balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender],_value);
        emit Unfreeze(msg.sender,_value);
        return true;
    }
    
    function() public payable{
        
    }
    
    function withdrawEther(uint256 _value) public {
        require(msg.sender == owner);
        owner.transfer(_value);
    }
    
}
```

