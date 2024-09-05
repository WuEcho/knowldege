# solidity

## 总览solidity数据类型：
1.值类型(整型，布尔，地址，枚举，函数)
 
2.引用类型(solidity没有指针，对于复杂结构是使用关键字**storage**修饰,数组，字符串，结构体)

 - 引⽤类型是否过大（>32个字节），拷⻉开销很⼤，可使⽤“引⽤”⽅式，指向同⼀个变量。
 - 不同的位置，不同的gas费⽤，需要有⼀个属性来标识数据的存储位置:
    - memory（内存）: ⽣命周期只存在于函数调⽤期间
    - storage（存储）: 状态变量保存的位置，gas开销最⼤
    - calldata（调⽤数据）: ⽤于函数参数不可变存储区域


合约结构：
1.SPDX版权声明

//SPDX-License-Identifier: MIT  版权信息，具体其他更详细的值请参考[https://spdx.org/licenses/](https://spdx.org/licenses/)

2.pargam solidity 版本限制
    
```
pargam solidity ^0.8.1;
pargam solidity >=0.8.1 <0.9.0; //等价于^0.8.1
pargam solidity 0.8.1; //指定版本
pargam solidity >=0.7.1 <0.9.0; //跨版本
```    

3.contract 关键字

    - 变量
    - 函数
    - this关键字
    - 合约地址、合约创建者地址,合约调用者地址
    - 合约属性： type关键字
        - name
        - creationCode
        - runtimeCode 
示例：
    
```
//SPDX-License-Identifier: MIT   
pragma solidity ^0.8.1;

contract HelloWorld {

        string public name = "hello world";
**
}

contract Demo {
    
    function Name() public pure returns(string memory){
        return type(HelloWorld).name;
    }

    function creationCode() public pure returns(bytes memory){
        return type(HelloWorld).creationCode;
    }


    function runtimeCode() public pure returns(bytes memory){
        return type(HelloWorld).runtimeCode;
    }
} 
```         

4.import 导入声明

示例：

```
// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.1;

//1.直接导入
import "../demo2.sol"; //本地全局导入 会造成文件污染

//2.遇到冲突时
//遇到全局冲突的时候 为了避免文件被污染 可以使用如下方法
import "../demo2.sol" as aaa;
import * as aaa from "../demo2.sol";

//3.按需导入
import {symbol1 as aliasName, symbol} from "filename";

//import "https://github.com/xxxxx/;" // 导入网络文件
//npm install @openzeppelin/contracts
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol"

contract Demo3 {

    function fun1() public pure returns(string memory){
        return type(HelloWorld).name;
    }

    function fun2() public pure returns(bytes memory){
        return type(HelloWorld).creationCode;
    }

    function fun3() public pure returns(bytes memory){
        return type(HelloWorld).runtimeCode;
    }
}
```

5.interface 接口声明


```
// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.1;

//0x358AA13c52544ECCEF6B0ADD0f801012ADAD5eE3
contract Cat {

    function eat() public pure returns(string memory){
        return "cat eat";
    }
}

//0x9D7f74d0C41E726EC95884E0e97Fa6129e3b5E99
contract Dog {

    function eat() public pure returns(string memory){
        return "dog eat";
    }

}


interface AnimalEat {
    function eat() external returns (string memory);
}

//0xDA0bab807633f07f013f94DD0E6A4F96F8742B53
contract Animal {
    
    function test(address _addr) external returns (string memory){
        AnimalEat general = AnimalEat(_addr);
        return general.eat();
    }

}
```

6.library 库合约
    
 
```
library Set {
    struct Data { mapping(uint => bool) flags; }
    function test() external pure returns(uint){
        return 111;
    }
}


//0xDA0bab807633f07f013f94DD0E6A4F96F8742B53
contract Animal {
    
    function test(address _addr) external returns (string memory){
        AnimalEat general = AnimalEat(_addr);
        return general.eat();
    }

    function test2() external pure returns (uint){
        return Set.test();
    }

}
```   
也可以借助`using 库合约函数 for 类型`，这种用法，让for后面的这种类型都拥有库的方法。


## 1.值类型介绍
 
### 1.1 状态变量
定义在合约之内，但在函数之外的变量，这些值会被上传到区块链上保存起来

```
string public Message = "hello world!";

```

### 1.2 布尔 

```
bool f = false;
```

其中`&&`逻辑与，`||`逻辑或为短路运算符，对于`||`来说第一个为true则第二个将不再执行，对于`&&`来说第一个为false则第二个不再执行。可以节约部分gas支出

### 1.3 整型

- int
- uint
- 以8位为区间的int8，int16等，int默认为int256,uint默认为uint256
-  支持运算符
      - 比较运算：<= ,>=,==,!=,<,>
      - 位运算： &，|，^(异或)，~（位取反）
      - 算术运算： +，-，-(负),*，/, %(取余数), **（幂）
      - 移位： << (左移位), >>(右移位)

- 属性：
    - `type(T).min`: 获取整型 T 的最小值
    - `type(T).max`: ------ T 的最大值
    - 在使⽤整型时，要特别注意整型的⼤⼩及所能容纳的最⼤值和最⼩值,如uint8的最⼤值为0xff（255），最⼩值是0
  
 1. 整数字面常量中用`_`增加可读性 
     
```
 uint256 public x = 233_311_1;
```   
 
 2. 字面常量支持任意精度   
 
 例如：
```
    uint8 public b = 0.5 * 8;
```
 
3. 除法截断(引入变量以后)
  除法总是会截断的（仅被编译为 EVM 中的 DIV 操作码）， 但如果操作数都是 字面常数（literals） （或者字面常数表达式），则不会截断。

```
    uint256 a = 1;
    uint256 b = 4;
    uint256 c = (1/4)*4;  //1
    uint256 d = (a/b)*b;  //0
```
除以零或者模零运算都会引发运行时异常。

4. 优先使用较小类型计算

5. 移位运算的结果
   取决于运算符左边的类型。表达式 x << y 与` x * 2**y` 是等价的， x >> y 与 `x / 2**y` 是等价的。这意味对一个负数进行移位会导致其符号消失。 按负数位移动会引发运行时异常。


在 Solidity 0.8版本之前， 如果整数运算结果不在取值范围内，则会被溢出截断。
从 0.8.0 开始，算术运算有两个计算模式：一个是 unchecked（不检查）模式，一个是”checked” （检查）模式。

