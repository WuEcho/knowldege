#JSON RPC API Reference

### PDX 专属
- eth_getLocalMinerRewardAddress: 获取本节点奖励地址
- eth_getTotalAmountOfHypothecationWithAddress: 查询相关地址质押的全部金额
- eth_getNodeActivityInfoForAddress: 查询给定地址的活跃度信息
- eth_getHypothecationSuccessfulAddress: 获取质押成功的地址
- eth_getAmountofHypothecation: 查询当前进入共识委员会需要的质押金为多少
- eth_getCurrentQuorumSize: 查询共识委员会数量
- eth_getConsensusQuorum: 查询当前共识委员会成员
- eth_getAddressIsInQuorum: 查询给定地址是否在共识委员会中
- eth_getNodeStatus: 查询给定地址的节点状态
- eth_getCurrentCommitHeight: 查询当前commit块的高度
- eth_getNodeDisqualifiedReason: 查询节点被剔除共识委员会原因
- eth_getCommitBlockByNormalBlockHash: 通过普通区块的哈希查找对应的commit区块
- eth_getCommitBlockByNormalBlockNumber: 通过普通区块的区块号查找对应的commit区块
- eth_getNodeUselessActiveInfoByAddress: 查询给定地址的节点的无效活跃度信息(主要用于尚未加入到共识委员会但是已经加入到网络当中的节点的活跃度情况)
- eth_blockCommitNumber: 查询当前commit区块的区块号
- eth_getCommitBlockByNumber: 通过区块号查找对应的commit区块
- eth_currentCommitHash: 查询当前commit区块的哈希
- eth_getCommitBlockByHash: 通过区块哈希查找对应的commit区块
- eth_getErrorInfoFromTxHash: 通过交易哈希查询执行失败的原因

##eth_getConsensusQuorum - 查询当前共识委员会成员

###API调用

```
POST /api
```

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    
###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getConsensusQuorum","params":[],"id":739}'
```
返回结果如下：

```
 {"jsonrpc":"2.0","id":123,"result":["0xb28098Faa03770F37036C6b5b89d84733edf7EA9"]}
```

##eth_currentCommitHash - 查询当前commit区块的哈希

###API调用

```
POST /api
```

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - string 区块哈希(字符串形式)

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_currentCommitHash","params":[],"id":738}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 738,
    "result": "0x181880d5255b290dbd20a5f81cf249234e315f84fc119f297fb6a1d4d2d9f423"
}
```

   ##eth_getCommitBlockByHash  -  通过区块哈希查找对应的commit区块

###API调用

```
POST  /api
```

参数:

-  32byte  commit区块哈希

###API返回结果
返回结果为一个JSON对象，主要字段如下：

-  jsonrpc：RPC版本号，2.0
-  id：RPC请求编号
-  result：调用结果
    - hash: 区块哈希
    - number: 区块号
    - parentHash: 前一区块哈希
    - size: 区块大小
    - timestamp: 时间戳
    - extraData: 额外信息
  		            
###示例代码
以curl为例的调用代码如下：

```
$  curl    -H  "Content-Type:application/json"  -X  POST  --data  '{"jsonrpc":"2.0","method":"eth_getCommitBlockByHash","params":["0x3f6df788f0693baa2c5682c6830dfcf978ce7fe7aad77fc3c6d0134cd20bc6a5"],"id":738}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 738,
    "result": {
        "extraData": "0xf902deb8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b801ab841aab9f76885b3a6c45476df1ba2543e0590842d4a9fe8c3a4e25994662efac042372228e3337f58338980c9b9f51159d8be39e234827d874c12c80e3827d17ca80180808080b9024df9024a81faf9014aa06dc385877edf995d3bc66b323a8779f019e3c1f22c7e6f9c784b4402cfd0df04a022c934bdb2d2293b4c2ca8a19f4a4b820d104b30a92afbad318897d5549e6f28a021b2c00d8ad4ab6c2fc3b6e439f31f8b763d577e3fcc44dedc148ad5d3be4502a0523bb3fa57052de5efd7b18773b3794efaaeec992213af9a6eb23ad38ce3a4b0a09f24fdf2c1c79777326ac7f9c7775d4b540f7ef4489409ee1e36d5b897635680a03b9bfb95e7432b8401c7ebfad4c0adb11d2e79fede064a322502947a418e4aefa028b60039874cdf3a4137564a9e63a2a0a544285ac672d9600284b6d17a48424ea00b61fac91cdb470c0fcbdaefdd5f04d725f173d184a965f52e7bf7460d7b8e8da0839c2b5311937e3ed5e95743501fd31919cbb9258c9823a8d3b5767103e1040fa0abc2dc7f383236c1ef6b4508bf9f02e832fd15fd8a591d0f66ac753e469d8bd1f8aaf8a8b8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b80c0a045b7d827400ee553c9f66ddc1308c52715cd7201e6530385024013b22fffdd9cb84189f4bc004cb5783902a90de143b8831c396022421d9cd72e821bf2914668647352d191c67c6de825a25faf4e684eb5de4eeaeb2003a11325921e64bb468226e200c0c0c0c080808019b84031613134393063376662336166373430353539306437326531653639613435663831363237356536326663383430316564666664636566363732393766636435c3c0808080808080",
        "hash": "0x3f6df788f0693baa2c5682c6830dfcf978ce7fe7aad77fc3c6d0134cd20bc6a5",
        "number": "0x1a",
        "parentHash": "0x45b7d827400ee553c9f66ddc1308c52715cd7201e6530385024013b22fffdd9c",
        "size": "0x53d",
        "timestamp": "0x5ef1c3b5"
    }
}
```


##eth_getCommitBlockByNumber - 通过区块号查找对应的commit区块

###API调用

```
POST /api
```

参数:

- int64 区块号

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
  详细情况请查看eth_getCommitBlockByHash
