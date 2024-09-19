# Fundry 
Foundry 是一个Solidity框架，用于构建、测试、模糊、调试和部署Solidity智能合约， Foundry 的优势是以Solidity 作为第一公民，完全使用 Solidity 进行开发与测试。
Foundry 的测试功能非常强大，通过[作弊码](https://learnblockchain.cn/docs/foundry/i18n/zh/forge/cheatcodes.html#%E4%BD%9C%E5%BC%8A%E7%A0%81cheatcodes)来操纵区块链的状态，可以方便我们模拟各种情况，还支持基于属性的模糊测试。

## 安装

终端并输入以下命令：

```
curl -L https://foundry.paradigm.xyz | bash
```
这会下载`foundryup`。 然后通过运行它安装 Foundry：

```
foundryup
```
安装安装后，有三个命令行工具 `forge`, `cast`, `anvil` 组成

 - **forge**: 用来执行初始化项目、管理依赖、测试、构建、部署智能合约 ;
 - **cast**: 执行以太坊 RPC 调用的命令行工具, 进行智能合约调用、发送交易或检索任何类型的链数据
 - **anvil**: 创建一个本地测试网节点, 也可以用来分叉其他与 EVM 兼容的网络。


## 初始化Foundry项目
通过 forge 的 `forge init` 初始化项目

```
forge init hello_foundry
```

init 命令会创建一个项目目录，并安装好`forge-std` 库。

如需手动安装依赖库使用：`forge install forge/forge-std`

创建好的 Foundry 工程结构为：

```
> tree -L 2
.
├── foundry.toml
├── lib
│   └── forge-std
├── script
│   └── Counter.s.sol
├── src
│   └── Counter.sol
└── test
    └── Counter.t.sol

5 directories, 4 files
```

- `src`：智能合约目录
- `script` ：部署脚本文件
- `lib`: 依赖库目录
- `test`：智能合约测试用例文件夹
- `foundry.toml`：配置文件，配置连接的网络URL 及编译选项。

Foundry 使用 Git submodule 来管理依赖库，`.gitmodules`文件记录了目录与子库的关系:

```
[submodule "lib/forge-std"]
    path = lib/forge-std
    url = https://github.com/foundry-rs/forge-std
    branch = v1.5.0
```

## 合约开发及编译
合约开发推荐使用 VSCode 编辑器 +[solidity 插件](https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity)，在contracts 下新建一个合约文件 `Counter.sol` (*.sol 是 Solidity 合约文件的后缀名), 复制如下代码：

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public counter;

    function setNumber(uint256 newNumber) public {
        counter = newNumber;
    }

    function increment() public {
        counter++;
    }

    function count() public {
        counter = counter + 1;
    }
}

```

在`foundry.toml `中使用`solc`配置编译器版本：


```
[profile.default]
src = 'src'
out = 'out'
libs = ['lib']

solc = "0.8.18" 
```
更多的配置项请参考[foundry.toml](https://learnblockchain.cn/docs/foundry/i18n/zh/reference/config/overview.html)配置


## 编译合约

```
> forge build
[⠒] Compiling...
[⠔] Compiling 1 files with 0.8.18
[⠒] Solc 0.8.18 finished in 362.64ms
Compiler run successful
```

## 编写自动化测试

测试是用 Solidity 编写的。 如果测试功能 revert，则测试失败，否则通过。

### 测试 Case 编写

在测试目录下`test`添加自己的测试用例，添加文件`Counter.t.sol` ，foundry 测试用例使用 `.t.sol` 后缀，约定具有以`test`开头的函数的合约都被认为是一个测试，以下是测试代码：

```
pragma solidity ^0.8.13;