默认情况下，算术运算在 “checked” 模式下，即都会进行溢出检查，如果结果落在取值范围之外，调用会通过 失败异常 回退。 你也可以通过 unchecked { ... } 切换到 “unchecked”模式，更多可参考文档 [unchecked](https://learnblockchain.cn/docs/solidity/control-structures.html#unchecked) 。

#### 1.3.1 定长浮点型
可以声明定长浮点型的变量，但是不能给他们赋值或赋值给其他变量，可以通过自定义值类型进行模拟；

`fixed / ufixed`：表示各种大小的有符号和无符号的定长浮点型。 在关键字 ufixedMxN 和 fixedMxN 中，M 表示该类型占用的位数，N 表示可用的小数位数。 M 必须能整除 8，即 8 到 256 位。 N 则可以是从 0 到 80 之间的任意数。 ufixed 和 fixed 分别是 ufixed128x19 和 fixed128x19 的别名。

    
    
#### 1.3.2 定长字节数组
定义方式`bytesN`其中n可取1~32中的任意整数,`byte` 是 `bytes1` 的别名。

- 属性 1.长度  2.索引

**ps :**
可以将 `byte[]` 当作字节数组使用，但这种方式非常浪费存储空间，准确来说，是在传入调用时，每个元素会浪费 31 字节。 更好地做法是使用 bytes。

#### 1.3.3 注释

单行注释：`//`
代码块注释：`/****/`
NatSpec描述注释：`///`

对于NatSpec的简单示例：

```
pragma solidity ^0.8;

///@title: 一个标题
///@author: 作者信息
///@notice: 告知用户这个合约最终是用来干嘛的
///@dev: 提供的方法和说明
///@custom:xxx
contract EchoStorage {
    uint256 num;
   
    ///@notice  存储 _number
    ///@param _number： num 将要修改的值
    ///@dev 将变量 _number 存储到状态变量 num 中
    function SetNum(uint256 _number) public  {
        num = _number;
    }


    //get
    function GetNum() public view returns(uint256) {
        return num;
    }

}

```

如果将上述合约另存为，a.sol 您可以使用以下命令生成文档：

solc --userdoc a.sol
solc --devdoc a.sol
 

### 1.4 函数类型

函数是一个特殊的变量，可以**当做变量赋值**，**当做函数参数传递**，**当做返回值**

函数形式：function + 函数名(参数列表) + 可⻅性 + 状态可变性（可多个）+ 返回值

示例：

```
function get() public view returns(uint){
  return a;
}
```

**函数几个非常重要的修饰符**

| 修饰符 | 说明 |
| --- | --- |
| public | 共有，任何人都可以调用 |
| private | 私有，只有合约内部可用 |
| external | 仅合约外部可用，合约内部需使用this调用 |
| internal | 仅合约内部和继承合约可用 |
| view/constant | 函数会读取但是不会修改constant的状态变量 |
| pure | 函数不使用任何合约的状态变量 |
| payable | 调用函数需要付钱，钱给了智能合约的账户 |
| returns | 返回值函数声明 |

关于view,constant与pure的区别，view,constant仅仅是只读取了变量的值，并未做任何修改，而pure则是既没有读取，也没有修改的情况。

public和external都是函数可见性修饰符，但它们之间有一些区别：

1.可调用方式：使用public修饰的函数可以从合约内部和外部通过消息调用来访问。这意味着该函数既可以被其他合约内的函数调用，也可以被外部账户直接调用。而使用external修饰的函数只能从合约的外部进行调用，无法在合约内部直接调用。

2.Gas消耗：由于public函数可以被合约内部调用，因此在合约内部调用时，gas消耗较低。而external函数只能从合约外部调用，因此在调用时会产生额外的消息调用开销，导致gas消耗较高。

3.访问修饰符：除了可见性不同，public还会自动生成一个对应的getter函数，用于获取公共状态变量的值。而external修饰符仅适用于函数，没有与之对应的自动getter函数。


如果想向合约转账，在合约中添加如下函数即可

```
function() payable {
 //函数里面什么都不用写
}  
```

#### 特殊函数

- 特殊的函数：构造函数 `constructor`
- getter 函数: 所有 public 状态变量创建 getter 函数
- receive 函数: 接收函数,是一种特殊的函数，专门用来表示合约可以接收以太币，函数名只有一个receive关键字，而不需要function关键字，也没有参数和返回值，并且必须是 external可见性和payable修饰，接收函数的声明为：
    
```
receive() external payable { 

}
```

若是使用addr.send()或者addr.transfer()对合约转账，EVM在执行 transfer 和 send 函数只使用固定的 2300 gas， 这个gas 基本上只够receive函数输出一条日志，如果receive函数有更多逻辑，就需要使用底层调用call对合约转账:

```
function safeTransferETH(address to, uint256 value) internal {
    (bool success, ) = to.call{value: value}(new bytes(0));
    require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
}
```

特别要说明的是，以下操作的消耗会大于2300 gas。

  - （1）写存储变量；

  - （2）创建一个合约；

  - （3）执行一个外部函数调用，会花费比较多的gas；

  - （4）发送以太币。

  **ps:合约需要定义 receive 函数才能接收以太币，是在通常我们处理的转账情况。有一些例外，即便合约没有定义 receive 函数，验证者的出块和交易奖励依旧可以打入到该合约。另外在销毁合约时（selfdestruct）被销毁合约的ETH需要转到另一个地址，或后者是合约，也不要求定义 receive 函数。**
   
- fallback 函数: 如果用户对合约进行调用时，合约中没有找到用户要调用的函数,fallback 函数就会被调用，如果是转账时，没有 receive 也有调⽤ fallback。这个函数无参数，也无返回值，也没有function关键字, 必须是external可见性。

声明方式：

```
fallback() external payable { ... }
```
**注意：在solidity 0.6里，回退函数是一个无名函数（没有函数名的函数，如果你看到一些老合约代码出现没有名字的函数，就是回退函数**



### 1.5 地址  address

address/uint/byte32之间的转换
 
 - address 20字节
 - uint160 20字节
 
 byte32 => address : `address(uint160(uint256(hash)))` 其中hash即为byte32的值
 
 - address payable：表示可⽀付地址，可调⽤transfer和send。 
 类型转换：address payable ap = payable(addr); 
 上面的转换方法是在 Solidity 0.6 加入，如果使用的 Solidity 0.5 版本的编译器，则使用 address payable ap = address(uint160(addr))；
 
 若被转换的地址是一个是合约地址时，则合约需要实现了接收（receive）函数或payable回退函数（参考合约如何接收 ETH）。
 如果转换的合约地址上没有接收或 payable 回退函数，可以使用这个魔法payable(address(addr)) ， 即先转为普通地址类型，在转换为address payable类型 。

- 地址属性：
   - `balance`:`<address>.balance  returns(uint256)`;
   - `code`:`<address>.code return(bytes memory)`;
   - `codehash`:`<address>.codehash return(bytes32)`;

- 成员函数
    - <address>.balance(uint256)： 返回地址的余额
    - <address payable>.transfer(uint256 amount)： 向地址发送以太币，失败时抛出异常 （gas：2300）
    - <address payable>.send(uint256 amount) returns (bool): 向地址发送以太币，失败时返回false （gas：2300）
         

可以给address(0)转钱，币的销毁也可以转给address(0)

地址方法：
1.`address():将地址转换到地址类型`；
2.`payable():将普通地址转换为可支付地址`；
3.`transfer(uint256 amount):将余额转到当前地址(如果发生错误会reverts)`;
4.`send(uint256 amount):将余额转到当前地址并返回交易成功状态(有一个bool类型的返回值)`;
5.`call{value:xx，gas:xxx(调整代码gas消耗)}(""):通过call方法将余额转到当前地址(又两个返回值一个bool类型是否成功，另一个bytes类型)`
6.`delegatecall(bytes memory) :可以用于合约升级(顺序必须一致）`

transfer/send/call 三种转账的总结:
    
    - 相同：都可以转钱，接收方都是`to`地址
    - 不同：call不需要`payable`,可调节gas,还可以调用abi的方法,有两个返回值

一个合约在contructor里面进行一些操作时，外部检索不到这个合约里面的code.  

**运算符**

| 描述 | 符号 |
| --- | --- |
| 比较运算符 | <=,<,=,!=,>=,> |

send和transfer都提供了合约向其他账户转账的功能

| 对比项 | send | transfer | 备注 |
| --- | --- | --: | --: |
| 参数 | 转账金额 | 转账金额 | wei单位 |
| 返回值 | true/false | 无(出错抛异常) | transfer更安全 |


#### 1.5.1 以太币

转账的注意点：
1.转账的单位是wei 
2.一个以太坊是10^18wei 用solidity表示为10 ** 18
3.转账的单位有：`wei`,`gwei`,`eth`

```
// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.1;

contract Demo4 {

 function test() public pure returns(bool a ,bool b, bool c){
     a = 1 wei == 1;
    b = 1 gwei == 1e9;
    c = 1 ether == 1e18;

 }
    uint public amount;

    constructor() {
        amount = 1;
    }

    function fnEth() public view returns(uint){
        return amount + 1 ether;
    }
   
    function fnGwei() public view returns(uint){
        return amount + 1 gwei;
    }

    function fnWei() public view returns(uint){
        return amount + 1 wei;
    }

    //单位后缀不能直接用在变量后面，使用以太坊单位来计算输入参数使用如下方法；
    function testVar(uint _amount) public view returns(uint){
        return amount + _amount * 1 ether;
    }

}
```

接受以太币：

    -payable 可以标记函数或地址接受以太坊
              
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract payAble {
    //payable 标记函数 可以接受以太币
    function deposit1() external payable {}

    function deposit2() external {}

    //payable 标记地址 可以接受以太币
    function withdraw() external {
        //to 写在前面    transfer后面的是当前合约的地址
        payable(msg.sender).transfer(address(this).balance);
    }
 
    //查看余额
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}
```
        
    -fallback
        - 语法：
        -  `fallback () external [payable]`

示例入下：
        1.没有参数
    
```
//SPDX-License-Identifier: MIT
pragma solidity^0.8.17;

//0x64eBc7D246699db943917e8be1eB12C28B2aE322
contract StoneCate {
    uint public age;

    event eventFallBack(string);

    //发送到这个合约的任何消息都会调用到此函数(因为该合约没有别的函数)
    //
    fallback() external{
        age++;
        emit eventFallBack("fallback");
    }

}

interface AnimalEat {
    function eat() external returns(string memory);
}

contract Animal {

    //这种调用方法会失败是因为AnimalEat中没有eat()方法，程序会检查有没有这个方法
    function test1(address _addr) external returns(string memory){
        AnimalEat general = AnimalEat(_addr);
        return general.eat();
    }


    //直接调用这种方法偏底层，并且会绕过检查
    function test2(address _addr) external returns(string memory){
        bool success;
        AnimalEat general = AnimalEat(_addr);
        (success,) = address(general).call(abi.encodeWithSignature("eat()"));
        require(success); 
    }

}
```
        
        -  `fallback (bytes calldata input) external [payable] returns (bytes memory output)`


带参数的fallback


```
// SPDX-License-Identifier: MIT
pragma solidity^0.8.17;

contract Demo {

    bytes public inputData1;
    bytes public inputData2;

    fallback(bytes calldata input) external returns(bytes memory output){
            inputData1 = input;
            inputData2 = msg.data;
            return input;
    }

}
```
    
    -receive：只负责接受主币
      - `receive() external payable{}`payable是必须的
    
```

contract Demo1 {

    event Log(string funName,address from,uint value,bytes data);

    receive() external payable{
        //receive中无法使用msg.data
        emit Log("receive",msg.sender,msg.value,"");
    }

    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}
```

 - receive与fallBack同时存在的调用顺序 

 /**
           调用时发送了eth
                |
        判断msg.data 是否为空
           /         \
          是          否
是否存在 receive       fallback()
      /     \ 
    存在     不存在
receive()   fallback()
    
 **/

**注意：** receive与fallBack有什么区别：

区别在于 receive 函数用于接收和处理以太币的转账，而 fallback 函数用于处理未定义函数调用或无效数据的情况。


### 1.6 枚举

  枚举类型是在Solidity中的一种用户自定义类型。枚举可以显示的转换与整数进行转换，但不能进行隐式转换。显示的转换会在运行时检查数值范围，如不匹配会引起异常。
  枚举类型应至少有一名成员，枚举元素默认为uint8，当元素数量足够多时，会自动变为uint16,第一个元素默认为0，超出范围的数值会报错。
  

```go
enum weekend {
  Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
}
```

### 1.7 自定义类型
    
    solidity允许在一个基础类型上创建一个零成本的抽象，类似于一个别名，但有更严格的类型要求。
    
    - 定义： 用户定义类型使用`type UserType is DefaultType`来定义
    - 方法： `UserType.wrap`:从底层类型转换到自定义类型；`UserType.unwrap`:从自定义类型转换成底层类型。

    **注意：**自定义类型没有操作符，也没有成员变量，连最基本的`==`都没有，且基础类型只能是值类型

   示例： 
```
type MyUnint265 is uint256;

library Math {

    function add(MyUnint265 _a,MyUnint265 _b) internal pure returns(MyUnint265){
        return MyUnint265.wrap(MyUnint265.unwrap(_a)+MyUnint265.unwrap(_b));
    }


}

``` 
     

### 1.8 合约类型
Solidity 从 0.6 版本开始，Solidity 增加了一些属性来获取合约类型类似的元信息。
如：对于合约C，可以通过type(C)来获得合约的类型信息，这些信息包含以下内容

- 属性：

    - type(C).name:获取合约名字
    - type(C).creationCode: 获取创建合约字节码
    - type(C).runtimeCode: 获取合约运行时的字节码

创建的例子：

  - 声明一个合约类型：`A public a1;`
  - 声明+赋值：`A public a2 = A(0xxxxxx);`
  - 构造函数：`A public a3 = new A();`

#### 1.8.1 如何区分合约及外部地址
经常需要区分一个地址是合约地址还是外部账号地址，区分的关键是看这个地址有没有与之相关联的代码。EVM提供了一个操作码EXTCODESIZE，用来获取地址相关联的代码大小（长度），如果是外部账号地址，则没有代码返回。因此我们可以使用以下方法判断合约地址及外部账号地址。

```
function isContract(address addr) internal view returns (bool) {
  uint256 size;
  assembly { size := extcodesize(addr) }
  return size > 0;
  }
```
如果是在合约外部判断，则可以使用web3.eth.getCode()（一个Web3的API），或者是对应的JSON-RPC方法——eth_getcode。getCode()用来获取参数地址所对应合约的代码，如果参数是一个外部账号地址，则返回“0x”；如果参数是合约，则返回对应的字节码，下面两行代码分别对应无代码和有代码的输出。

```
>web3.eth.getCode(“0xa5Acc472597C1e1651270da9081Cc5a0b38258E3”) 
“0x”
>web3.eth.getCode(“0xd5677cf67b5aa051bb40496e68ad359eb97cfbf8”) “0x600160008035811a818181146012578301005b601b6001356025565b8060005260206000f25b600060078202905091905056” 
```


## 2.引用类型

数据位置的基础介绍
    
    - storage: 状态变量的保存位置 
    - memory:  数据存储在内存中仅在函数调用期间有效
        mapping和struct不能再函数中动态创建，必须从状态变量中分配
    
    - calldata: 保存函数参数的特殊位置，一个只读的位置，消耗的gas较低，只能用在函数的输入和输出，不允许修改
        
        calldata可以隐式的转换成memory，但是memory却不能隐式的转换成calldata;

### 2.1 数组

- 固定长度数组
uint256[5] public t = [1,2,3,4]

- 变长数组
uint256[] public t = new uint256[](6);

- 数组切片
  如果数组是在calldata 数据位置，可以使用数组切片来获取数组的连续的一个部分。
**用法是：** x[start:end]，start 和 end是uint256类型（或结果为uint256的表达式），x[start:end] 的第一个元素是x[start],最后一个元素是x[end - 1]。start和end都可以是可选的：start默认是0，而end默认是数组长度。如果start比end大或者end比数组长度还大，将会抛出异常。

**内置定长字节数组**
solidity内置了一些数组的数据类型，完全只读。

- bytes1,....,bytes32,允许值以步长1递增;byte默认表示bytes1,byte是类型，bytes是类型，bytes1是内置数组;bytes1只能存储1个字节，即8位内容
- 长度可以读取length
- 长度不可修改
- 可通过下标进行访问
- 内容不可修改

**内置不定长字节数组(bytes)**

- 长度可以读取length
- 可通过下标进行访问
- 内容可以修改
- 对于bytes，如果不使用下标访问，那么可以不用先申请空间，直接赋值或直接push即可
  
  
  byte / byte32 / byte32[] 的区别：
  
  - `byte:`可变字节数组 引用类型
  - `byte32:`固定长度的字节数组 值类型
  - `byte32[]：`由固定长度的字节数组组成的【数组】类型

  方法：
    
    - `bytes.concat():` 多个bytes类型的拼接,返回值是bytes
    - `push:`追加元素
    - `pop:`删除一个元素
    - `delete:`清空某个元素，delete num[x]; delete num :清空数组;
    - `x[start:end]:` 只能用在 calldata 类型的数据上，切出来的结果是数组；`x[:4]`与 `byet4[x]`结果不一样，类型不同。


bytes / byte32 到字符串的转换

1.动态字节数组 => string 


```
    bytes memory tmp = new bytes(2);
    string(tmp)
```

2.固定大小的字节数组 -> [动态大小字节数组] -> string


bytes是否相等的比较：使用`keccak256(x) == keccak(y)`进行比较

  
**自定义数组**
 
 - 类型T，长度K的数组定义为T[K]，例如：uint[5] numbers
 - 内容可变
 - 长度不可变
 - 支持length方法
 

数组具有惰性

```
    function test1(uint256[2] memory _a) public pure returns(uint256[2] memory){
        return _a;
    } 

    function fn1() public pure returns(uint256[2] memory){
       //return test1([1,2]); //这种方式传值就会报错
        return test1([uint256(1),uint256(2)]);
    }
```

pop与delete有什么不同：

`pop` 用于删除数组末尾的元素并返回被删除的元素。
`delete` 用于将映射或数组中的元素重置为默认值。

#### 2.1.1 关注数组 Gas 消耗


```
contract testArray {
    uint [] numbers;
    uint total;

    function addItem(uint x) public {
        numbers.push(x);
      }

    function sum() public {
        uint len = numbers.length;
        for (uint i = 0; i < len; i++) {
            total += numbers[i];
        }
    }
}
```
sum() 函数的gas消耗是随着numbers 元素线性增长的,
**常见的解决方法有：**

  - 将非必要的计算转移到链下进行。
  - 想办法控制数组的长度。
  - 想方法分段计算，让每段的计算工作量 Gas 可控。

  以下是分段计算的一个可能的解决方法:
  
```
contract testArray {
    uint [] numbers;
    uint total;
    uint calced;  // 保存计算的到哪个位置了
    
    function sum(uint end) public {
        if (end > calced) {
            for (uint i = calced; i < end; i++) {
                total += numbers[i];
            }
            calced = end;
        }
    }
}
```
**ps:** 在使用数组时，一定要避免数组遍历出现 gas 问题。

#### 2.1.2 如何高效移除数组元素
如非必要，不建议删除数组的元素。如果一定要删除元素，那么要避免元素的移动， 而是把最后一个元素移动到删除元素那个位置:

```
    // 移除元素推荐操作
    function remove(uint index) public {
        uint len = numbers.length;
        if (index == len - 1) {
            numbers.pop();
        } else {
            numbers[index] = numbers[len - 1];
            numbers.pop();
        }
    }
```

### 2.2 字符串(string)

- 动态尺寸的UTF-8编码字符串，是特殊的可变字节数组
- 引用类型
- 不支持下标索引
- 不支持length,push方法
- 可以修改（需通过bytes转换）

方法：`string.concat`用于字符串拼接

**string 和 bytes**

`string`是一个字符串，可以认为是一个字符数组，`string`不支持数组的 push pop 方法。

`bytes`是动态分配大小字节的数组，类似于byte[]，但是bytes的gas费用更低。`bytes`也可以用来表达字符串，但通常用于原始字节数据。bytes支持数组的 `push`,`pop` 方法

方法：`bytes.concat`用于bytes拼接

### 2.3 数据位置(Data location)
复杂类型，不同于之前**值类型**,占用空间更大，超过256字节，因为拷贝他们占用更多的空间，如**数组(arrays)**和**结构体(struct)**，他们在solodity中有一个额外的属性，即数据的存储位置：**memory**和**storage**。

**-  内存(memory)**

- 数据不是永久存在的，存放在内存中，超过作用域后无法访问，等待被回收。
- 被memory修饰的变量是直接拷贝，即与上述的值类型传递方式相同。

**-  存储(storage)**

- 数据永久保存性
- 被storage修饰的变量是引用传递，相当于只传递地址，新旧两个变量指向同一片内存空间，效率较高，两个变量有关联，修改一个，另外一个同样被修改。
- 只有引用类型的变量才可以显示的声明为**storage**

### 2.4 结构体
使⽤Struct 声明⼀个结构体，定义⼀个新类型

```go
    struct Student {
        
        string name;
        
        uint8 age;  
    }
    
    //st = Student({name:"11",age:10});
    //st = Student("11"10);
    
    //利用元组来返回 
    function getDetail() public view returns(string memory,uint8){
       return (st1.name,st1.age);
    }
    
```

在读取结构体数据的时候，函数内读取并返回尽量使用storage变量接受，这样可以减少数据的拷贝次数节约gas消耗.

删除: `delete Student;`仅仅是重置数据并不是真正的删除；

不能在声明一个结构体的同时将自身结构体作为成员，如以下代码无法通过编译：

```
struct Person {
    address account;
    bool gender;
    uint8 age;
    Person child;  //  错误
}
```
原因是这样的：EVM 会为结构体的成员会分配在一个连续的存储空间，如果结构体包含了自身， EVM 就无法确定存储空间的大小。

但是如果结构体有数组成员是结构体自身或 映射的值类型是结构体自身，是合法的定义（尽管编写程序时强烈不推荐这么做），如以下定义是合法的：


```
    struct Person {
        address account;
        bool gender;
        uint8 age;
        mapping(string=>Person) childs;  // 或  Person[]  manyChilds; 
    }
```
这个是因为变长的数据会单独分配存储槽（而不是连续的方式存储），在结构体中变长的数据只会有一个固定的存储槽来保存数据指向位置。因此当结构体用有一个变长的数据（即使包含自身）也不会影响 EVM 为结构体分配存储空间。

#### 2.4.1 结构体变量声明与赋值
结构体是一个引用类型， 因此我们在声明变量的时候，需要标识变量的存储位置。

- （1）仅声明变量而不赋值，此时会使用默认值创建结构体变量

```
pragma solidity ^0.8.0;
contract testStruct {
  struct Person {
    address account;
    bool gender;
    uint8 age;
  }
  
  // 声明变量而不初始化
  Person person;   // 默认为storage
}
```

- （2）按成员顺序（结构体声明时的顺序）赋值

```
// 只能作为状态变量这样使用
Person person = Person(address(0x0), false, 18) ;
// 在函数内声明
Person memory person = Person(address(0x0), false, 18) ;
```

- （3）具名方式赋值。

```
// 使用具名变量初始化
Person person = Person({account: address(0x0), gender: false, age: 18}) ;

//在函数内声明
Person memory person =  Person({account: address(0x0), gender: false, age: 18}) ;
```

- （4）以更新成员变量的方式给结构体变量赋值

```
    Person person;
    // 在函数内
    function updatePersion() public {
        person.account = msg.sender;
        person.gender = true;
        person.age = 12;
    }
```

### 2.5 字典，映射(mapping)

- 键key的类型允许除映射外的所有类型,值类型无限制
- 无法判断一个mapping中是否包含某个key,因为它认为每个都存在，不存在返回0或false
- 映射可以被视作一个哈希表，在映射表中，不存储键的数据，仅存储它的**keccak256**哈希值，用来查找值时使用
- 映射类型，仅能用来定义状态变量，或者是在内部函数中作为storage类型的引用
- 不支持length
- 作为局部变量使用时不能声明为memory类型，当使用storage是会影响外部的值


```go
 
    mapping(string => string) public name;
   
   //构造函数
   //对象在创建时自动执行完成初始化工作,且仅执行一次 
    constructor() public {
        name["11"] = "lala";
        name["22"] = "haha";
        name["33"] = "loulou";
    }   

```

可迭代映射实现：

```
mapping(string => uint256) public balance;
mapping(string => bool) public balanceInserted;
string[] public balanceKey;
```

也可以使用链表的形式

```
pragma solidity >=0.8.0;

contract IterableMapping {
    // 存储用户的余额
    mapping(address => uint) public balances; 
    
    // 链表中的下一个用户地址
    mapping(address => address) public nextUser; 
    
    // GUARD 作为链表的起点，固定常量地址
    address constant GUARD = address(1);
    
    // 链表的长度
    uint public listSize;

    constructor() {
        nextUser[GUARD] = GUARD; // 初始化链表，GUARD 指向自己，表示空链表
    }
    
    // 插入新用户并设置余额
    function insert(address key, uint value) public {
        require(balances[key] == 0, "Key already exists"); // 不允许插入已存在的地址
        balances[key] = value;
        
        // 插入链表头部
        nextUser[key] = nextUser[GUARD];
        nextUser[GUARD] = key;
        listSize++;
    }
    
    // 更新用户余额
    function update(address key, uint newValue) public {
        require(balances[key] != 0, "Key does not exist"); // 确保地址已存在
        balances[key] = newValue;
    }
    
    // 删除用户
    function remove(address key) public {
        require(balances[key] != 0, "Key does not exist"); // 确保地址已存在

        // 在链表中找到要删除的节点前驱节点
        address prev = findPrevious(key);
        nextUser[prev] = nextUser[key]; // 更新链表结构
        nextUser[key] = address(0); // 清理 nextUser 映射
        balances[key] = 0; // 清理 balances 映射

        listSize--;
    }
    
    // 查找链表中的前驱节点
    function findPrevious(address key) internal view returns (address) {
        address current = GUARD;
        while (nextUser[current] != GUARD) {
            if (nextUser[current] == key) {
                return current;
            }
            current = nextUser[current];
        }
        return address(0); // 如果未找到，返回空地址
    }
    
    // 获取链表中的所有用户地址及其余额
    function getAllUsers() public view returns (address[] memory, uint[] memory) {
        address[] memory addresses = new address[](listSize);
        uint[] memory balancesList = new uint[](listSize);
        address current = nextUser[GUARD];
        uint i = 0;
        
        while (current != GUARD) {
            addresses[i] = current;
            balancesList[i] = balances[current];
            current = nextUser[current];
            i++;
        }
        return (addresses, balancesList);
    }
}

```

## 3.高级语法
### 3.1 msg.sender和msg.value

- msg.Sender
1.部署合约的时候，msg.sender就是部署合约的账户
2.调用setMessage，msg.sender就是调用账户
3.调用getMessage，msg.sender就是调用账户

- msg.value
在合约中，每次准入的value是可以通过msg.value来获取的，有msg.value就必须有payable关键字


### 3.2 公共函数

| 函数 | 含义 |
| --- | --- |
| block.gaslimit | 当前区块的gaslimit |
| block.number | 当前区块号 |
| block.timestamp | 当前区块的时间戳 |
| blockhash(uint blockNumber) | 哈希值(byte32) |
| block.coinbase | 当前矿工地址 |
| block.difficulty | 当前区块难度 |
| msg.data | 完整的调用数据 |
| gasleft() | 当前还剩的gas |
| msg.sender | 当前调用发起人的地址 |
| msg.value | 这个消息所附带的货币量 |
| now | 等同于block.timestamp |
| tx.gasprice | 交易的gas价值 |
| tx.origin | 交易的发送者 |

### 3.3 哈希函数

在solidity中可是使用`keccak256()`函数来对一段数据计算哈希，在使用的过程中，一般会结合`abi.encode()`或`abi.encodePacked()`这两个方法都是对数据进行编码，但是区别在于`abi.encode()`会对传入的参数进行补零操作，而`abi.encodePacked()`不会，但是`abi.encodePacked()`函数是对数据的压缩，容易造成哈希碰撞的问题。示例：

```
abi.encodePacked(”aaa“,"bb") 

abi.encodePacked("aa","abb") 

这两种方式下的结果相同，但是从数据层面并不是一样的数据，为了避免上面的问题可以通过数字隔开数据的方式
```

### 3.4 验证签名

在智能合约中验证签名可以分为四步：1.将消息签名 2.将消息进行哈希 3.再把消息和私钥进行签名(链下完成) 4.恢复签名，其中恢复签名有专门的的函数`ecrecover(hash(message),signature) == signer`

代码示例如下：

```
// SPDX-License-Identifier: MIT
pragma solidity^0.8.17;

contract Sign{

    function verify(address _addr,string memory _message,bytes memory _sign) external pure returns(bool){

        bytes32 messageHash = getMessageHash(_message);

        bytes32 ethSignMessageHash = getEthSignMessageHash(messageHash);

        return  recover(ethSignMessageHash,_sign) == _addr;
    }


    function getMessageHash(string memory _message) public  pure returns(bytes32){
        return  keccak256(abi.encodePacked(_message));
    }

    function getEthSignMessageHash(bytes32 _messageHash) public  pure  returns(bytes32){
        return  keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _messageHash
        ));
    }  

    function recover(bytes32 _ethSignedMessageHash,bytes memory _sign) public pure returns(address)  {
        (bytes32 r,bytes32 s, uint8 v) = split(_sign);
        //恢复地址的函数
        return  ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function split(bytes memory _sign) private  pure returns (bytes32 r,bytes32 s,uint8 v){
        require(_sign.length == 65,"invalid sign length");
        //内联汇编：允许直接在Solidity代码中嵌入原生的机器码指令
        assembly {
            r := mload(add(_sign,32))
            s := mload(add(_sign,64))
            v := byte(0,mload(add(_sign,96)))
        }

    }
}
```


//0x85c6b598ce8fd6b395896061522dbf9368acea9508c101eab40508191c280f0c

操作过程为，先调用getMessageHash，然后打开网页控制端，输入`ethereum.enable()（需要有metamask）`，然后输入`account="0xsssss"`,`hash="getMessageHash的结果"`,然后使用`ethereum.request({method:"personal_sign",params:[account,hash]})`获得一个签名后的结果byte，然后再将getMessageHash的结果传入getEthSignMessageHash,然后将结果分别传入`recover`中。

### 3.5 错误处理
#### 3.5.1 抛出异常
Solidity 有 3 个方法来抛出异常：`require()`、`assert()`、`revert()`。

- 1.**require()**：`require`函数通常用来在执行逻辑前检查输入或合约状态变量是否满足条件，以及验证外部调用的返回值时候满足条件，在条件不满足时抛出异常。

**同样会触发 require 式异常的情况**（这类异常称为Error）

  - 通过消息调用调用某个函数，但该函数没有正确结束（它耗尽了gas，没有匹配函数，或者本身抛出一个异常）。但不包括低级别操作：call、send、delegatecall、staticcall。低级操作不会抛出异常，而通过返回 false 来指示失败。
  - 使用`new`关键字创建合约，但合约创建失败。
  - 调用到了一个不存在的外部函数，即 EVM找不到外部函数的代码。
  - 向一个没法接收以太币的合约`transfer()`，或附加`Ether`调用没有`payable`修饰符的函数。

当`require`式异常发生时，EVM 使用`REVERT`操作码回滚交易，剩余未使用的 Gas 将返回给交易发起者。

- 2.**assert()**：`assert(bool condition))` 函数通常用来检查内部逻辑，assert 总是假定程序满足条件检查（假定condition为true），否则说明程序出现了一个未知的错误，如果正确使用`assert()`函数，Solidity 分析工具（如 STMChecker 工具）可以帮我们分析出智能合约中的错误。

**同样会触发 assert() 式异常的情况**（这类异常称为Panic）

   - 访问数组的索引太大或为负数（例如x[i]其中的i >= x.length或i < 0）。
   - 访问固定长度bytesN的索引太大或为负数。
   - 用零当除数做除法或模运算（例如 5 / 0 或 23 % 0 ）。
   - 移位负数位。
   - 将一个太大或负数值转换为一个枚举类型。
   - 调用未初始化的内部函数类型变量。

在 0.8.0 版本之前，当 assert 式异常发生时，EVM 会触发 `invalid` 操作码，同时会消耗掉所有未使用的Gas。
在 0.8.0 及之后版本，当 assert 式异常发生时，EVM 会使用 `REVERT` 操作码回滚交易，剩余未使用的 Gas 将返回给交易发起者。


- 3.**revert()**：直接调用`revert()`来撤销交易，和`require()`非常类似
  `revert`有两种形式：
   - `revert CustomError(arg1, arg2);`:回退交易，并抛出一个自定义错误（从0.8.4开始新增的语法）。
   - `revert()`/ `revert(string memory reason)`:回退交易，可选择提供一个解释性的字符串。

  推荐使用第一种形式，自定义错误的方式来触发，因为只需要使用4个字节的编码就可以描述错误，比较使用解释性的字符串消耗更少的GAS。

自定义错误可通过如下方法定义：

```
error CustomError();
error CustomError(T arg1, T arg2);
```

- 4.**传统方法：**采用throw和if ... throw 模式(已过时)。如：合约中有一些功能，只能被授权为拥有者的地址才能使用

```js
if (msg.sender != owner) {
  throw;
}
```

等价于如下任意一种形式：
 
```js
if (msg.sender != owner) {
   revert();
}
assert(msg.sender == owner);
require(msg.sender == owner);
```


#### 3.5.2 错误捕获

程序调用外部函数时，可以用 try/catch 来捕获外部调用可能发生的错误。

```
try  externalContract.xxxfunc() {
    //do something  
} catch Error(string memeory data){ //catch error 
    //require 式异常
} catch (bytes memory returnData) {
    //assert 式异常     
}