###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getCommitBlockByNumber","params":[”0x1a“],"id":738}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 738,
    "result": {
        "extraData": "0xf902deb8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b801ab841aab9f76885b3a6c45476df1ba2543e0590842d4a9fe8c3a4e25994662efac042372228e3337f58338980c9b9f51159d8be39e234827d874c12c80e3827d17ca80180808080b9024df9024a81faf9014aa06dc385877edf995d3bc66b323a8779f019e3c1f22c7e6f9c784b4402cfd0df04a022c934bdb2d2293b4c2ca8a19f4a4b820d104b30a92afbad318897d5549e6f28a021b2c00d8ad4ab6c2fc3b6e439f31f8b763d577e3fcc44dedc148ad5d3be4502a0523bb3fa57052de5efd7b18773b3794efaaeec992213af9a6eb23ad38ce3a4b0a09f24fdf2c1c79777326ac7f9c7775d4b540f7ef4489409ee1e36d5b897635680a03b9bfb95e7432b8401c7ebfad4c0adb11d2e79fede064a322502947a418e4aefa028b60039874cdf3a4137564a9e63a2a0a544285ac672d9600284b6d17a48424ea00b61fac91cdb470c0fcbdaefdd5f04d725f173d184a965f52e7bf7460d7b8e8da0839c2b5311937e3ed5e95743501fd31919cbb9258c9823a8d3b5767103e1040fa0abc2dc7f383236c1ef6b4508bf9f02e832fd15fd8a591d0f66ac753e469d8bd1f8aaf8a8b8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b80c0a045b7d827400ee553c9f66ddc1308c52715cd7201e6530385024013b22fffdd9cb84189f4bc004cb5783902a90de143b8831c396022421d9cd72e821bf2914668647352d191c67c6de825a25faf4e684eb5de4eeaeb2003a11325921e64bb468226e200c0c0c0c080808019b84031613134393063376662336166373430353539306437326531653639613435663831363237356536326663383430316564666664636566363732393766636435c3c0808080808080",
        "hash": "0x3f6df788f0693baa2c5682c6830dfcf978ce7fe7aad77fc3c6d0134cd20bc6a5",
        "number": "0x1a",
        "parentHash": "0x45b7d827400ee553c9f66ddc1308c52715cd7201e6530385024013b22fffdd9c",
        "size": "0x53d",
        "timestamp": "0x5ef1c3b5"
    }
}
```

##eth_getNodeUselessActiveInfoByAddress - 查询给定地址的节点的无效活跃度信息(主要用于尚未加入到共识委员会但是已经加入到网络当中的节点的活跃度情况)

###API调用

```
POST /api
```

参数:

- 20byte  查询地址

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getNodeUselessActiveInfoByAddress","params":[”0x44fee6160987f550c35c126d7801af444b10264e8dfa8f53038e3d7a3cd2049a“],"id":123}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 123,
    "result": 13
}
```

##eth_blockCommitNumber - 查询当前commit区块的区块号

###API调用

```
POST /api
```

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - uint64 区块号  

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockCommitNumber","params":[],"id":123}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 123,
    "result": "0x289" //649
}
```

##eth_getCommitBlockByNumber - 通过区块号查找对应的commit区块

###API调用

```
POST /api
```
参数:

- int64 区块号

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    详细情况请查看eth_getCommitBlockByHash
###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getCommitBlockByNumber","params":["0x8"],"id":738}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 738,
    "result": {
        "extraData": "0xf902deb8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b801ab841aab9f76885b3a6c45476df1ba2543e0590842d4a9fe8c3a4e25994662efac042372228e3337f58338980c9b9f51159d8be39e234827d874c12c80e3827d17ca80180808080b9024df9024a81faf9014aa06dc385877edf995d3bc66b323a8779f019e3c1f22c7e6f9c784b4402cfd0df04a022c934bdb2d2293b4c2ca8a19f4a4b820d104b30a92afbad318897d5549e6f28a021b2c00d8ad4ab6c2fc3b6e439f31f8b763d577e3fcc44dedc148ad5d3be4502a0523bb3fa57052de5efd7b18773b3794efaaeec992213af9a6eb23ad38ce3a4b0a09f24fdf2c1c79777326ac7f9c7775d4b540f7ef4489409ee1e36d5b897635680a03b9bfb95e7432b8401c7ebfad4c0adb11d2e79fede064a322502947a418e4aefa028b60039874cdf3a4137564a9e63a2a0a544285ac672d9600284b6d17a48424ea00b61fac91cdb470c0fcbdaefdd5f04d725f173d184a965f52e7bf7460d7b8e8da0839c2b5311937e3ed5e95743501fd31919cbb9258c9823a8d3b5767103e1040fa0abc2dc7f383236c1ef6b4508bf9f02e832fd15fd8a591d0f66ac753e469d8bd1f8aaf8a8b8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b80c0a045b7d827400ee553c9f66ddc1308c52715cd7201e6530385024013b22fffdd9cb84189f4bc004cb5783902a90de143b8831c396022421d9cd72e821bf2914668647352d191c67c6de825a25faf4e684eb5de4eeaeb2003a11325921e64bb468226e200c0c0c0c080808019b84031613134393063376662336166373430353539306437326531653639613435663831363237356536326663383430316564666664636566363732393766636435c3c0808080808080",
        "hash": "0xa4b744c405ce57635d069c3901fec3e7921321e5bb9a7191112327fab34218e8",
        "number": "0x8",
        "parentHash": "0x686b6ca214bd02776e61a234162a3b30255126091b04779350013d536f2dccbd",
        "size": "0x5e7",
        "timestamp": "0x5ef175e4"
    }
}
```

##eth_getCommitBlockByNormalBlockHash - 通过普通区块的哈希查找对应的commit区块

###API调用

```
POST /api
```

参数:

- 32byte 普通区块哈希

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    详细情况请查看eth_getCommitBlockByHash
###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getCommitBlockByNormalBlockHash","params":[”0x6fd6d365acaf854d8d1be8fe91e5ae5cda5018ca71a8fd3b212425392e500a0a“],"id":738}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 738,
    "result": {
        "extraData": "0xf902deb8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b801ab841aab9f76885b3a6c45476df1ba2543e0590842d4a9fe8c3a4e25994662efac042372228e3337f58338980c9b9f51159d8be39e234827d874c12c80e3827d17ca80180808080b9024df9024a81faf9014aa06dc385877edf995d3bc66b323a8779f019e3c1f22c7e6f9c784b4402cfd0df04a022c934bdb2d2293b4c2ca8a19f4a4b820d104b30a92afbad318897d5549e6f28a021b2c00d8ad4ab6c2fc3b6e439f31f8b763d577e3fcc44dedc148ad5d3be4502a0523bb3fa57052de5efd7b18773b3794efaaeec992213af9a6eb23ad38ce3a4b0a09f24fdf2c1c79777326ac7f9c7775d4b540f7ef4489409ee1e36d5b897635680a03b9bfb95e7432b8401c7ebfad4c0adb11d2e79fede064a322502947a418e4aefa028b60039874cdf3a4137564a9e63a2a0a544285ac672d9600284b6d17a48424ea00b61fac91cdb470c0fcbdaefdd5f04d725f173d184a965f52e7bf7460d7b8e8da0839c2b5311937e3ed5e95743501fd31919cbb9258c9823a8d3b5767103e1040fa0abc2dc7f383236c1ef6b4508bf9f02e832fd15fd8a591d0f66ac753e469d8bd1f8aaf8a8b8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b80c0a045b7d827400ee553c9f66ddc1308c52715cd7201e6530385024013b22fffdd9cb84189f4bc004cb5783902a90de143b8831c396022421d9cd72e821bf2914668647352d191c67c6de825a25faf4e684eb5de4eeaeb2003a11325921e64bb468226e200c0c0c0c080808019b84031613134393063376662336166373430353539306437326531653639613435663831363237356536326663383430316564666664636566363732393766636435c3c0808080808080",
        "hash": "0x3f6df788f0693baa2c5682c6830dfcf978ce7fe7aad77fc3c6d0134cd20bc6a5",
        "number": "0x1a",
        "parentHash": "0x45b7d827400ee553c9f66ddc1308c52715cd7201e6530385024013b22fffdd9c",
        "size": "0x53d",
        "timestamp": "0x5ef1c3b5"
    }
}
```

##eth_getCommitBlockByNormalBlockNumber - 通过普通区块的区块号查找对应的commit区块

###API调用

```
POST /api
```

参数:

-int 区块号 

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    详细情况请查看eth_getCommitBlockByHash
###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '
{"jsonrpc":"2.0","method":"eth_getCommitBlockByNormalBlockNumber","params":["0x40"//64],"id":738}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 738,
    "result": {
        "extraData": "0xf902deb8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b801ab841aab9f76885b3a6c45476df1ba2543e0590842d4a9fe8c3a4e25994662efac042372228e3337f58338980c9b9f51159d8be39e234827d874c12c80e3827d17ca80180808080b9024df9024a81faf9014aa06dc385877edf995d3bc66b323a8779f019e3c1f22c7e6f9c784b4402cfd0df04a022c934bdb2d2293b4c2ca8a19f4a4b820d104b30a92afbad318897d5549e6f28a021b2c00d8ad4ab6c2fc3b6e439f31f8b763d577e3fcc44dedc148ad5d3be4502a0523bb3fa57052de5efd7b18773b3794efaaeec992213af9a6eb23ad38ce3a4b0a09f24fdf2c1c79777326ac7f9c7775d4b540f7ef4489409ee1e36d5b897635680a03b9bfb95e7432b8401c7ebfad4c0adb11d2e79fede064a322502947a418e4aefa028b60039874cdf3a4137564a9e63a2a0a544285ac672d9600284b6d17a48424ea00b61fac91cdb470c0fcbdaefdd5f04d725f173d184a965f52e7bf7460d7b8e8da0839c2b5311937e3ed5e95743501fd31919cbb9258c9823a8d3b5767103e1040fa0abc2dc7f383236c1ef6b4508bf9f02e832fd15fd8a591d0f66ac753e469d8bd1f8aaf8a8b8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b80c0a045b7d827400ee553c9f66ddc1308c52715cd7201e6530385024013b22fffdd9cb84189f4bc004cb5783902a90de143b8831c396022421d9cd72e821bf2914668647352d191c67c6de825a25faf4e684eb5de4eeaeb2003a11325921e64bb468226e200c0c0c0c080808019b84031613134393063376662336166373430353539306437326531653639613435663831363237356536326663383430316564666664636566363732393766636435c3c0808080808080",
        "hash": "0x686b6ca214bd02776e61a234162a3b30255126091b04779350013d536f2dccbd",
        "number": "0x7",
        "parentHash": "0x646531034596dfc0cbe0f8dd128dc3fcf564f707d4ea9385600445512821c51b",
        "size": "0x5e7",
        "timestamp": "0x5ef175d6"
    }
}
```