//引入 [Forge 标准库](https://github.com/foundry-rs/forge-std) 的 Test 合约，并让测试合约继承 Test 合约， 这是使用 Forge 编写测试的首选方式。
//
import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    //setUp() 函数用来进行一些初始化，它是每个测试用例运行之前调用的可选函数
    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.counter(), 1);
    }
    
    
    //test 为前缀的函数的两个测试用例，测试用例中使用 assertEq 断言判断相等。
    //testSetNumber 带有一个参数 x， 它使用了基于属性的模糊测试， [forge 模糊器](https://learnblockchain.cn/docs/foundry/i18n/zh/forge/fuzz-testing.html)默认会随机指定256 个值运行测试。
    
    //也可以通过配置参数的方式设定模糊测试的轮次
    //forge-config: default.fuzz.runs = 500
    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.counter(), x);
    }
    
    //在测试用例用 console2.sol 打印值的结果
    //console2.sol 包含 console.sol 的补丁，允许Forge 解码对控制台的调用追踪
    function testIncrement2() public {
        counter.increment();
        uint x = counter.counter();
        console2.log("x= %d", x);
        assertEq(x, 1);
    }
}
```


### 运行测试

Forge 使用 forge test 命令运行测试用例

```
> forge test
[⠒] Compiling...
No files changed, compilation skipped

Running 2 tests for test/Counter.t.sol:CounterTest
[PASS] testIncrement() (gas: 28390)
/**
"runs" 是指模糊器 fuzzer 测试的场景数量。 默认情况下，模糊器 fuzzer 将生成 256 个场景，但是，其可以使用`FOUNDRY_FUZZ_RUNS`环境变量进行配置。
“μ”（希腊字母 mu）是所有模糊运行中使用的平均 Gas
“~”（波浪号）是所有模糊运行中使用的中值 Gas
**/
[PASS] testSetNumber(uint256) (runs: 256, μ: 28064, ~: 28453)
Test result: ok. 2 passed; 0 failed; finished in 9.33ms
```

`forge test`的默认行为是只显示通过和失败测试的摘要。 可以使用`-vv`标志通过增加日志详细程度：

```
> forge test -vv
[⠒] Compiling...
No files changed, compilation skipped

Running 2 tests for test/Counter.t.sol:CounterTest
[PASS] testIncrement() (gas: 31626)
Logs:
  x= 1

[PASS] testSetNumber(uint256) (runs: 256, μ: 27597, ~: 28453)
Test result: ok. 2 passed; 0 failed; finished in 9.94ms
```

`forge test --match-test testxxxx`运行指定测试函数
`forge test --mt testxxxx`运行指定测试函数

### 测试技巧

#### 创建测试钱包地址
如需模拟多个用户钱包身份来参加测试，可以使用`makeAddr()`来创建。

```
address alice = address(0x488xxxxxxxxxxx);
address bob = makeAddress("bob");
address eva = makeAddress("任意字符")
```

#### 改变msg.sender
当希望`alice`的钱包和合约交互时，可以在调用合约方法前，通过`vm.parnk(alice)`的方式设置：

```
function test_Increment() public {
    address alice = address(0x4123xxxxxxx);
    vm.prank(alice);
    counter.increment();
    assertEq(counter.number(),1);
}
```

如果后面所有的执行都是用alice身份执行，可以使用`vm.startPrank(alice)`设置：

```
function test_Increment() public {
    address alice = address(0x4123xxxxxxx);
    vm.startPrank(alice);
    counter.increment();
    counter.increment();
    counter.increment();
    vm.stopPrank();
    assertEq(counter.number(),1);
}
```
在使用`vm.startPrank(alice)`时，需要在使用`vm.stopPrank()`来取消`alice`执行身份。

#### 给测试钱包存入eth
 测试钱包没有钱，可以在测试中使用`deal(alice,1000 ether)`来存入`1000 ether`给`alice`：
 
```
function test_some() public {
    address alice = makeAddress("alice");
    deal(alice,1000 ether);
}
``` 
**注意：**`deal`并不是直接给`alice`1000个`ether`，而是将`alice`的余额重置为1000个`ether`。

#### 断言合约执行错误
在测试合约中，需要检测执行合约是否需要符合某种错误，使用`expect-revert`即可。

```
//0.8版本以前都可用 
vm.expectRevert("Owner cant't buy");
mkt.buyNFT(address(nft),tokenId,address(token));