```

### 3.6 修饰器（modifier）

修饰器(modifier)可以用来轻易的改变一个函数的行为。比如用于在函数执行前检查某种前置条件。修饰器是一种合约属性，可被继承。同时还可以被派生的合约重写(override)。函数修改器一般是带有一个特殊符号 `_; `；修改器所修饰的函数的函数体会被插入到`_;`的位置。

```js
    address public owner;
    uint  public money;
    
    constructor() public{
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(owner == msg.sender);
        
        //—：代表这个修饰器所修饰的函数
        _;
    }
    
    function setValue() public onlyOwner payable{
        money = msg.value;
    }
        
```

#### 3.6.1 修改器可带参数

```
contract testModifty {

    modifier over22(uint age) {
        require (age >= 22, "too small age");
        _;
    }


    function marry(uint age) public over22(age) {
       // do something
    }
}
```
#### 3.6.2 多修改器一起使用
多个修改器可以一起修饰某个函数，此时会根据定义函数修改器的顺序嵌套执行

```
contract modifysample {
    uint a = 10;

    modifier mf1 (uint b) {
        uint c = b;
        _;
        c = a;
        a = 11;
    }

     modifier mf2 () {
        uint c = a;
        _;
    }

    modifier mf3() {
        a = 12;
        return ;
        _;
        a = 13;
    }

    function test1() mf1(a) mf2 mf3 public   {
        a = 1;
    }

    function get_a() public view returns (uint)   {
        return a;
    }
}
```

货币单位：wei,finney,szabo和ether,转换关系： 1 ether = 10 ** 18wei = 1000 finney = 1000000 szabo

时间单位：second,minutes,hours,days,weeks,years，默认是seconds


### 3.7 事件
相当于打印log,但是需要调用端才能看到。

```js
    //定义 需要分号隔开
    event payEvent(
        address name,
        uint money,
        uint256 timeStamp
    );
    
    
    function pay() public payable {
      emit payEvent(msg.sender, msg.value, block.timestamp);     
    }
    