##eth_getLocalMinerRewardAddress - 获取本节点奖励地址

###API调用

```
POST /api
```

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getLocalMinerRewardAddress","params":[],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":"0x7efe6e4aec16d0157c319c1f1a785aec81c7ae75"}
```

##eth_getTotalAmountOfHypothecationWithAddress - 查询给定账户地址节点的总质押金 

###API调用

```
POST /api
```
参数:

- address 查询地址

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getTotalAmountOfHypothecationWithAddress","params":["0xE05e11D6272Af1A13f184326dadF4079Cfa8c31d"],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":"30000000000000"}
```


##eth_getNodeActivityInfoForAddress - 查询给定账户地址节点的活跃度信息 

###API调用

```
POST /api
```
参数:

- address 查询地址

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getNodeActivityInfoForAddress","params":["0xE05e11D6272Af1A13f184326dadF4079Cfa8c31d"],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":"30"}
```

##eth_getHypothecationSuccessfulAddress - 获取质押成功的地址

###API调用

```
POST /api
```

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getHypothecationSuccessfulAddress","params":[],"id":738}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 738,
    "result": ["0x41b84E81Ba73ab6910ac9b2038d6F18C15a05367","0x0297545eCb2686062fF91D187bf21CDdE63ca28B"]
}
```

##eth_getAmountofHypothecation - 查询当前进入到共识委员会所需要的质押金额

###API调用

```
POST /api
```
参数：
  无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getAmountofHypothecation","params":[],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":"300000000000"}
```


##eth_getCurrentQuorumSize - 查询当前委员会成员数量

###API调用

```
POST /api
```
参数：无

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getCurrentQuorumSize","params":[],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":"30"}
```

##eth_getAddressIsInQuorum - 查询给定地址是否在委员会中 
###API调用

```
POST /api
```
参数:

- address 查询地址
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getAddressIsInQuorum","params":["0xb28098Faa03770F37036C6b5b89d84733edf7EA9"],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":ture}
```

##eth_getNodeStatus - 查询给定地址的节点状态

###API调用

```
POST /api
```
参数:

- address 查询地址

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    -int:  1:没质押也不在线;  2:质押了但不在线;  3:质押了但是活跃度不够;  4:质押了活跃度也够了只是还没生效;  5:在共识委员会中;  6:已退出共识委员会可以退出质押;  7:需要被惩罚;  8:已被惩罚  

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getNodeStatus","params":["0xb28098Faa03770F37036C6b5b89d84733edf7EA9"],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":1}
```

##eth_getCurrentCommitHeight - 查询当前commit块的高度

###API调用

```
POST /api
```
参数：
   无
   
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getCurrentCommitHeight","params":[],"id":739}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":105}
```

##eth_getNodeDisqualifiedReason - 查询节点被剔除共识委员会原因

###API调用

```
POST /api
```

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
  - string  节点失效原因  
    Activity is not enough to be removed.Should hypothecation again 活跃度不足,需重新质押
    Exit on his own initiative.Should hypothecation again         主动退出,需重新质押
    Multiple signatures.Should hypothecation again                多签剔除,需重新质押
    Exception storage penalty.Should not hypothecation again    异常存储剔除,无需重新质押
                        

###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getNodeDisqualifiedReason","params":["0xb28098Faa03770F37036C6b5b89d84733edf7EA9"],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":"Activity is not enough to be removed.Should hypothecation again"}
```


##eth_getErrorInfoFormTxHash - 通过交易哈希查询执行失败的原因

###API调用

```
POST /api
```

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    
###示例代码
以curl为例的调用代码如下：

```
$ curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getErrorInfoFormTxHash","params":["0xc86a67214eb624dc1be25637a16371f7872326de8f73ed1ee20221762fc0ff47"],"id":739}'
```
返回结果如下：

```
 {"jsonrpc":"2.0","id":123,"result":["contract run error with reason:xxxxxxxxxxxx"]}
```



### 网络相关
- net_version: 查询当前节点的网络id
- net_listening: 查询客户端监听网络连接是否活跃
- net_peerCount: 查询当前客户端链接的节点

##net_version - 查询当前节点的网络id
###API调用

```
POST /api
```
参数:
无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - int 版本号 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":"739"}
```

##net_listening - 查询客户端监听网络连接是否活跃

###API调用

```
POST /api
```
参数:
无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - Boolean 监听中为true 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_listening","params":[],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":true}
```

##net_peerCount - 查询当前客户端链接的节点
###API调用