//0.8以后多出了error类型需要使用
//仅关注错误类型
//vm.expectRevert(CustomError.slelctor);
//错误类型以及参数信息
//vm.expectRevert(abi.encodeWithSelector(CustomError.selector,param1,param2));
```

#### 断言合约返回值是否符合预期
##### 断言值是否相等

```
assertEq(nft.ownerOf(tokenId),alice,"expect nft owner is alice");
```

##### 断言合约事件
判断测试合约的执行是否出现符合预期的合约事件使用`expect-emit`
api有：

```
function expectEmit() external;
```

```
function expectEmit(
  bool checkTopic1,
  bool checkTopic2,
  bool checkTopic3,
  bool checkData
) external; 
```

```
function expectEmit(
  bool checkTopic1,
  bool checkTopic2,
  bool checkTopic3,
  bool checkData,
  address emitter
) external;
```
断言下一次调用期间发出特定日志。
使用步骤：
 
 - 1. 调用作弊码`expectEmit`,指定是否应该检查第一个，第二个或第三个主题，以及日志Data数据。注意，`expectEmit()`表示全部检查，`Topic0`始终被检查。
 - 2. `emit`一个我们期望在下次`call`期间看到的时间
 - 3. 调用合约方法。

示例：

```
function testERC20EmitBatchTransfer() public {
    for (uint256 i=0;i<users.length;i++) {
        //topic(always checked),topic1(true),topic2(true),Not topic3(false),and data
        vm.expectEmit(true,true,false,true);
        emit Transfer(address(this),users[i],10);
    }


    //期望出现`BatchTransfer(uint256 numberOfTransders)`事件
    vm.expectEmit(flase,false,false,true);
    emit BatchTransfer(users.length);
    
    mtToken.batchTransfer(users,10);
}
```

##### error类型的测试
在`revert`抛出错误信息时，error信息会被编码成：

```
bytes memory err = abi.encodeWithSelector(xxxxxx(自定义错误).selector,params1，params2...);
revert(err);
```

测试代码：

```
error xxxxxx(自定义错误) (type params1,type params2);