```

#### 3.7.0 事件签名
对事件签名进行`keccak256`运算得到事件签名哈希值。keccak256(Transfer(address,address,uint256))，事件签名往往出现在receipt中的第一个主题

#### 3.7.1 事件索引 indexed
在定义事件时，我们可以给某些事件参数加上 indexed， 例如：

```
event Deposit(address indexed _from, uint _value);  // 定义事件
```
可以看到日志有两个Topics，有索引的参数放在`topics `下，没有索引的参数放在 data 下，以太坊会为日志地址及主题创建Bloom过滤器，以便更快的对数据检索。

#### 3.7.2 获取事件
通常我们有三个方法：

 - 通过交易收据获取事件
    可以直接在Remix 控制台通过输入`web3.eth.getTransactionReceipt(hash)`获取收据
    
 - 使用过滤器获取过去事件
    Web3.js 对应的接口为`getpastlogs`，`Ethers.js`对应的接口为`getLogs`
    
```
web3.eth.getPastLogs({
    address: "0xd9145CCE52D386f254917e481eB44e9943F39138",
    topics: ["0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c"]
})
.then(console.log);
```

 - 使用过滤器获取实时事件
Web3.js 对应的接口`web3.eth.subscribe`，`Ethers.js`在 Provider 使用`on`进行监听。需要注意的是，要订阅需要和节点建立Web Socket 长连接。

     - Web3.js 示例：

```
const web3 = new Web3("ws://localhost:8545");  