```
POST /api
```
参数:
无

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - int  链接的节点数量

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":0x0}
```


### 节点相关
    
- eth_protocolVersion: 查询当前的协议版本号 
- eth_syncing: 查询同步状态与否
- eth_coinbase: 查询客户端的账户地址
- eth_mining: 查询客户端是否在活跃打块
- eth_gasPrice: 查询当前gas的消耗
- eth_accounts: 查询当前客户端拥有的账户列表


##eth_protocolVersion - 查询当前的协议版本号

###API调用

```
POST /api
```
参数:
无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_protocolVersion","params":[],"id":739}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0x54"
}
```
##eth_syncing - 查询同步状态与否

###API调用

```
POST /api
```
参数:
无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - Boolean: 在同步则返回ture
    - startingBlock: 开始的区块
    - currentBlock: 当前区块
    - highestBlock: 最高的区块

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":739}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": {
    startingBlock: '0x384',
    currentBlock: '0x386',
    highestBlock: '0x454'
  }
}
// Or when not syncing
{
  "id":739,
  "jsonrpc": "2.0",
  "result": false
}
```
##eth_coinbase - 查询客户端的账户地址

###API调用

```
POST /api
```
参数:
无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - bytes 当前账户地址 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_coinbase","params":[],"id":739}' 
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0xc94770007dda54cF92009BFF0dE90c06F603a09f"
}
```
##eth_mining - 查询客户端是否在活跃打块

###API调用

```
POST /api
```
参数:
无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - Boolean  挖矿中为true，其他为false 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_mining","params":[],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":true}
```

##eth_gasPrice - 查询当前gas的消耗

###API调用

```
POST /api
```
参数:
无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果，查询的
    - int 当前gas价格 单位是wei 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_gasPrice","params":[],"id":123}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":123,"result":"0x09184e72a000" // 10000000000000}
```
##eth_accounts - 查询当前客户端拥有的账户列表

###API调用

```
POST /api
```
参数:
无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - 20Bytes				客户端的地址集合 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":123}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": ["0xc94770007dda54cF92009BFF0dE90c06F603a09f"]
}
```


### 区块相关
- eth_blockNumber: 查询最近的区块
- eth_getBalance: 查询当前需要查询的账户余额
- eth_getStorageAt: 查询给定地址的存储位置返回值
- eth_getTransactionCount: 查询发送到给定地址的交易量
- eth_getBlockTransactionCountByHash: 查询给定区块哈希对应的区块号中包含的交易
- eth_getBlockTransactionCountByNumber: 查询给定区块号对应的区块号中包含的交易
- eth_getCode: 查询给定地址的编码
- eth_sign: 将信息通过以太坊特定的签名算法签名
- eth_sendTransaction: 根据传入的参数创建交易，签名，提交到交易池
- eth_sendRawTransaction: 将签名后的交易添加进入交易池
- eth_call: 执行一个链上没有的交易
- eth_getBlockByHash: 通过区块哈希查询区块
- eth_getTransactionByBlockHashAndIndex: 根据区块哈希和交易序列查询交易
- eth_getTransactionByBlockNumberAndIndex: 根据区块区块号和交易序列查询交易
- eth_getTransactionReceipt: 通过交易哈希查询交易的收据
- eth_getTransactionByHash: 通过交易哈希获取交易
- eth_allPendingTransactions: 查询所有处于pending状态的交易列表
- eth_pendingTransactions: 查询处于pending状态，且是钱包内地址所发送的交易列表
- eth_getBlockByNumber: 通过普通区块的区块号查找对应的普通区块

##eth_getBlockByNumber - 通过普通区块的区块号查找对应的普通区块

###API调用

```
POST /api
```
参数：
  
  - int 区块号

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    详细情况查看eth_getBlockByHash
###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["0x103",false],"id":738}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 738,
    "result": {
        "difficulty": "0x400",
	     "commitNumber": "0x19",
        "extraData": "0xf84db8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b801a808080808080808080",
        "gasLimit": "0x4dd30d2",
        "gasUsed": "0x0",
        "hash": "0x6fd6d365acaf854d8d1be8fe91e5ae5cda5018ca71a8fd3b212425392e500a0a",
        "logsBloom": "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "miner": "0xe05e11d6272af1a13f184326dadf4079cfa8c31d",
        "nonce": "0x0000000000000000",
        "number": "0x103",
        "parentHash": "0x6c25b2a403138cb287e6a622f8e6ee100d4f4bfbbbc4dceac4ba185558456be4",
        "receiptsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
        "rewardAddr": "0xe05e11d6272af1a13f184326dadf4079cfa8c31d",
        "size": "0x2ab",
        "stateRoot": "0x46e226056cea1582d326b7ebac9e6db1e72e46c4560328e207f6334685d728b0",
        "timestamp": "0x5ef1c3c0",
        "totalDifficulty": "0x41c00",
        "transactions": [],
        "transactionsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421"
    }
}
```

##eth_sign - 将信息通过以太坊特定的签名算法签名

###API调用

```
POST /api
```
参数：
  
  - 20Byte 地址
  - N Byte  需要签名的信息

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - 签名数据 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_sign","params":["0x9b2055d370f73ec7d8a03e965129118dc8f5bf83", "0xdeadbeaf"],"id":1}'
```
返回结果如下：

```
{
  "id":1,
  "jsonrpc": "2.0",
  "result": "0xa3f20717a250c2b0b729b7e5becbff67fdaef7e0699da4de7ca5895b02a170a12d887fd3b17bfdce3481f10bea41f45ba9f709d39ce8325427b57afcfc994cee1b"
}
```

##eth_getCode - 将信息通过以太坊特定的签名算法签名
###API调用

```
POST /api
```
参数：
  
  - 20Byte 地址
  - int/string  区块号或"latest","earliest","pending"

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - 从给定地址的代码 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getCode","params":["0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b"],"id":739}'
```
返回结果如下：

```
{
  "id":83,
  "jsonrpc": "2.0",
  "result": "0x600160008035811a818181146012578301005b601b6001356025565b8060005260206000f25b600060078202905091905056" 
}
```


##eth_getCode - 查询给定地址的编码
###API调用

```
POST /api
```
参数：
  
  - 20Byte 地址
  - int/string  区块号或"latest","earliest","pending"

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - 从给定地址的代码 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getCode","params":["0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b"],"id":739}'
```
返回结果如下：

```
{
  "id":83,
  "jsonrpc": "2.0",
  "result": "0x600160008035811a818181146012578301005b601b6001356025565b8060005260206000f25b600060078202905091905056" 
}
```


##eth_blockNumber - 查询最近的区块
###API调用

```
POST /api
```
参数：
  无

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - int 当前区块号 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":739}'
```
返回结果如下：

```
{
  "id":83,
  "jsonrpc": "2.0",
  "result": "0xc94" // 1207
}
```

##eth_allPendingTransactions - 查询所有处于pending状态的交易列表
###API调用

