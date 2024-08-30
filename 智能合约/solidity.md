# solidity

数据类型：
1.值类型(整型，布尔，地址，枚举，函数) 
2.引用类型(solidity没有指针，对于复杂结构是使用关键字**storage**修饰,数组，字符串，结构体)

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


##1.值类型介绍

###1.1 状态变量
定义在合约之内，但在函数之外的变量，这些值会被上传到区块链上保存起来

```
string public Message = "hello world!";

```

###1.2 布尔 

```
bool f = false;
```

其中`&&`逻辑与，`||`逻辑或为短路运算符，对于`||`来说第一个为true则第二个将不再执行，对于`&&`来说第一个为false则第二个不再执行。可以节约部分gas支出

###1.3 整型

- int
- uint
- 以8位为区间的int8，int16等，int默认为int256,uint默认为uint256

- 属性：
    - `type(T).min`: 获取整型 T 的最小值
    - `type(T).max`: ------ T 的最大值
  
 1.整数字面常量中用`_`增加可读性 
     
```
 uint256 public x = 233_311_1;
```   
 
 2.字面常量支持任意精度   
 
 例如：
```
    uint8 public b = 0.5 * 8;
```

3.除法截断(引入变量以后)


```
            uint256 a = 1;
            uint256 b = 4;
            uint256 c = (1/4)*4;  //1
            uint256 d = (a/b)*b;  //0
```

4.优先使用较小类型计算


####1.3.1 定长浮点型
    可以声明定长浮点型的变量，但是不能给他们赋值或赋值给其他变量
    
    可以通过自定义值类型进行模拟；
    
####1.3.2 定长字节数组
    定义方式`bytesN`其中n可取1~32中的任意整数
    
    - 属性 1.长度  2.索引


####1.3.3 注释

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
 

###1.4 函数类型

函数是一个特殊的变量，可以**当做变量赋值**，**当做函数参数传递**，**当做返回值**

函数形式：funtion  函数名  函数类型  返回值

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

###1.5 地址  address

address/uint/byte32之间的转换
 
 - address 20字节
 - uint160 20字节

 byte32 => address : `address(uint160(uint256(hash)))` 其中has即为byte32的值
 

地址属性：`balance`:`<address>.balance  returns(uint256)`;`code`:`<address>.code return(bytes memory)`;`codehash`:`<address>.codehash return(bytes32)`

可以给address(0)转钱，币的销毁也可以转给address(0)

地址方法：
1.`address():将地址转换到地址类型`；
2.`payable():将普通地址转换为可支付地址`；
3.`transfer(uint256 amount):将余额转到当前地址(如果发生错误会reverts)`;
4.`send(uint256 amount):将余额转到当前地址并返回交易成功状态(有一个bool类型的返回值)`;
5.`call{value:xx，gas:xxx(调整代码gas消耗)}(""):通过call方法将余额转到当前地址(又两个返回值一个bool类型是否成功，另一个bytes类型)`
6.`delegatecall(bytes memory) :可以用于合约升级(顺序必须一致）`

transfer/send/call 三种转账的总结
    
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




####1.5.1 以太币

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


###1.6 枚举

  枚举类型是在Solidity中的一种用户自定义类型。枚举可以显示的转换与整数进行转换，但不能进行隐式转换。显示的转换会在运行时检查数值范围，如不匹配会引起异常。
  枚举类型应至少有一名成员，枚举元素默认为uint8，当元素数量足够多时，会自动变为uint16,第一个元素默认为0，超出范围的数值会报错。
  

```go
enum weekend {
  Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
}
```

###1.7 自定义类型
    
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
     

###1.8 合约类型

创建的例子：
    
    - 声明一个合约类型：`A public a1;`
    - 声明+赋值：`A public a2 = A(0xxxxxx);`
    - 构造函数：`A public a3 = new A();`

属性：

    - type(C).name:获取合约名字
    - type(C).creationCode: 获取创建合约字节码
    - type(C).runtimeCode: 获取合约运行时的字节码


##2.引用类型

数据位置的基础介绍
    
    - storage: 状态变量的保存位置 
    - memory:  数据存储在内存中仅在函数调用期间有效
        mapping和struct不能再函数中动态创建，必须从状态变量中分配
    
    - calldata: 保存函数参数的特殊位置，一个只读的位置，消耗的gas较低，只能用在函数的输入和输出，不允许修改
        
        calldata可以隐式的转换成memory，但是memory却不能隐式的转换成calldata;

###2.1 数组

固定长度数组
uint256[5] public t = [1,2,3,4]

变长数组
uint256[] public t = new uint256[](6);

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

###2.2 字符串(string)

- 动态尺寸的UTF-8编码字符串，是特殊的可变字节数组
- 引用类型
- 不支持下标索引
- 不支持length,push方法
- 可以修改（需通过bytes转换）

方法：`string.concat`用于字符串拼接



###2.3 数据位置(Data location)
复杂类型，不同于之前**值类型**,占用空间更大，超过256字节，因为拷贝他们占用更多的空间，如**数组(arrays)**和**结构体(struct)**，他们在solodity中有一个额外的属性，即数据的存储位置：**memory**和**storage**。

**-  内存(memory)**

- 数据不是永久存在的，存放在内存中，超过作用域后无法访问，等待被回收。
- 被memory修饰的变量是直接拷贝，即与上述的值类型传递方式相同。

**-  存储(storage)**