var subscription = web3.eth.subscribe('logs', {
    address: '0x123456..',
    topics: ['0x12345...']
}, function(error, result){
    if (!error)
        console.log(result);
});
```

   - Ethers.js 示例：

```
let provider = new ethers.providers.WebSocketProvider('ws://127.0.0.1:8545/')

filter = {
    address: "0x123456",
    topics: [
        '0x12345...' // utils.id("Deposit(address,uint256)")
    ]
}
provider.on(filter, (log, event) => {
    //  
})
```
 
   - JSON-RPC 的包装库
 提供更高层的方法来监听事件，使用 Web3.js ，可以用合约 abi 创建合约兑现来监听 Deposit 事件方法如下：

```
var abi = /* 编译器生成的abi */;
var addr = "0x1234...ab67"; /* 合约地址 */
var contractInstance = new web3.eth.contract(abi, addr);


// 通过传一个回调函数来监听 Deposit
contractInstance.event.Deposit(function(error, result){
    // result会包含除参数之外的一些其他信息
    if (!error)
        console.log(result);
});

```
若要过滤 indexed 字段建立索引，给事件提供一个额外的过滤参数即可：

```
contractInstance.events.Deposit({
    filter: {_from: ["0x.....", "0x..."]}, // 过滤某些地址
    fromBlock: 0
}, function(error, event){
    console.log(event);
})
```

#### 3.7.3 善用事件
1. 如果合约中没有使用该变量，应该考虑用事件存储数据
2. 如果需要完整的交易历史，请使用事件
3. 事件存储数据

#### 3.7.4 主题值的计算
EVM在很多方面基于32字节的字宽，这要求所有日志的主题也必须符合这种固定大小。

- 对于固定大小的类型
（如 uint256, address 等），直接使用其 ABI 编码的结果。比如，地址会被填充到 32 字节。

- 对于动态类型
（如 string 或 bytes），你不能直接将它们标记为 indexed，因为它们是动态的。确实需要在事件中使用这些类型的数据作为筛选条件，通常的做法是在触发事件时，传入这些值的哈希值。

#### 3.7.5 匿名事件
事件也可以被声明为匿名事件。匿名事件的第一个主题不会自动包括事件的签名哈希。这意味着匿名事件的第一个主题可以自定义或使用与非匿名事件完全不同的数据，使得对于某些特定应用，可以有更灵活的索引和匹配方式。
**声明方式：**匿名事件的声明和触发与普通事件类似，只是加上了`anonymous`关键字。
示例：

```
event myEvent(address indexed addr,uint value) anonymous;
```


### 3.8 访问函数(Getter Funtions)
编辑器会自动为所有**public**修饰的变量创建访问函数。

```js
contract Test {
    
    uint public money;
    
    function setValue() public payable {
        money = msg.value;
    }
    
}


contract Test1 {
    function getData()  public returns(uint){
        Test t = new Test();
        return t.money();
    }
}
```

### 3.9 合约
**1.创建合约**
1.new关键字，返回值是一个address,需要显式转化类型后才能使用
2.C c1形式，此时c1是空的，需要赋值地址才能使用

```js
contract C1 {
    function getValue() public pure returns(uint256){
        return 100;
    }
}

contract C2 {
    
    C1 public c1;
    
    function getValue3() public returns(uint256) {
        c1 = new C1();
        return c1.getValue();
    }
    
    function getValue4(address addr) public returns(uint256){
        c1 = C1(addr);
        return c1.getValue();
    }
    
}
```

**2.销毁合约**

selfdestruct：合约自毁

功能：1.销毁合约
     2.把合约的资金强制发送到目标地址
     
**注意：**非必要不建议销毁     

```
// SPDX-License-Identifier: MIT
pragma solidity^0.8.1;

contract killCon {

    uint public aaa = 123;

    constructor() payable{}

    function killSelf() external {
        selfdestruct(payable(msg.sender));
    }


    function getBalance() public view returns(uint){
        return address(this).balance;
    }


    receive() external payable{}

}
```


### 3.10 元组(tuple)
 solidity无法返回自定义的数据结构，所以若想返回一个自定义结构的数据，需要在函数中返回多个值，即元组。元组是一个数据集合，类似于字典但无法修改数据。

```js
    struct Student {
        string name;
        
        uint age;
        
        uint number;
    }
    
    
    Student s1 = Student("lilei",20,1);
    Student s2 = Student({name:"zhanglei",age:20,number:5});
      
    function getValue() public view returns(string memory, uint,uint) {
        return (s1.name,s1.age,s1.number);
    }
```

### 3.11 继承
is表示继承，多继承用“,”分开。

#### 3.11.1 函数重写（overide） 
只有父合约中的虚函数（使用了`virtual` 关键字修饰的函数）可以在派生被重写。

- 1.在子合约中首先要标记子合约是继承于父合约的，即 `contract b is a`，
- 2.在子合约中也要在对应的函数中标记该函数是覆盖掉父合约的函数的，标记为`override`,
- 3.当子合约也被继承了的时候，子合约中的函数同样需要标记哪些函数可以被重写。

继承的子合约只能访问父级合约的内部函数与变量，公开函数与变量。且继承的子合约不能重写

#### 3.11.2 调用父级函数：
可以在重写的函数中显式的用`super`调用父合约的函数
```
pragma solidity ^0.8.17;

contract U {
    event Log(string message);
    function foo() public  virtual {
        emit Log("e.foo");
    }

    function bar() public  virtual {
        emit Log("e.bar");
    }
}