```
POST /api
```
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - array: pending交易的列表 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_allPendingTransactions","params":[],"id":739}'
```
返回结果如下：

```
{"jsonrpc":"2.0","id":739,"result":[{"blockHash":"0x0000000000000000000000000000000000000000000000000000000000000000","blockNumber":null,"from":"0x42495a0d681896c3ab8a93e14e9ec6f84509b820","gas":"0xfde8","gasPrice":"0x5af3107a4000","hash":"0xbf6c170b20e1041b9a35015e9c900a4a7620f3c7b84862f9e5aeb60a36be1bcc","input":"0x080112bd04123c0a3732333735373433612d656662612d343033352d613631642d303935616465333737346638383631303139343132504d4b524a53504d444c1201311a140a0f5044585f534146455f414354494f4e1201001ae6030a0e5044585f534146455f415554485a12d30365794a68624763694f694a46557a49314e694973496e523563434936496b705856434a392e65794a68496a6f6951794973496d4672496a6f694d444e6c593255314e7a5534597a4d354d575133595463774d4441345a544a6c4d544e69597a51334d4755794e544132596a526a596d45354f44466d4d7a4a6c4e7a59794e4449334e446b324f4446694f544d785a574978496977695a434936496a497a4e7a55334e444e684c57566d596d45744e44417a4e5331684e6a466b4c5441354e57466b5a544d334e7a526d4f4467324d5441694c434a6d496a6f784e6a51774e5463774e5441314c434a72496a6f694969776962694936496a45694c434a7a496a6f784d6a4d73496e4e72496a6f694d444e6c593255314e7a5534597a4d354d575133595463774d4441345a544a6c4d544e69597a51334d4755794e544132596a526a596d45354f44466d4d7a4a6c4e7a59794e4449334e446b324f4446694f544d785a57497849697769644349364d6a59304d4455334d4455774e58302e716953507454785a4e74795041384137674e66344a6b74786d78556b49627a76396b7835376a49554955704c545370674a38454e643357797176362d397a67647a636b43346661475863757371546d4d494e6b564151","nonce":"0x4bd4","to":"0x6e7bd301dbddfbc8f0bbae0da35135f46805061e","transactionIndex":"0x0","value":"0x0","v":"0x62e","r":"0x588d088cb3674897526f4593313d959af1bbb2666ebb1281278ffef82dcec05e","s":"0x57031068dbc9d5d5fcf5cb6e724a76f7a68865dc505ce3f2727b631715666523"},{"blockHash":"0x0000000000000000000000000000000000000000000000000000000000000000","blockNumber":null,"from":"0x42495a0d681896c3ab8a93e14e9ec6f84509b820","gas":"0xfde8","gasPrice":"0x5af3107a4000","hash":"0xa3897950ec6690ae06fea16f53fb775a4137054322ed12922795d2857bd6f3b9","input":"0x080112bd04123c0a3732333735373433612d656662612d343033352d613631642d30393561646533373734663838363130313934313350505146584b494e4a561201311a140a0f5044585f534146455f414354494f4e1201001ae6030a0e5044585f534146455f415554485a12d30365794a68624763694f694a46557a49314e694973496e523563434936496b705856434a392e65794a68496a6f6951794973496d4672496a6f694d444e6c593255314e7a5534597a4d354d575133595463774d4441345a544a6c4d544e69597a51334d4755794e544132596a526a596d45354f44466d4d7a4a6c4e7a59794e4449334e446b324f4446694f544d785a574978496977695a434936496a497a4e7a55334e444e684c57566d596d45744e44417a4e5331684e6a466b4c5441354e57466b5a544d334e7a526d4f4467324d5441694c434a6d496a6f784e6a51774e5463774e5441314c434a72496a6f694969776962694936496a45694c434a7a496a6f784d6a4d73496e4e72496a6f694d444e6c593255314e7a5534597a4d354d575133595463774d4441345a544a6c4d544e69597a51334d4755794e544132596a526a596d45354f44466d4d7a4a6c4e7a59794e4449334e446b324f4446694f544d785a57497849697769644349364d6a59304d4455334d4455774e58302e716953507454785a4e74795041384137674e66344a6b74786d78556b49627a76396b7835376a49554955704c545370674a38454e643357797176362d397a67647a636b43346661475863757371546d4d494e6b564151","nonce":"0x4bd5","to":"0x6e7bd301dbddfbc8f0bbae0da35135f46805061e","transactionIndex":"0x0","value":"0x0","v":"0x62d","r":"0xaa28da2075e01ecc63d8875a11cac241710f909a8cf19c2e9468dd0d3b2cdc7d","s":"0x6e4e46534a7fc5922983b6584d322dd293a7d430bc67ac748ac7bada2716de5e"},{"blockHash":"0x0000000000000000000000000000000000000000000000000000000000000000","blockNumber":null,"from":"0x42495a0d681896c3ab8a93e14e9ec6f84509b820","gas":"0xfde8","gasPrice":"0x5af3107a4000","hash":"0xbb951b0a1d691c681ceead3ba60474b9fcf48d174e13991ee2e5627a630afe2e","input":"0x080112bd04123c0a3732333735373433612d656662612d343033352d613631642d303935616465333737346638383631303139343134515152544d5a5a4951541201311a140a0f5044585f534146455f414354494f4e1201001ae6030a0e5044585f534146455f415554485a12d30365794a68624763694f694a46557a49314e694973496e523563434936496b705856434a392e65794a68496a6f6951794973496d4672496a6f694d444e6c593255314e7a5534597a4d354d575133595463774d4441345a544a6c4d544e69597a51334d4755794e544132596a526a596d45354f44466d4d7a4a6c4e7a59794e4449334e446b324f4446694f544d785a574978496977695a434936496a497a4e7a55334e444e684c57566d596d45744e44417a4e5331684e6a466b4c5441354e57466b5a544d334e7a526d4f4467324d5441694c434a6d496a6f784e6a51774e5463774e5441314c434a72496a6f694969776962694936496a45694c434a7a496a6f784d6a4d73496e4e72496a6f694d444e6c593255314e7a5534597a4d354d575133595463774d4441345a544a6c4d544e69597a51334d4755794e544132596a526a596d45354f44466d4d7a4a6c4e7a59794e4449334e446b324f4446694f544d785a57497849697769644349364d6a59304d4455334d4455774e58302e716953507454785a4e74795041384137674e66344a6b74786d78556b49627a76396b7835376a49554955704c545370674a38454e643357797176362d397a67647a636b43346661475863757371546d4d494e6b564151","nonce":"0x4bd6","to":"0x6e7bd301dbddfbc8f0bbae0da35135f46805061e","transactionIndex":"0x0","value":"0x0","v":"0x62d","r":"0x8d214da0ee314999ff70d87393a62611b2f30100fd69b50c035bb5e6ffc7c5d8","s":"0x39c3faa70b35a192c08512ad22aa2e99f909ca1e8e5cc12820db5b4ce09f1910"},{"blockHash":"0x0000000000000000000000000000000000000000000000000000000000000000","blockNumber":null,"from":"0x42495a0d681896c3ab8a93e14e9ec6f84509b820","gas":"0xfde8","gasPrice":"0x5af3107a4000","hash":"0x3e7fe43a24063ddb0bc0106c3bbcf6a0b800cb530963114b58b20a8da40fb867","input":"0x080112bd04123c0a3732333735373433612d656662612d343033352d613631642d303935616465333737346638383631303139343135484a414e5949514d424f1201311a140a0f5044585f534146455f414354494f4e1201001ae6030a0e5044585f534146455f415554485a12d30365794a68624763694f694a46557a49314e694973496e523563434936496b705856434a392e65794a68496a6f6951794973496d4672496a6f694d444e6c593255314e7a5534597a4d354d575133595463774d4441345a544a6c4d544e69597a51334d4755794e544132596a526a596d45354f44466d4d7a4a6c4e7a59794e4449334e446b324f4446694f544d785a574978496977695a434936496a497a4e7a55334e444e684c57566d596d45744e44417a4e5331684e6a466b4c5441354e57466b5a544d334e7a526d4f4467324d5441694c434a6d496a6f784e6a51774e5463774e5441314c434a72496a6f694969776962694936496a45694c434a7a496a6f784d6a4d73496e4e72496a6f694d444e6c593255314e7a5534597a4d354d575133595463774d4441345a544a6c4d544e69597a51334d4755794e544132596a526a596d45354f44466d4d7a4a6c4e7a59794e4449334e446b324f4446694f544d785a57497849697769644349364d6a59304d4455334d4455774e58302e716953507454785a4e74795041384137674e66344a6b74786d78556b49627a76396b7835376a49554955704c545370674a38454e643357797176362d397a67647a636b43346661475863757371546d4d494e6b564151","nonce":"0x4bd7","to":"0x6e7bd301dbddfbc8f0bbae0da35135f46805061e","transactionIndex":"0x0","value":"0x0","v":"0x62e","r":"0x7240843521b16cea8586a9a3fc524c46cb798517fe720948d468a271403bb91a","s":"0x2ae153f06569a5ade3413ec781b02345f7ddc6df473fde2a10ea9048b08d4a8e"}]}
```

##eth_pendingTransactions - 查询处于pending状态，且是钱包内地址所发送的交易列表
###API调用

```
POST /api
```
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - array: pending交易的列表 

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_pendingTransactions","params":[],"id":739}'
```
返回结果如下：