- 数据永久保存性
- 被storage修饰的变量是引用传递，相当于只传递地址，新旧两个变量指向同一片内存空间，效率较高，两个变量有关联，修改一个，另外一个同样被修改。
- 只有引用类型的变量才可以显示的声明为**storage**

###2.4 结构体


```go
   struct Student {
        
        string name;
        
        uint8 age;  
    }
    
    //利用元组来返回 
    function getDetail() public view returns( string memory,uint8){
       return (st1.name,st1.age);
    }
    
```

在读取结构体数据的时候，函数内读取并返回尽量使用storage变量接受，这样可以减少数据的拷贝次数节约gas消耗.

删除: `delete Student;`仅仅是重置数据并不是真正的删除；


###2.5 字典，映射(mapping)

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





##3.高级语法
###3.1 msg.sender和msg.value

- msg.Sender
1.部署合约的时候，msg.sender就是部署合约的账户
2.调用setMessage，msg.sender就是调用账户
3.调用getMessage，msg.sender就是调用账户

- msg.value
在合约中，每次准入的value是可以通过msg.value来获取的，有msg.value就必须有payable关键字


###3.2 公共函数

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

###3.3 哈希函数

在solidity中可是使用`keccak256()`函数来对一段数据计算哈希，在使用的过程中，一般会结合`abi.encode()`或`abi.encodePacked()`这两个方法都是对数据进行编码，但是区别在于`abi.encode()`会对传入的参数进行补零操作，而`abi.encodePacked()`不会，但是`abi.encodePacked()`函数是对数据的压缩，容易造成哈希碰撞的问题。示例：

```
abi.encodePacked(”aaa“,"bb") 

abi.encodePacked("aa","abb") 

这两种方式下的结果相同，但是从数据层面并不是一样的数据，为了避免上面的问题可以通过数字隔开数据的方式
```

###3.4 验证签名

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

###3.3 错误处理

传统方法：采用throw和if ... throw 模式(已过时)。如：合约中有一些功能，只能被授权为拥有者的地址才能使用

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


####3.3.1 错误捕获

使用

```

try  func() {

     do something 
     
} catch Error(string memeory data){ //catch error 
    
}

```





###3.4 修饰器（modifier）

修饰器(modifier)可以用来轻易的改变一个函数的行为。比如用于在函数执行前检查某种前置条件。修饰器是一种合约属性，可被继承。同时还可以被派生的合约重写(override)。

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

货币单位：wei,finney,szabo和ether,转换关系： 1 ether = 10 ** 18wei = 1000 finney = 1000000 szabo

时间单位：second,minutes,hours,days,weeks,years，默认是seconds


###3.5 事件
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

###3.6 访问函数(Getter Funtions)
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

###3.7 合约
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


###3.8 元组(tuple)
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

###3.9 继承
is表示继承，多继承用“,”分开。当使用继承的时候需要对父合约的函数进行标记哪些函数是可以被**重写**的，使用的标记关键字为`virtual`，在子合约中首先要标记子合约是继承于父合约的，即 `contract b is a`，在子合约中也要在对应的函数中标记该函数是覆盖掉父合约的函数的，标记为`override`,当子合约也被继承了的时候，子合约中的函数同样需要标记哪些函数可以被重写。

继承的子合约只能访问父级合约的内部函数与变量，公开函数与变量。且继承的子合约不能重写

**多线继承：**多线继承需要遵循一个原则：从基类到派生的关系，从越基础合约到越派生的顺序。当多线继承的函数中需要覆盖继承的函数的之后需要在函数中追加标记`override(x,y)`，代表同时覆盖两个合约的方法。

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

**运行父级合约构造函数：**

示例入下：

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

//混合形式
contract W is X("s"),T{
    constructor(string memory _name) T(_name) {

    }
}
```

**调用父级函数：**

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

###3.10 其他

**Create2方法：**
create2方法使用过合约加上一个盐，来部署合约，因此新部署的可约地址是可预测的。

合约地址细节：

1.create地址不易控制，根据创建者地址以及nonce创建`keccak256(rlp.encode([sender,nonce]))[12:]`

2.create2确定性创建合约`keccak256(0xff++sender++salt++keccak256(code))[12:]`


示例如下：

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
               bytes32 hash =  keccak256(
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


**- new**
-
创建对象，合约等

**-delete**
-

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




op-geth：https://github.com/domicon-labs/op-geth 功能：domicon测试网中的DA存储和广播端 default分支名字->develope



https://github.com/domicon-labs/op-geth 
broadcost node and store node for Domicon testnet V1.0

主要改动：节点间广播传递DA数据的专属传输协议，以及节点主动,被动,转发索取DA数据检索；
        节点拥有缓存DA数据的内存池以及本地临时保存异常崩溃恢复机制以及定时清理删除无用的数据；
        节点被动永久(可配置定时)存储DA数据；
        节点提供对传输进来的DA数据的签名以及验签；
        节点提供对于DA的检索，检索方式为通过rpc方式通过查询交易哈希，commitment获取原始DA数据

CREATE TABLE syncInfo (
  last_block_num INTEGER PRIMARY KEY,
);



`(
			tx_hash             VARCHAR NOT NULL PRIMARY KEY REFERENCES transaction (hash) ON DELETE CASCADE,
        commitment  VARCHAR,
        hash        VARCHAR,
        data        VARCHAR
            );`