contract F is U {
    //调用父级方法
    function foo() public override {
        emit Log("f.foo");
        U.foo();
    }
    
    function bar() public override{
        emit  Log("f.bar");
        super.foo();
    } 
}
```
#### 3.11.3 继承下构造函数
构造函数的处理与函数重写处理的方式不一样，当派生合约继承父合约时，如果父合约实现了构造函数，在部署派生合约时，父合约的构造函数也会执行。

#### 3.11.4 给对父合约构造函数传参

- 1.在继承父合约的合约名中指定参数

```
contract Base {
    uint public a;
    constructor(uint _a) {
        a = _a;
    }
}

contract Sub is Base(1) {
    uint public b ;
   constructor() {
     b = 2;
   }
}
```

- 2.在派生构造函数中使用修饰符方式调用父合约

```
contract Sub is Base {
   uint public b ;

   constructor() Base(1)  {
        b = 2;
   }
  //或
  //constructor(uint _b) Base(_b / 2)  {
  //     b = _b;
  //}
  
}
```


```// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract X {
    string public text;
   
    constructor(string memory _text){
        text = _text;
    }
}

contract T {
    string public name;

    constructor(string memory _name){
        name = _name;
    }
}

//向构造函数中输入参数 而且是在已知参数的情况下
contract U is X("x"),T("t") {
}

//通过构造函数向父级构造函数传值 调用的顺序是按照继承的顺序
contract V is X,T {
    constructor(string memory _name,string memory _text) X(_text) T(_name) {  
    }
    
    //因为是按照继承顺序赋值，因此在构造函数中顺序错了也没有关系
    constructor(string memory _name,string memory _text) T(_name) X(_text) {
         
    }
}


```
#### 3.11.4 多线继承
多线继承需要遵循一个原则：从基类到派生的关系，从越基础合约到越派生的顺序。当多线继承的函数中需要覆盖继承的函数的之后需要在函数中追加标记`override(x,y)`，代表同时覆盖两个合约的方法。

```js
contract Animal {
    
    uint _weight;
    uint private _height;
    function test1()  public view returns(uint){
        return _weight;
    }
    
    function test2() public view returns(uint){
        return _height;
    }
    
}

contract Sex {
    uint _sex;
    
    function setSex() public {
        _sex = 1;
    }
    
    function getSex() public view returns(uint){
        return _sex;
    }
    
}

contract Dog is Animal,Sex{
    
    function testWight() public view returns(uint){
        return _weight;
    }
    
    
    function testSex() public view returns(uint){
        return _sex;
    }
    
}
```

#### 3.11.5 抽象合约
有一些父合约，我们创建他们，只是为了在合约之间建立清晰的结构关系，而不是真实的部署这些父合约。我们可以在这些不想被部署的合约前加上`abstract`关键字，表示这是一个抽象合约。

```
abstract contract Base {
    uint public a;
}
```
抽象合约由于不需要部署，因此可以声明没有具体实现的纯虚函数，纯虚函数声明用";"结尾，而不是"{ }"，例如：

```
pragma solidity >=0.8.0;

abstract contract Base {
    function get() virtual public;
}
```

### 3.12 接口与合约交互
接口只用来定义方法，而没有实现的方法体。抽象合约则可以有方法的实现，抽象合约可以实现一个或多个接口，以满足接口定义的方法要求。

#### 3.12.1 使用接口

Solidity 用`Interface` 关键字定义接口，所有函数都必须是外部函数（external），不能有状态变量或构造函数。以下是一段示例代码定义了一个名为ICounter 的接口：

```
pragma solidity ^0.8.10;

interface ICounter {
    function increment() external;
}

```

#### 3.12.2 利用接口调用合约

- 1. 依赖接口，而不是依赖实现
 假设我们链上已经部署了一个Counter合约

```
pragma solidity ^0.8.0;

contract Counter is ICounter {
    uint public count;

    function increment() external override {
        count += 1;
    }
}

```

在我们的合约里调用链上Counter合约的increment()方法

```
import "./ICounter.sol";

contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment(); //把合约地址 _counter 类型转化为接口ICounter类型（接口类型与合约类型一样，也是自定义类型），再调用接口内的increment() 方法。
    }
}

```

- 2.基于具体的实现合约

```
import "./Counter.sol";

contract MyContract {
    function incrementCounter(address _counter) external {
        Counter(_counter).increment();
    }
}
```

### 3.13 库（Library）

库（Library）是一组预先编写好功能模块的集合，使用库可提高开发效率。

#### 3.13.1 使用库
库使用关键字`library`来定义

```
pragma solidity ^0.8.19;

library Math {
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}
```

在合约中引入库之后，可以直接调用库内的函数

```
import "./Math.sol";

contract TestMax {
    function max(uint x, uint y) public pure returns (uint) {
        return Math.max(x, y);
    }
}
```
**注意：库是函数的封装，库是无状态的，库内不能声明变量，也不能给库发送Ether。**

#### 3.13.2 内嵌库
如果合约引用的库函数都是内部函数，那么编译器在编译合约的时候，会把库函数的代码嵌入合约里，就像合约自己实现了这些函数，这时的库并不会单独部署，上面的Math库就属于这个情况，它的代码会在`TestMax`合约编译时，加入到`TestMax`合约里。
**注意：内嵌库在合约的字节码层，是没有复用的，内嵌库的字节码会存在于每一个引入该库的合约字节码中。**

#### 3.13.3 链接库
如果库代码内有公共或外部函数，库就可以被单独部署，它在以太坊链上有自己的地址，引用合约在部署合约的时候，需要通过库地址把库“链接”进合约里，合约是通过**委托调用**的方式来调用库函数的。
Solidity 开发框架会帮助我们进行链接，以Hardhat 为例，部署脚本这样写就好：

```
  const ExLib = await hre.ethers.getContractFactory("Math");
  const lib = await ExLib.deploy();
  await lib.deployed();

  await hre.ethers.getContractFactory("TestMax", {
    libraries: {
      Library: lib.address,
    },
  });

```

#### 3.13.4 Using for
使用`using LibA for B`，它表示把所有LibA的库函数关联到类型B。这样就可以在B类型直接调用库的函数。

```
contract testLib {
    using Math for uint;
    
    function callMax(uint x, uint y) public pure returns (uint) {
       return x.max(y);
    }

}
```


### 3.14 ABI
ABI （Application Binary Interfaces）

#### 3.14.1 ABI 接口描述
编译代码以后，会得到两个重要东西（称为artifact）：bytecode（字节码） 和 ABI 接口描述。

#### 3.14.2 ABI 编码
大部分时候，我们不需要了解详细的编码规则，Solidity / web3.js / ethers.js 库都提供了编码函数，例如在 Solidity 中，可通过以下代码获得完整的编码：

```
// 编码函数及参数 
abi.encodeWithSignature("set(uint256)", 10)

// 编码参数
uint a = 10;
abi.encode(a);   // 0x000000000000000000000000000000000000000000000000000000000000000a
```

#### 3.14.3 Solidity 编码函数
Solidity 中有 5 个函数：`abi.encode`, `abi.encodePacked`, `abi.encodeWithSignature`, `abi.encodeWithSelector` 及`abi.encodeCall` 用于编码。
 
 - `abi.encode`：`encode()` 方法按EVM标准规则对参数编码，编码时每个参数按32个字节填充0 再拼在一起
 - `abi.encodePacked`：参数在编码拼接时不会填充0， 而是使用实际占用的空间然后把各参数拼在一起，如果编码结果不是32字节整数倍数时，再末尾依旧会填充0。在使用![EIP712](https://learnblockchain.cn/2019/04/24/token-EIP712) 时，需要对一些数据编码，就需要使用到`encodePacked` 
 - `abi.encodeWithSignature`: 对函数签名及参数进行编码
    示例：
    
    ```
    abi.encodeWithSignature("set(uint256)", 10)
    ```

- `abi.encodeWithSelector`: 它与`abi.encodeWithSignature`功能类似，只不过第一个参数为**4个字节**的**函数选择器**
    示例：

    ```
        abi.encodeWithSelector(0x60fe47b1, 10);
        // 等价于
        abi.encodeWithSelector(bytes4(keccak256("set(uint256)")), 10);
    ```

- `abi.encodeCall`: `encodeCall`可以通过函数指针，来对函数及参数编码，在执行编码时，执行完整的类型检查, 确保类型匹配函数签名。只能用于公开或外部函数，Solidity 0.8.11 引入的功能。
    
  使用场景：
  
  - 合约间调用：
    当你需要通过低级调用（如 call 或 delegatecall）与另一个合约进行交互时，可以使用 abi.encodeCall 对目标函数及其参数进行编码。这种方式比手动拼接函数签名和参数更加安全、方便。

  - 创建执行交易的calldata：
    当你需要通过像多签钱包、代理合约或其他执行者发起交易时，`abi.encodeCall`可以用来生成带有特定函数调用和参数的`calldata`。

  - 非标准合约调用：
    如果目标合约是一个代理合约，或者目标函数具有复杂的函数签名，`abi.encodeCall`能保证你提供的参数与函数签名严格匹配。
    
  示例：
  
```
contract Example {
    function callAnotherContract(address target, uint256 x, string memory y) external {
        // 编码函数调用和参数
        bytes memory data = abi.encodeCall(OtherContract.someFunction, (x, y));
        
        // 使用低级调用
        (bool success, bytes memory returnData(一般情况下可省略)) = target.call(data);
        require(success, "Low-level call failed");
    }
}

```  

#### 3.14.4 ABI 解码
解析日志里面的数据：

```
//其中data为日志数据
// solidity decode
(x) = abi.decode(data, (uint));