```
{
"id":739,
"jsonrpc":"2.0",
"result": [{ 
    blockHash: '0x0000000000000000000000000000000000000000000000000000000000000000',
    blockNumber: null,
    from: '0x28bdb9c230f4d5e45435e4d006326ee32e46cb31',
    gas: '0x204734',
    gasPrice: '0x4a817c800',
    hash: '0x8dfa6a59307a490d672494a171feee09db511f05e9c097e098edc2881f9ca4f6',
    input: '0x6080604052600',
    nonce: '0x12',
    to: null,
    transactionIndex: '0x0',
    value: '0x0',
    v: '0x3d',
    r: '0xaabc9ddafffb2ae0bac4107697547d22d9383667d9e97f5409dd6881ce08f13f',
    s: '0x69e43116be8f842dcd4a0b2f760043737a59534430b762317db21d9ac8c5034' 
   },....,{ 
    blockHash: '0x0000000000000000000000000000000000000000000000000000000000000000',
    blockNumber: null,
    from: '0x28bdb9c230f4d5e45435e4d006326ee32e487b31',
    gas: '0x205940',
    gasPrice: '0x4a817c800',
    hash: '0x8e4340ea3983d86e4b6c44249362f716ec9e09849ef9b6e3321140581d2e4dac',
    input: '0xe4b6c4424936',
    nonce: '0x14',
    to: null,
    transactionIndex: '0x0',
    value: '0x0',
    v: '0x3d',
    r: '0x1ec191ef20b0e9628c4397665977cbe7a53a263c04f6f185132b77fa0fd5ca44',
    s: '0x8a58e00c63e05cfeae4f1cf19f05ce82079dc4d5857e2cc281b7797d58b5faf' 
   }]
}
```

##eth_getTransactionByHash - 通过交易哈希获取交易
###API调用

```
POST /api
```
参数:
 - Bytes: 交易哈希

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - blockHash: 包含交易的区块哈希
    - blockNumber: 包含交易的区块号
    - from: 发送者的地址
    - to: 交易接受者
    - gas: 发送者提供的gas
    - gasPrice: 发送者提供的gas价格单位是wei
    - hash: 交易哈希
    - input: 交易的输入
    - nonce: 交易创建者提供的号码
    - transactionIndex: 交易的序列号
    - value: 转账的金额单位是wei
    - v: ECDSA 签名中的v
    - r: ECDSA 签名中的r
    - s: ECDSA 签名中的s

###示例代码
以curl为例的调用代码如下：

```
    $ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionByHash","params":["0x88df016429689c079f3b2f6ad39fa052532c56795b733da78a91ebe6a713944b"],"id":739}'
```
返回结果如下：

```
{
  "jsonrpc":"2.0",
  "id":739,
  "result":{
    "blockHash":"0x1d59ff54b1eb26b013ce3cb5fc9dab3705b415a67127a003c3e61eb445bb8df2",
    "blockNumber":"0x5daf3b", // 6139707
    "from":"0xa7d9ddbe1f17865597fbd27ec712455208b6b76d",
    "gas":"0xc350", // 50000
    "gasPrice":"0x4a817c800", // 20000000000
    "hash":"0x88df016429689c079f3b2f6ad39fa052532c56795b733da78a91ebe6a713944b",
    "input":"0x68656c6c6f21",
    "nonce":"0x15", // 21
    "to":"0xf02c1c8e6114b1dbe8937a39260b5b0a374432bb",
    "transactionIndex":"0x41", // 65
    "value":"0xf3dbb76162000", // 4290000000000000
    "v":"0x25", // 37
    "r":"0x1b5e176d927f8e9ab405058b2d2457392da3e20f328b16ddabcebc33eaac5fea",
    "s":"0x4ba69724e8f69de52f0125ad8b3c5c2cef33019bac3249e2c0a2192766d1721c"
  }
}
```

##eth_getTransactionReceipt - 通过交易哈希查询交易的收据
###API调用

```
POST /api
```
参数:
 - Bytes: 交易哈希

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - transactionHash: 交易哈希
    - transactionIndex: 交易序列
    - blockHash: 包含交易的区块哈希
    - blockNumber: 包含交易的区块号
    - from: 发送者的地址
    - to: 交易接受者
    - cumulativeGasUsed: 交易执行需要的全部gas
    - gasUsed: 特殊交易需要的gas
    - contractAddress: 合约地址
    - logs: 日志的集合
    - logsBloom: 日志过滤器

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"],"id":739}'
```
返回结果如下：

```
{
"id":739,
"jsonrpc":"2.0",
"result": {
     transactionHash: '0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238',
     transactionIndex:  '0x1', // 1
     blockNumber: '0xb', // 11
     blockHash: '0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b',
     cumulativeGasUsed: '0x33bc', // 13244
     gasUsed: '0x4dc', // 1244
     contractAddress: '0xb60e8dd61c5d32be8058bb8eb970870f07233155', // or null, if none was created
     logs: [{
         // logs as returned by getFilterLogs, etc.
     }, ...],
     logsBloom: "0x00...0", // 256 byte bloom filter
     status: '0x1'
  }
}
```

##eth_getTransactionByBlockNumberAndIndex - 根据区块区块号和交易序列查询交易

###API调用

```
POST /api
```
参数:
 - int/string: 区块号，或字符串`"earliest"`, `"latest"`,`"pending"`
 - int: 交易的序列号

###API返回结果
与eth_getTransactionByHash返回值相同

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionByBlockNumberAndIndex","params":["0x29c", "0x0"],"id":739}'
```
返回结果如下：
与eth_getTransactionByHash返回值相同