function test_needApprove() public {
    address bob = makeAddress("bob");
    uint256 amount = 1000;
    vm.expectRevert(abi.encodeWithSelector(xxxxxx(自定义错误).selector,params1，params2...));
    
    //或者
    vm.expectRevert(abi.encodeWithSignature(”xxxxxx(自定义错误)(Type1，Type2...)“,param1,param2);
    
    vm.prank(bob);
    usdt.transfer(alicce,amount);
}
```


## 部署合约

部署合约到区块链，需要先准备有币的账号及区块链节点的 RPC URL。
Forge 提供 create 命令部署合约， 如：

```
forge create  src/Counter.sol:Counter  --rpc-url <RPC_URL>  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

部署合约需要做的事：

- 1. 使用`forge create`来部署合约
- 2. 指定一个钱包
    -  `- pricateKey` 
    -  `- keystore` 指定加密私钥文件的路径，执行时输入密码
    -  `- account`  从默认文件夹中获取keystore,执行时输入密码
- 3. 选择链
    - `--chain`
- 4. 选择rpc节点
    - `--https://chainlist.org`   
    - `自有节点`
    - `本地节点`

create 命令需要输入的参数较多，使用部署脚本是更推荐的做法是使用`[solidity-scripting](https://learnblockchain.cn/docs/foundry/i18n/zh/tutorials/solidity-scripting.html)`部署。为此我们需要稍微配置 `Foundry`。
通常我们会创建一个 `.env` 保存私密信息（如：私钥），`.env `文件应遵循以下格式:

```
GOERLI_RPC_URL=
MNEMONIC=
```
`.env`中记录自己的助记词及RPC URL。
编辑`foundry.toml`文件：

```
[rpc_endpoints]
goerli = "${GOERLI_RPC_URL}"
local = "http://127.0.0.1:8545"
```
然后在 script 目录下创建一个脚本，`Counter.s.sol`

```
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Counter.sol";

//创建一个名为 CounterScript 的合约，它从 Forge Std 继承了 Script。
contract CounterScript is Script {
    //默认情况下，脚本是通过调用名为`run`的函数（入口点）来执行的部署。    
    function run() external {
        //从 .env 文件中加载助记词，并推导出部署账号
        //如果 .env 配置的是私钥，这使用uint256 deployer = vm.envUint("PRIVATE_KEY"); 加载账号
        string memory mnemonic = vm.envString("MNEMONIC");
       (address deployer, ) = deriveRememberKey(mnemonic, 0);
        //这是一个作弊码，表示使用该密钥来签署交易并广播。        
        vm.startBroadcast(deployer);
        //创建Counter 合约。
        Counter c = new Counter();
        console2.log("Counter deployed on %s", address(c));
        vm.stopBroadcast();
    }
}
```
 在项目的根目录运行：
 
```

> source .env

> forge script script/Counter.s.sol --rpc-url goerli --broadcast 
[⠒] Compiling...
[⠊] Compiling 1 files with 0.8.18
[⠒] Solc 0.8.18 finished in 738.87ms
Compiler run successful
Script ran successfully.
Gas used: 127361

== Logs ==
  Counter deployed on 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
...

```

如果我们不想在命令中输入--rpc-url， 可以在`foundry.toml`配置一个默认的 URL：

```
eth-rpc-url = "${GOERLI_RPC_URL}"  // 本地 RPC 为 http://127.0.0.1:8545
```
`forge script`支持在部署时进行代码验证，在`foundry.toml`文件中配置了 etherscan的 API KEY：

```
[etherscan]
goerli = { key = "${ETHERSCAN_API_KEY}" }
```
然后需要在 script 命令中加入`--verify`就可以执行代码开源验证


### 安装第 3 方库
使用`forge install`可以安装第三方的库，不同于 npm，forge 会把整个第三方的库的 Git 仓库作为子模块放在lib目录下。 使用命令如下:

```
forge install [OPTIONS] <github username>/<github project>@<tag>
```
例如，安装`openzepplin`使用命令:

```
> forge install OpenZeppelin/openzeppelin-contracts
Installing openzeppelin-contracts in "/Users/emmett/course/hello_decert/lib/openzeppelin-contracts" (url: Some("https://github.com/OpenZeppelin/openzeppelin-contracts"), tag: None)
    Installed openzeppelin-contracts v4.8.2

```

安装之后，`.gitmodules`会添加新记录：

```
[submodule "lib/openzeppelin-contracts"]
    path = lib/openzeppelin-contracts
    url = https://github.com/OpenZeppelin/openzeppelin-contracts
    branch = v4.8.2
```

lib 下也会多一个openzeppelin文件夹:

```
> tree lib -L 1
lib
├── forge-std
└── openzeppelin-contracts
```

### 创建钱包以及导入钱包

使用`cast`命令进行相关操作，更多操作参考[cast使用说明](https://book.getfoundry.sh/reference/cast/cast?highlight=cast#cast)

#### 创建钱包
//创建的钱包默认路径在`~/.foundry/`
```
//打开终端
>:cast wallet new

Successfully created new keypair.
Address:     0x2968d08A95e1A069bb58509F88DC41DDAe416eF3
Private key: 0x2715dfd2835e203d7da5a2b9b6861bd7f4c61ebe1f2b35dd25c9c92f628b102c
```

#### 导入钱包

```
cast wallet import -i admin //admin是自定义的ACCOUNT_NAME

Enter private key:
Enter password: 
`admin` keystore was saved successfully. Address: 0x2968d08a95e1a069bb58509f88dc41ddae416ef3
```

#### 防止密码输入错误可再次验证

```
cast wallet address --account admin
Enter keystore password:
0x2968d08A95e1A069bb58509F88DC41DDAe416eF3
```

### 相关环境配置
在对合约进行部署的时候，可以使用`forge creat -h | grep env`对一些部署所需要的环境变量的查询：

```
    Timeout to use for broadcasting transactions [env: ETH_TIMEOUT=]
      --libraries <LIBRARIES>  Set pre-linked libraries [env: DAPP_LIBRARIES=]
      --remappings-env <ENV>
          The project's remappings from the environment
          Gas limit for the transaction [env: ETH_GAS_LIMIT=]
          [env: ETH_GAS_PRICE=]
          Max priority fee per gas for EIP1559 transactions [env:
          Gas price for EIP-4844 blob transaction [env: ETH_BLOB_GAS_PRICE=]
          The RPC endpoint [env: ETH_RPC_URL=]
          JWT Secret for the RPC endpoint [env: ETH_RPC_JWT_SECRET=]
          The Etherscan (or equivalent) API key [env: ETHERSCAN_API_KEY=]
          The chain name or EIP-155 chain ID [env: CHAIN=]
          The sender account [env: ETH_FROM=]
          Use the keystore in the given folder or file [env: ETH_KEYSTORE=]
          (~/.foundry/keystores) by its filename [env: ETH_KEYSTORE_ACCOUNT=]
          The keystore password file path [env: ETH_PASSWORD=]
          The verifier URL, if using a custom provider [env: VERIFIER_URL=]
```

对于以上诸多配置可以在项目的根目录下创建文件`.env`并将一些配置配置进去入下：

```
CHAIN=11155111
ETH_RPC_URL=https://ethereum-sepolia-rpc.publicnode.com //可从chainlink上查询
ETH_FROM=0x7bcd32f7c439fab6125868e34363221067902e2f
ETH_KEYSTORE_ACCOUNT=testWallet
```

之后输入`source .env `使得配置文件生效。


##  Anvil 使用

`anvil`命令创建一个本地开发网节点，用于部署和测试智能合约,具体详情可参考[anvil文档](https://book.getfoundry.sh/anvil/?highlight=anvil#how-to-use-anvil)。它也可以用来分叉其他与`EVM`兼容的网络。运行`anvil`效果如下：

```
> anvil
                             _   _
                            (_) | |
      __ _   _ __   __   __  _  | |
     / _` | | '_ \  \ \ / / | | | |
    | (_| | | | | |  \ V /  | | | |
     \__,_| |_| |_|   \_/   |_| |_|

    0.1.0 (1d9a34e 2023-03-07T00:07:41.730822Z)
    https://github.com/foundry-rs/foundry

Available Accounts
==================

(0) "
" (10000 ETH)
(1) "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" (10000 ETH)
....

Private Keys
==================

(0) 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
(1) 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
....

Wallet
==================
Mnemonic:          test test test test test test test test test test test junk
Derivation path:   m/44'/60'/0'/0/


Base Fee
==================

1000000000

Gas Limit
==================

30000000

Genesis Timestamp
==================

1678704146

Listening on 127.0.0.1:8545
```
anvil 命令常用到的功能选项有：

- 设置节点端口
```
anvil --port <PORT>
```

- 使用自定义助记词

```
anvil --mnemonic=<MNEMONIC> 
```

- 从节点URL（需要是存档节点）fork 区块链状态，可以指定某个区块时的状态。
```
anvil --fork-url=$RPC --fork-block-number=<BLOCK>
```
anvil完整的功能选项可参考[文档](https://learnblockchain.cn/docs/foundry/i18n/zh/reference/anvil/index.html#%E9%80%89%E9%A1%B9)

**注意：**在使用`anvil`时，原配置账号在本地节点可能没有钱，那就需要`cast send -i --rpc-url 127.0.0.1:8545  --value 2ether  0x7bcd3xxxxxxxxxxxx(.env环境中配置的地址)`而且在与本地节点交互的时候注意之前的`.env`的配置

## 代码验证
### 通过ethersacn进行开源验证

- 浏览器验证
   需要在vscode中最上点击`flatten`将文件扁平化，也可使用命令`forge flatten ./src/xxx.sol`生成，将文件内容复制到验证的文本框里

- foundry验证
    使用命令`forge v contract_address  contract_name`,需要在`.env`中配置`ETHERSCAN_API_KEY`,api key可通过etherscan获取

- 脚本验证
    在项目的`script`目录下创建`xxx.s.sol`文件，基本内容如下：
  
```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract CounterScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        Counter cunt = new Counter();
        console.log("Counter address:",address(cunt));
        //可多个合约进行创建
        //互相操作并进行结果校验        vm.stopBroadcast();
    }
}

```  

使用命令`forge script --rpc-url xxxx (本地节点) --private-key 0xxxxxxxx ./script/xxx.s.sol --broadcast(不带有broadcast命令是仅模拟不广播)`

### Cast 与合约交互使用 

`cast`命令可以用来和区块链交互，因此可以直接使用 cast 在命令行中调用合约。
例如 :

- `cast call` 来调用`counter()`方法

```
            //被调用合约的地址
> cast call 0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0 "counter()" --rpc-url local
0x0000000000000000000000000000000000000000000000000000000000000000
```

- 使用`cast send`调用`setNumber(uint256)`方法，发起一个交易:

```
            //被调用合约的地址                            //方法名   调用的函数有参数，则直接写在函数的后面
> cast send 0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0 "setNumber(uint256)" 1 --rpc-url local --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

blockHash               0x9311823387753f28f47a5c87357e6207b13b223bd3afca5c1f1b31a5e4f8e400
blockNumber             1
contractAddress
cumulativeGasUsed       21204
effectiveGasPrice       4000000000
gasUsed                 21204
logs                    []
logsBloom               0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
root
status                  1
transactionHash         0x5c74da477ce3922337037d0e153fb99f9b325b49f2bf199a487ddb965f6d1727
transactionIndex        0
type                    2
```

- 获取账号的余额（返回 Wei 为单位）：

```
cast balance 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
9999999222505911124404
```
`cast` 命令功能非常多，更多参考[文档](https://learnblockchain.cn/docs/foundry/i18n/zh/reference/cast/cast.html)

### 使用 npm 安装库
使用NPM来安装库，也同样可以支持，在项目根目录下初始化项目，并安装库:

```
npm init -y
npm install @openzeppelin/contracts 
```
安装完成之后，把node_modules文件夹 配置在 foundry.toml 的 libs中：

```
[profile.default]
src = 'src'
out = 'out'
libs = ['lib','node_modules']
```

### 标准库

标准库封装了很多好好的方法可以直接使用，分为4个部分：
 
 - `Vm.sol`：提供作弊码（Cheatcodes）
 - `console.sol` 和 `console2.sol`：Hardhat 风格的日志记录功能，`console2.sol`包含 `console.sol` 的补丁，允许Forge 解码对控制台的调用追踪，但它与 Hardhat 不兼容。
 - `Script.sol`：[Solidity](https://learnblockchain.cn/docs/foundry/i18n/zh/tutorials/solidity-scripting.html) 脚本 的基本实用程序
 - `Test.sol`：DSTest 的超集，包含标准库、作弊码实例 (vm) 和 Foundry 控制台

介绍几个常用的作弊码：

1.`vm.startPrank(address)`来模拟用户，在`startPrank`之后的调用使用设置的地址作为`msg.sender`直到`stopPrank`被调用。
示例：

```
address owner = address(0x123);
// 模拟owner
vm.startPrank(owner);

erc20.transfer(0x...., 1);  //  从bob 账号转出
erc20.mint(100);
....

// 结束模拟
vm.stopPrank();
```
如果只有一个调用需要模拟可以使用 `prank(address)`

2.`warp(uint256)`设置区块时间，可以用来测试时间的流逝。

```
vm.warp(1641070800);
emit log_uint(block.timestamp); // 1641070800
```

3.`roll(uint256)`设置区块

```
vm.roll(100);
emit log_uint(block.number); // 100
```