// ethers.js
const SetEvent = new ethers.utils.Interface(["event Set(uint256 value)"]);
let decodedData = SetEvent.parseLog(event);
```

#### 3.14.5 ABI 编解码可视化工具
- 函数选择器的查询及反查 ：[https://chaintool.tech/querySelector](https://chaintool.tech/querySelector)
- 事件签名的 Topic 查询：[https://chaintool.tech/topicID](https://chaintool.tech/topicID)
- Hash 工具提供Keccak-256 及 Base64：[https://chaintool.tech/hashTool](https://chaintool.tech/hashTool)
- 交易数据（calldata）的编码与解码： [https://chaintool.tech/calldata](https://chaintool.tech/calldata)

### 3.16 call 与 delegatecall

#### 3.16.1 底层调用
地址类型有3个底层的成员函数:

- targetAddr.call(bytes memory abiEncodeData) returns (bool, bytes memory)

- targetAddr.delegatecall(bytes memory abiEncodeData) returns (bool, bytes memory)

- targetAddr.staticcall(bytes memory abiEncodeData) returns (bool, bytes memory)
 
 `call`是常规调用，`delegatecall`为委托调用，`staticcall`是静态调用（不修改合约状态，相当于调用 view 方法）
 
 
#### 3.16.2 区别

- `delegatecall`委托调用没有上下文的切换，它像是给你一个主人身份（委托），你可以在当下空间做你想做的事；
- `call`是常规调用，每次常规调用都会切换上下文

**注意：**如果给一个合约地址转账x.func()时，合约的receive函数或fallback函数会随着transfer调用一起执行（这个是EVM特性），而send()和transfer()的执行只会使用2300 gas，因此在接收者是一个合约地址的情况下，很容易出现receive函数或fallback函数把gas耗光而出现转账失败的情况。

```
function safeTransferETH(address to, uint256 value) internal {
    (bool success, ) = to.call{value: value}(new bytes(0));
    //addr.call{gas:1000, value: 1 ether}(methodData);
    require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
}
```
 
 
### 3.15 合约内部创建合约
#### 3.15.1 使用 create 创建合约
`create`的用法很简单，就是`new`一个合约，并传入新合约构造函数所需的参数：

```
Contract x = new Contract{value: _value}(params)
```

#### 3.15.2 合约地址的计算
当使用`create`创建合约时，合约的地址取决于创建合约的地址（发送者）和该地址发起的交易数（nonce）。
**计算方式为：**`keccak256(rlp([sender, nonce]))`，其中，nonce 是一个从 1 开始的计数器，表示从该地址部署的合约数量。**注意：**此处的nonce与发送交易时的nonce并不同。

- create地址不易控制，根据创建者地址以及nonce创建`keccak256(rlp.encode([sender,nonce]))[12:]`

在使用`new`时实际上是在发送一个特殊的交易，这个交易在 EVM 中创建和存储新合约的字节码。
 
#### 3.15.3 使用 create2 创建合约
create2方法使用过合约加上一个盐，来部署合约，因此新部署的可约地址是可预测的。
**合约地址细节：**

- create2确定性创建合约`keccak256(bytes1(0xff)++sender++salt++keccak256(init_code))[12:]`

这个公式中的组件包括：

- 0xff：一个固定的前缀。
- sender_address：部署合约的地址。
- salt：一个由开发者指定的32字节值。
- init_code：合约的初始化字节码。//bytes memory bytecode = type(CustContractName).creationCode;
- [12:]：表示取结果的最后20字节作为地址。

ps: `计算出来的hash值转地址： address(uint160(uint256(hash)))`

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DeployWithCreate2{
    address public  owner;
    constructor(address _addr){
            owner = _addr;
    }
}

contract CreateFactory{
        event Deploy(address addr);

        function deploy(uint _salt) public {
            DeployWithCreate2 d2 = new DeployWithCreate2{
                salt:bytes32(_salt)
            }(msg.sender);
            emit  Deploy(address(d2));
        }

        function getAddress(bytes memory byteCode, uint salt) public view  returns (address){
               bytes32 hash = keccak256(
                abi.encodePacked(
                    bytes1(0xff),address(this),salt,keccak256(byteCode)
                 )
                );
            return address(uint160(uint(hash)));
        }

        function getByteCode(address _owner) public pure returns (bytes memory){
                bytes memory byteCode = type(DeployWithCreate2).creationCode;

            return abi.encodePacked(byteCode,abi.encode(_owner));
        }
}
```


### 3.16 存储模式与gas优化

#### 3.16.1 Storage 优化
主要的优化方法包括：

- 1.整合变量 
    将多个较小的变量打包到一个或多个更大的存储槽中，Solidity 中的存储是按照槽（32字节）组织的。尝试将多个较小的变量（如uint128，uint64等）组合在一个uint256中
    
    示例：
    
```
// 较低效的方式，以下三个变量打包两个槽中
contract Bad {
    uint64 public value1;
    uint128 public value2;
    uint64 public value3;
}

// 更高效的方式，以下三个变量打包到一个槽中
contract Good {
    uint64 public value1;
    uint64 public value3;
    uint128 public value2;
}
```

- 2.使用更紧凑的数据类型
    实际的应用需求选择最合适的数据类型。但注意，函数操作中使用较小类型（小于 uint256）可能会增加 gas 消费，因为 EVM 在操作中会将它们转换为256位。

- 3.删除不必要的存储变量
    分析合约，确保只存储必要的变量。如果某些数据可以通过计算得出，则无需将其存储在状态变量中。

- 4.避免在循环中使用存储变量
    尽量避免在循环中读取或写入存储变量。
    示例：
    
```
uint256[] public values;

// 较低效的方式：在循环中频繁读/写存储
function bad(uint256[] memory newValues) public {
    for (uint i = 0; i < newValues.length; i++) {
        values[i] = newValues[i];
    }
}

// 更高效的方式：使用内存数据进行操作，之后写回存储
function good(uint256[] memory newValues) public {
    uint256[] memory tempValues = values;
    for (uint i = 0; i < newValues.length; i++) {
        tempValues[i] = newValues[i];
    }
    values = tempValues;
}
```

#### 3.16.2 Memory 优化

- 1.避免在内存中复制大的数据结构，尽可能使用指针
- 2.准确计算函数的内存使用，尽量减少不必要的内存占用。

#### 3.16.3 Calldata 优化
calldata 类型的数据访问成本通常比 memory 低，因为它直接操作输入数据，避免了额外的内存分配。在函数中接收外部传入的数据时,使用`calldata`。它是一种不可修改的、只读的存储区域。

### 3.17 代理合约
代理合约是一种特定类型的智能合约，其主要作用是作为其他合约的代表或中介。允许用户通过它们与区块链进行直接交互，同时管理一个指向实际执行逻辑的逻辑合约（也称为实现合约）的地址。

#### 3.17.1 基本原理及组件
- 1.代理合约:
 - 用户实际上是与代理合约进行交互
 - 代理合约管理自身的状态变量
 - 代理合约通常包含一个指向逻辑合约的地址变量

- 2.逻辑合约：
 - 负责业务逻辑的实现
 - 可以升级而不影响由代理合约维护的数据。

#### 3.17.2 实现步骤
   - 1.创建逻辑合约
 
```
 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;

 contract Logic{
     address public logicAddress; // 没用上，但是这里占位是为了防止存储冲突
     uint public count;

     function incrementCounter() public {
         count += 1;
     }

     function getCount() public view returns (uint) {
         return count;
     }
 }
```

   - 2.编写代理合约 
  在代理合约中，任何非直接调用的函数都会通过`fallback`函数被重定向并使用`delegatecall`在逻辑合约上执行。
 
```
 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;

     contract Proxy {
         address public logicAddress;
         uint public count;

         constructor(address _logic) {
             logicAddress = _logic;
         }

         // 确保只有可信的地址可以更新逻辑合约地址
         function upgradeLogic(address _newLogic) public {
             logicAddress = _newLogic;
         }

         fallback() external payable {
             _fallback(logicAddress);
         }

         receive() external payable {
             _fallback(logicAddress);
         }

         function _fallback(address logic) internal {
             // 通过 delegatecall 调用逻辑合约的函数，并返回数据
             assembly {
                 //将调用数据（msg.data）从calldata复制到内存中。
                 //第一个参数0表示从内存位置 0 开始复制
                 //第二个参数0表示在calldata（调用数据）中，从哪个位置开始复制数据。
                 calldatacopy(0, 0, calldatasize())

                 //1. gas()：传递给目标合约的当前剩余可用 Gas 量。
                 //2. logic:目标合约的地址。
                 //3. 0:表示输入数据在内存中的起始位置。
                 //4. calldatasize():返回调用时输入数据的大小（以字节为单位）
                 //5. 0：这是表示输出数据存储在内存中的起始位置
                 //6. 0：这是表示预留的输出数据的内存大小。在这里是 0，
                 //意味着在调用前不知道返回数据的大小，所以先不预留内存空间。
                 //返回数据的大小会在调用完成后通过 returndatacopy 来处理。
                 let result := delegatecall(gas(), logic, 0, calldatasize(), 0, 0)

                 //returndatacopy 是一种内联的低级函数，
                 //它将调用之后返回的数据复制到内存中。
                 //1. 0: 返回数据存储在内存中的起始位置。
                 //2. 0: 从返回数据中开始复制的偏移量。
                 //3. returndatasize() 返回上一次低级调用（如 delegatecall 或 call）的返回数据大小（以字节为单位）。
                 returndatacopy(0, 0, returndatasize())

                 switch result
                 // delegatecall returns 0 on error.
                 case 0 {
                     revert(0, returndatasize())
                 }
                 //当 result 为非零（即调用成功）时执行这个 default 分支。
                 default {
                    //1. 0：表示从内存地址 0 开始读取返回数据（这是成功时返回数据的起始位置）。
                     return(0, returndatasize())
                 }
             }
         }
     }
 }
```

   - 3. 合约部署与使用:
     - 部署逻辑合约，并记下其地址
     - 使用逻辑合约的地址作为参数，部署代理合约
     - 通过代理合约地址调用逻辑合约的功能