##eth_getTransactionByBlockHashAndIndex - 根据区块哈希和交易序列查询交易
###API调用

```
POST /api
```
参数:
 - Bytes: 区块哈希
 - int: 交易的序列号

###API返回结果
与eth_getTransactionByHash返回值相同

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionByBlockHashAndIndex","params":["0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b", "0x0"],"id":739}'
```
返回结果如下：
与eth_getTransactionByHash返回值相同

##eth_getBalance - 查询当前需要查询的账户余额
###API调用

```
POST /api
```
参数:
 
 - 20Byte  查询账户的地址
 - Int/string  区块号或者字符串"latest", "earliest", "pending"

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果，查询的
    - int 当前余额单位是wei

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0xE05e11D6272Af1A13f184326dadF4079Cfa8c31d","latest"],"id":739}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0xc94" // 1207
}
```

##eth_getStorageAt - 查询给定地址的存储位置返回值

###API调用

```
POST /api
```
参数:

- address 存储的地址
- int 存储的位置
- int/string 区块号或字符串`"latest"`, `"earliest" `或者`"pending"`


###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果，存储值的位置值

###示例代码
以curl为例的调用代码如下：

```
$ curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0", "method": "eth_getStorageAt", "params": ["0x295a70b2de5e3953354a6a8344e616ed314d7251", "0x0", "latest"], "id": 739}' 
```
返回结果如下：

```
{"jsonrpc":"2.0","id":739,"result":"0x00000000000000000000000000000000000000000000000000000000000004d2"}
```

##eth_getTransactionCount - 查询发送到给定地址的交易量
###API调用

```
POST /api
```
参数:

- address 存储的地址
- int/string 区块号或字符串`"latest"`, `"earliest" `或者`"pending"`

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果，发送到给定地址的交易量

###示例代码
以curl为例的调用代码如下：

```
curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionCount","params":["0xc94770007dda54cF92009BFF0dE90c06F603a09f","latest"],"id":739}' 
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0x1" // 1
}
```

##eth_getBlockTransactionCountByHash - 查询发送到给定地址的交易量
###API调用

```
POST /api
```
参数:

- hash: 区块的哈希

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果，给定区块包含的交易量

###示例代码
以curl为例的调用代码如下：

```
curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockTransactionCountByHash","params":["0xc94770007dda54cF92009BFF0dE90c06F603a09f"],"id":739}
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0xc" // 11
}
```

##eth_getBlockTransactionCountByNumber - 查询给定区块号对应的区块号中包含的交易
###API调用

```
POST /api
```
参数:

- int/string: 区块号，或字符串`"earliest"`, `"latest"`,`"pending"`

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果，给定区块包含的交易量

###示例代码
以curl为例的调用代码如下：

```
curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockTransactionCountByNumber","params":["0xc94770007dda54cF92009BFF0dE90c06F603a09f"],"id":739}
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0xc" // 11
}
```
##eth_sendTransaction - 根据传入的参数创建交易，签名，提交到交易池

###API调用

```
POST /api
```
参数:

- from: 发送交易的地址
- to: 交易发送给的地址
- gas: (默认：90000)提供给交易得以执行的gas
- gasPrice: 每种付费gas所使用的gasprice
- nonce: nonce值
- data: 编译的代码或调用方法签名的散列和编码参数。

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果，交易的哈希

###示例代码
以curl为例的调用代码如下：

```
curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{
  "from": "0xb60e8dd61c5d32be8058bb8eb970870f07233155",
  "to": "0xd46e8dd67c5d32be8058bb8eb970870f07244567",
  "gas": "0x76c0", // 30400
  "gasPrice": "0x9184e72a000", // 10000000000000
  "value": "0x9184e72a", // 2441406250
  "data": "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"
  }],"id":739}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0xe670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331"
}
```
##eth_sendRawTransaction - 将签名后的交易添加进入交易池

###API调用

```
POST /api
```
参数:

- DATA - 签名的交易数据

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：交易哈希，如果交易未生效则返回全0哈希

###示例代码
以curl为例的调用代码如下：

```
curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_sendRawTransaction","params":["0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"],"id":739}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0xe670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331"
}
```

##eth_call - 执行一个链上没有的交易

###API调用

```
POST /api
```
参数:

- from: 发送交易的地址
- to: 交易发送给的地址
- gas: (默认：90000)提供给交易得以执行的gas
- gasPrice: 每种付费gas所使用的gasprice
- value: 这个交易的value值
- data: 编译的代码或调用方法签名的散列和编码参数。

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果，合约执行的值

###示例代码
以curl为例的调用代码如下：

```
curl -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_call","params":[{
  "from": "0xb60e8dd61c5d32be8058bb8eb970870f07233155",
  "to": "0xd46e8dd67c5d32be8058bb8eb970870f07244567",
  "gas": "0x76c0", // 30400
  "gasPrice": "0x9184e72a000", // 10000000000000
  "value": "0x9184e72a", // 2441406250
  "data": "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"
  }],"id":739}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0x"
}
```
##eth_getBlockByHash - 通过区块的哈希查找对应的普通区块
###API调用

```
POST /api
```
参数:

- 32byte 区块哈希
- bool   true,显示区块中交易的全部细节，false,仅显示区块中交易的哈希

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果，合约执行的值
    - hash: 区块哈希
    - parentHash: 前一区块的哈希
    - nonce: 生成区块的工作量证明
    - commitNumber: 对应的commit区块号
    - logsBloom: 日志过滤器
    - transactionsRoot: 交易树的哈希
    - stateRoot: 最终状态树的根哈希
    - receiptsRoot: 收据树的根哈希
    - miner: 区块产生者的地址
    - difficulty: 区块的难度
    - totalDifficulty: 指定这个区块的整个链的难度
    - extraData: 区块的额外信息
    - size: 区块的大小
    - gasLimit: 区块允许的最大的gas
    - gasUsed: 区块中所有交易消耗的gas
    - timestamp: 区块被生产出来的时间戳
    - transactions: 所有交易的集合
    
###示例代码
以curl为例的调用代码如下：

```
curl  -H "Content-Type:application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByHash","params":["0x6fd6d365acaf854d8d1be8fe91e5ae5cda5018ca71a8fd3b212425392e500a0a",false],"id":738}'
```
返回结果如下：

