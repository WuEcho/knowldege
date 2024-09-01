# genesis 文件

```
{
  "config": {
"chainId": 738,      //chainID

//utopia配置
 "utopia": {     
"noRewards":false,    //区块是否有奖励 默认false 挖矿有奖励
"cfd":5,           //commit区间
"numMasters":2,    //区块master数量,一个区块同时有几个节点出块
"blockDelay":1000, //出块时间 
"hypothecation":treu,  //是否开启质押  ture 为开启质押
"perQuorum"        //默认false 是否每个高度都更新委员会
"publicAccount"      // 公共账户地址 cash模式
"voterAddrs"         // 投票账户地址 cash模式
"minerRewardAccount" // 该账户提供打块奖励 cash模式
"quorumResetAccounts"    //恢复委员会 默认设置第一个出块节点
"quorumResetAfterHeight" //恢复委员会参数 要经过多少个commit才能执行恢复合约
"rewardTotal":"100000",//设置挖矿池奖励总量 不设置是没有上限 单位=wei 不写和写0都是没有上限
"allowIncrease":"0x86082fa9d3c14d00a8627af13cfa893e80b39101:,    //奖励池是否可以使用增发合约 写地址用该地址增发,不写禁止增发
"gasLess":true,       //免费交易 true=免费交易 默认false
"consortium":true,    //是否是联盟链 true=联盟链 默认false
//跨链链信息
"tokenChain": [
    {
    //跨链1
        "chainId":"739",
        "chainOwner":"123456",
        "tokenSymbol":"15432523",
        "rpcHosts":["http://127.0.0.1:8545",]
    },
    {
    //跨链2
        "chainId":"730",
        "chainOwner":"123456",
        "tokenSymbol":"15432523",
        "rpcHosts":["http://127.0.0.1:8545",]
    }
              ]   
    }
//utopia配置完成
    sm2Crypto:true  //是否走sm2 国密配置 false=椭圆曲线 true=国密  
    
  },
  
  
  
  //genesis块信息
  "nonce": "0x0000000000000042",
  "difficulty": "0x1000",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "timestamp": "0x00", "parentHash":"0x0000000000000000000000000000000000000000000000000000000000000000",
  "extraData": "0x86082fa9d3c14d00a8627af13cfa893e80b39101",   //第一个出块节点地址
  "gasLimit": "0x271d94900"  //区块limit,一个块可以执行多少笔交易
  }


```