#### 3.17.3 Delegate Call 和 存储冲突
`delegatecall`是一种特殊的函数调用，使得一个合约（比如代理合约）能够调用另一个合约（比如逻辑合约）的函数，并在代理合约的存储环境中执行这些函数。也带来了存储冲突的风险。存储冲突主要发生在逻辑合约和代理合约的存储布局不匹配的情况下。

  - 场景1：存储布局不一致
    假设逻辑合约Logic中先声明的是`uint public count`;，而代理合约 Proxy 中先声明的是`address public logicAddress`;。这种情况下，当Proxy使用`delegatecall`调用Logic中的`incrementCounter()`方法时，它本意是修改count的值，但由于存储布局的不匹配，实际上它会错误地改变代理合约`logicAddress`的存储位置的内容。
    
| Proxy | Logic |  |
| --- | :-: | :-: |
| address logicAddress | uint256 count | <=== 存储冲突 |
| uint256 count | address not_used |  |

  - 场景2：升级导致的冲突
  即使最初的存储布局是匹配的，合约升级也可能引入新的存储冲突。比如，Logic V2中，调整了变量foo和bar的位置，会导致存储冲突：

| Proxy | Logic1 | Logic2 |   |
| --- | --- | --- | --- |
| address logicAddress | address not_used | address not_used |    |
| uint256 count | uint256 count | uint256 count |    |
| address foo | address foo | address bar |  <=== 存储冲突，V2 bar 变量对应 Proxy 中的 foo  |
| address bar | address bar | address foo |  <=== 存储冲突，V2 foo 变量对应 Proxy 中的 bar  |
 
### 3.18 可升级合约
 
 - **透明代理模式**：在透明代理模式中，存在一个管理员地址独有的权限来升级智能合约。用户与合约的交互对用户完全透明，即用户不需要了解幕后的实现合约。
 示例代码：
 
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 逻辑合约
contract TransparentLogic {
    address public logicAddress; // 防止存储冲突
    address public adminAddress; // 防止存储冲突
    uint public count;

    function incrementCounter() public {
        count += 1;
    }

    function getCount() public view returns (uint) {
        return count;
    }
}

// 代理合约
contract TransparentProxy {
    address public logicAddress; // 逻辑合约地址
    address public adminAddress; // 管理员地址
    uint public count;

    constructor(address logic) {
        logicAddress = logic;
        adminAddress = msg.sender;
    }

    function upgrade(address newLogic) public {
        require(msg.sender == adminAddress, "Only admin"); // 限制了只能是管理员才能调用
        logicAddress = newLogic;
    }

    fallback() external payable {
        require(msg.sender != adminAddress, "Admin not allowed"); // 限制了调用者不能是管理员
        _fallback(logicAddress);
    }

    receive() external payable {
        _fallback(logicAddress);
    }

    function _fallback(address logic) internal {
        // ...
        }
    }
}
```

- **UUPS 模式：**UUPS（Universal Upgradeable Proxy Standard，通用升级代理标准）模式通过实现合约本身的逻辑来控制升级的过程。
   UUPS 中的实现合约包括**业务逻辑**和**升级逻辑**。实现合约内有一个专门的函数用于修改存储实现合约地址的变量，这使得实现合约可以更改其自身的逻辑。当需要升级合约时，通过在实现合约中调用一个特殊的更新函数来更改指向新合约的地址，从而实现逻辑的更换，同时保留存储在代理合约中的状态数据。
   示例：
   
```
// 实现合约
contract UUPSLogic {
    address public logicAddress; // 防止存储冲突
    address public adminAddress; // 防止存储冲突
    uint public count;

    function incrementCounter() public {
        count += 1;
    }

    function getCount() public view returns (uint) {
        return count;
    }

    function upgrade(address newLogic) public {
        require(msg.sender == adminAddress, "Only admin");
        logicAddress = newLogic;
    }
}

// 代理合约
contract UUPSProxy {
    address public logicAddress; // 逻辑合约地址
    address public adminAddress; // 管理员地址
    uint public count;

    constructor(address logic) {
        logicAddress = logic;
        adminAddress = msg.sender;
    }

    fallback() external payable {
        _fallback(logicAddress);
    }

    receive() external payable {
        _fallback(logicAddress);
    }

    function _fallback(address logic) internal {
        // ... 
    }
}
```
与透明代理模式不同，升级函数（upgrade()）位于实现合约中，而代理合约中不存在升级的逻辑。另外，fallback()函数不需要检查调用者是否是管理员，可以节省gas。


#### 3.18.1 EIP-1967
未了避免存储冲突可以采用`EIP-1967`提出的代理存储槽标准。EIP-1967 旨在为智能合约的升级模式提供一种标准化和安全的实现方法。该标准主要关注使用代理模式进行智能合约升级的流程，提高智能合约系统的透明性和可操作性。

**EIP-1967 主要内容:**
一种标准化的方法来存储关键信息，如实现合约的地址，到固定且已知的存储位置。这主要包括两个方面:
 
 - 1.实现合约地址（implementation address）:实现合约地址存储在特定的槽位`0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
该槽位通过`bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)`计算得出。
 
 - 2.管理员地址（admin address）:合约的管理员（通常负责合约升级）地址存储在特定的槽位`0xb53127684a568b3173ae13b9f8a6016e243e63b6eb8ee141579563b1e0cad5ff`
该槽位通过`bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1)`计算得出。
 
 - 3.Beacon 合约地址:（Beacon 合约的主要功能是充当“路由器”或“中介”，使得其他合约可以通过 Beacon 合约动态地链接到更新后的逻辑代码，而不需要直接修改或重新部署原始合约。）Beacon 合约地址存储在特定的槽位`0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50`
该槽位通过`bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)`计算得出。


### 3.19 销毁合约
`selfdestruct`是 Solidity 中的一种特殊函数，用于销毁合约。销毁合约后，合约的代码和存储都将从区块链中移除，合约剩余的以太币将被发送到指定的地址。
语法：`selfdestruct(address payable 0x00xxxx);`

- **伦敦升级:**不仅能收回部分 gas（与删除的数据量有关），还会在结算时，根据当前的 gas 消耗返还一定比例的已消耗 gas 给执行者。伦敦升级后（EIP-3529）selfdestruct 操作不会再返还 gas。
- **上海升级:**升级后（EIP-6049，solidity v0.8.18），selfdestruct 视为已弃用，编译器将对其使用发出警告，不再建议使用。
- **坎昆升级:**坎昆升级后（EIP-6780，solidity v0.8.24），selfdestruct 只发送剩余的以太币，不会清除合约的代码和存储。除非在同一个交易中部署和销毁合约。
 
### 3.20 其他

**mutal call**

使用场景主要为：前端需要调用合约很多次，但是链上限制每个客户端调用链20s内仅允许调用一次的情况，所以就把对合约的多次调用打包成一次。
示例如下：

```
pragma solidity ^0.8.17;

contract TestMutialCall{

    function test1() public view  returns (uint,uint){
        return (1,block.timestamp);
    }

    function test2() public  view returns (uint,uint){
        return (2,block.timestamp);
    }

    function getTest1Data() external pure  returns (bytes memory){
        //return  abi.encodeWithSignature("test1()");
        return  abi.encodeWithSelector(this.test1.selector);
    }

    function getTest2Data() external  pure  returns (bytes memory){
        return abi.encodeWithSelector(this.test1.selector);
    }
}

contract MutialCall {

        function mutialCall(address[] calldata _addresses,bytes[] calldata _data) view  public  returns (bytes[] memory){
               require(_addresses.length == _data.length,"count not match"); 

               bytes[] memory results = new bytes[](_data.length);

                for (uint i=0;i < _data.length;i++){
                    (bool succ,bytes memory res) =_addresses[i].staticcall(_data[i]);
                    require(succ == true,"not success");
                    results[i] = res;
                }
                return  results;
        }
}
``` 

**muti delegateCall**

为什么要使用多重代理调用：通过调用合约来获取自己的一些信息，而不是合约的信息。
原因如下：
alic ---> muti call ---> call ---> test (msg.sender = multi call)
alic ---> test ---> delegatecall ---> test (msg.sender = alic)

多重委托调用可能存在的漏洞：mint()即铸造方法，在多重委托调用中，可以多次调用铸造方法，以达成转一次币但是余额确实多次的结果。解决以上问题的办法有：1.在多重委托调用的函数中禁止使用payable方法 2.在方法中增加余额的方法采用非累加方法；


- **new**:创建对象，合约等

- **delete**
    - delete操作符可以用于任何变量，将其设置成默认值
    - 如果对动态数组使用delete，则删除所有元素，其长度变为零
    - 如果对静态数组使用delete,则重置所有索引的值
    - 如果对map类型使用delete，什么都不会发生，但如果对map类型中的一个键使用delete，则会删除与该相关的值

```js
    //1.string 
    string public st1 = "hello";
    
    function deleteStr() public{
        delete st1;
    }
    
    //2.array 对于固定长度的数组
    uint256[10] public array = [1,2,3,4,5];

    function deleteFiexedArray() public {
        delete array;
    }
    
    //3. array new 
    uint256[] array2;
    
    function setArray2() public {
        array2 = new uint256[](10);
        for (uint256 i = 0;i < array2.length;i++){
            array2[i] = i;
        }
    }
    
    function deleteArray2() public{
        delete array2;
    }
    
    
    //4.mapping
    mapping(uint256 => string)m1;
    
    function setMap() public {
        m1[0] = "hello";
        m1[1] = "world";
    }
    
    function deleteMapping(uint256 i) public {
        delete m1[i];
    }
```


### WETH合约

weth代币就是包装ETH主币，作为ERC20的合约
**注意：**1.转换金额要匹配即：10eth <=> 10weth

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


remix访问本地文件

1.安装remixd:npm install -g @remix-project/remixd
2.共享文件：remixd -s <path-to-the-shared-folder> -u <remix-ide-instance-url>



智能合约开发

youtube:PartickCollins
b站：Chainlink预言机

项目：
Youtube:Daulat Hussain