```
{
    "jsonrpc": "2.0",
    "id": 738,
    "result": {
        "difficulty": "0x400",
	     "commitNumber": "0x19",
        "extraData": "0xf84db8400e1e1acf776209f6e10a203539bd596d8c22382e105abd806bc0a7f051637be14af0ce187b425b9acb8b92131a797b4420be8443161324269b053d81869e600b801a808080808080808080",
        "gasLimit": "0x4dd30d2",
        "gasUsed": "0x0",
        "hash": "0x6fd6d365acaf854d8d1be8fe91e5ae5cda5018ca71a8fd3b212425392e500a0a",
        "logsBloom": "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "miner": "0xe05e11d6272af1a13f184326dadf4079cfa8c31d",
        "nonce": "0x0000000000000000",
        "number": "0x103",
        "parentHash": "0x6c25b2a403138cb287e6a622f8e6ee100d4f4bfbbbc4dceac4ba185558456be4",
        "receiptsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
        "rewardAddr": "0xe05e11d6272af1a13f184326dadf4079cfa8c31d",
        "size": "0x2ab",
        "stateRoot": "0x46e226056cea1582d326b7ebac9e6db1e72e46c4560328e207f6334685d728b0",
        "timestamp": "0x5ef1c3c0",
        "totalDifficulty": "0x41c00",
        "transactions": [],
        "transactionsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421"
    }
}
```

##过滤器

- eth_newFilter: 创建基于滤波器选项的滤波器对象，在状态发生变化时获取通知
- eth_newBlockFilter: 	在节点中创建一个过滤器，在新区块到达的时候发送通知
- eth_newPendingTransactionFilter: 创建过滤器，在新待决交易到达时发送通知
- eth_uninstallFilter: 通过给定的id装卸一个过滤器
- eth_getFilterChanges: 滤波器的投票方法，该方法返回上次投票后发生的一系列日志
- eth_getFilterLogs: 给定id匹配的日志列表 
- eth_getLogs: 获取日志的集合

##eth_newFilter - 创建基于滤波器选项的滤波器对象，在状态发生变化时获取通知
###API调用

```
POST /api
```
参数:

- fromBlock: (default: "latest") 区块号码，或"latest"最后产生的区块，"pending","earliest"还未打包的交易
- toBlock: (default: "latest") 同上
- address: 合约地址
- topics: Topics是订单依赖


###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$ curl -X POST --data '{"jsonrpc":"2.0","method":"eth_newFilter","params":[{"topics":["0x0000000000000000000000000000000000000000000000000000000012341234"]}],"id":739'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0x1" // 1
}
```

##eth_newBlockFilter - 在节点中创建一个过滤器，在新区块到达的时候发送通知

###API调用

```
POST /api
```
参数：
   无

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$curl -X POST --data '{"jsonrpc":"2.0","method":"eth_newBlockFilter","params":[],"id":739}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0x1" // 1
}
```

##eth_newPendingTransactionFilter - 创建过滤器，在新待决交易到达时发送通知
###API调用

```
POST /api
```
参数：
  无
###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$curl -X POST --data '{"jsonrpc":"2.0","method":"eth_newPendingTransactionFilter","params":[],"id":739}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": "0x1" // 1
}
```

##eth_uninstallFilter - 通过给定的id装卸一个过滤器
###API调用

```
POST /api
```
参数：
 
 -  过滤器id

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果

###示例代码
以curl为例的调用代码如下：

```
$curl -X POST --data '{"jsonrpc":"2.0","method":"eth_uninstallFilter","params":["0xb" //11],"id":739}'
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc": "2.0",
  "result": true
}
```

##eth_getFilterChanges - 滤波器的投票方法，该方法返回上次投票后发生的一系列日志

###API调用

```
POST /api
```
参数：
 
 -  过滤器id

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - removed: "true" 日志已被移除
    - logIndex: 日志的序号
    - transactionIndex: 交易的序列
    - transactionHash: 交易哈希
    - blockHash: 区块的哈希
    - blockNumber: 区块的号码
    - address: 日志起源的地址
    - data: 包含日志中非索引的参数
    - topics: 索引日志参数的参考

###示例代码
以curl为例的调用代码如下：

```
$ curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getFilterChanges","params":["0x16"],"id":739}
```
返回结果如下：

```
{
  "id":739,
  "jsonrpc":"2.0",
  "result": [{
    "logIndex": "0x1", // 1
    "blockNumber":"0x1b4", // 436
    "blockHash": "0x8216c5785ac562ff41e2dcfdf5785ac562ff41e2dcfdf829c5a142f1fccd7d",
    "transactionHash":  "0xdf829c5a142f1fccd7d8216c5785ac562ff41e2dcfdf5785ac562ff41e2dcf",
    "transactionIndex": "0x0", // 0
    "address": "0x16c5785ac562ff41e2dcfdf829c5a142f1fccd7d",
    "data":"0x0000000000000000000000000000000000000000000000000000000000000000",
    "topics": ["0x59ebeb90bc63057b6515673c3ecf9438e5058bca0f92585014eced636878c9a5"]
    },{
      ...
    }]
}
```

##eth_getFilterLogs - 给定id匹配的日志列表

###API调用

```
POST /api
```
参数：
 
 -  过滤器id

###API返回结果
返回结果为一个JSON对象，主要字段如下：

- jsonrpc：RPC版本号，2.0
- id：RPC请求编号
- result：调用结果
    - fromBlock: 区块号
    - toBlock: 区块号
    - transactionIndex: 交易的序列
    - transactionHash: 交易哈希
    - address: 日志起源的地址
      

###示例代码
以curl为例的调用代码如下：

```
$ curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getFilterLogs","params":[{"topics":["0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b"]}],"id":739'
```
返回结果查看`eth_getFilterChanges`


##eth_getLogs - 获取日志的集合

###API调用

```
POST /api
```
参数：
  
 - fromBlock：(default: “latest”)区块号，或”latest”-最新产出的区块或“pending”,”earliest”-还没有被打包的交易
 - toBlock：(default: “latest”)区块号，或”latest”-最新产出的区块或“pending”,”earliest”-还没有被打包的交易
 - address：合约地址或者开始搜寻日志的一系列地址
 - topics: 检索的条件
 - Blockhash: 是一种新的滤波选项，它限制了使用32字节散列返回单块的日志
  
###API返回结果
返回结果为一个JSON对象，字段说明参展eth_getFilterChanges  

###示例代码
以curl为例的调用代码如下：

```
$ curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getLogs","params":[{
  "topics": ["0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b"]
}],"id":739}'
```
返回结果如下：

```
{
  "id":1,
  "jsonrpc":"2.0",
  "result": [{
    "logIndex": "0x1", // 1
    "blockNumber":"0x1b4", // 436
    "blockHash": "0x8216c5785ac562ff41e2dcfdf5785ac562ff41e2dcfdf829c5a142f1fccd7d",
    "transactionHash":  "0xdf829c5a142f1fccd7d8216c5785ac562ff41e2dcfdf5785ac562ff41e2dcf",
    "transactionIndex": "0x0", // 0
    "address": "0x16c5785ac562ff41e2dcfdf829c5a142f1fccd7d",
    "data":"0x0000000000000000000000000000000000000000000000000000000000000000",
    "topics": ["0x59ebeb90bc63057b6515673c3ecf9438e5058bca0f92585014eced636878c9a5"]
    },{
      ...
    }]
}
```

