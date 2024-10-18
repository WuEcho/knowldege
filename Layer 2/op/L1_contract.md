## DataAvailabilityChallenge  
概述:挑战合约,有挑战保证金,挑战时间等限制.
### 常量
   1. `fixedResolutionCost`:解决挑战的固定成本,通过测量使用bytes(0)解决的成本估算得出.
   2. `variableResolutionCost`:解决挑战的可变成本,每字节乘以`variableResolutionCostPrecision`的缩放值.上限是通过测量具有可变大小数据（每个字节都非零）的解决成本估算得出.
   3. `variableResolutionCostPrecision`:可变分辨率成本的精度.
   4. `version`:版本号

### 变量  
   1. `challengeWindow`:承诺可以被挑战的有效期.
   2. `resolveWindow`:承诺可以被解决的有效期.
   3. `bondSize`:发起挑战的保证金金额.
   4. `resolverRefundPercentage`:解决成本退款百分比.
   5. `balances`:保证金余额.
   6. `challenges`:挑战承诺所在区块号->承诺->挑战信息,一个映射.

### 函数  
   1. `initialize`:初始化,设置`challengeWindow`,`resolveWindow`,`bondSize`,`resolverRefundPercentage`,转移`owner`等信息.
   2. `setBondSize`:设置保证金额度.
   3. `setResolverRefundPercentage`:设置退款百分比.
   4. `receive`:接受ETH对接到存款.
   5. `deposit`:存款函数.
   6. `withdraw`:取款函数.
   7. `_isInChallengeWindow`:是否在挑战期内.
   8. `_isInResolveWindow`:是否在解决期内.
   9. `getChallenge`:获取挑战信息.
   10. `getChallengeStatus`:获取挑战状态.
   11. `_getCommitmentType`:获取承诺类型.
   12. `validateCommitment`:验证承诺
   13. `challenge`:用于发起挑战.
   14. `resolve`:解决响应挑战.
   15. `_distributeBond`:分配保证金.
   16. `unlockBond`:解锁过期的挑战的保证金.
   17. `computeCommitmentKeccak256`:计算承诺,op原生的方式,`1+Keccak256(data)`


## L1CrossDomainMessenger
概述:是L1传递跨链信息的用户入口,还负责接受L2到L1的消息.

### 常量
   1. `MESSAGE_VERSION`:消息版本.
   2. `RELAY_CONSTANT_OVERHEAD`:为消息额外基础开销.  
   3. `MIN_GAS_DYNAMIC_OVERHEAD_NUMERATOR`:计算消息额外动态开销的分子.
   4. `MIN_GAS_DYNAMIC_OVERHEAD_DENOMINATOR`:计算消息额外动态开销的分母.
   5. `MIN_GAS_CALLDATA_OVERHEAD`:每个消息长度花费的额外开销.
   6. `RELAY_CALL_OVERHEAD`:在`relayMessage`方法中,执行`safe call`的预留gas量.
   7. `RELAY_RESERVED_GAS`:执行完 `safe call`后预留的gas量.
   8. `RELAY_GAS_CHECK_BUFFER`: 在`relayMessage`函数中,从`hasMinGas`检查到外部调用执行之间预留的 gas 量.
   9. `version`:合约版本号.

### 变量
   1. `successfulMessages`:成功跨链的消息.
   2. `xDomainMsgSender`:可以防重入,用来记录当前消息的发送者,不是默认值,就是第二次重入.
   3. `msgNonce`:下一个要发送的消息的nonce.
   4. `failedMessages`:失败跨链的消息.
   5. `otherMessenger`:L1的跨链消息地址.
   6. `superchainConfig`:超级链配置实例.
   7. `portal`:`OptimismPortal`合约实例,跨链的实现合约.
   8. `systemConfig`:`SystemConfig`合约实例,系统配置合约.

### 函数  
   1. `initialize`:初始化,设置各项配置实例.
   2. `gasPayingToken`:获取`L2`的主币地址和精度.
   3. `PORTAL`:后续会删除,返回`portal`实例.
   4. `_sendMessage`:通过调用`portal.depositTransaction`来实现跨链消息传递.
   5. `_isOtherMessenger`:通过`msg.sender`来判断是否来自另一端的跨链消息.
   6. `_isUnsafeTarget`:检查调用地址是否是安全的,防止重入.
   7. `paused`:可以用来查看超级链的配置,是否停链.
   8. `sendMessage`:传递消息,检查主币并调用内部方法`_sendMessage`.
   9. `relayMessage`:执行另外一条链跨链过来的消息.
   10. `xDomainMessageSender`:检查`xDomainMsgSender`是否是默认值,可用来防重入.
   11. `OTHER_MESSENGER`:未来会删除,返回另一条链的跨链地址.
   12. `messageNonce`:获取要发送消息的下一个`nonce`.
   13. `baseGas`:计算发送一条消息,需要的gas.
   14. `gasPayingToken`:返回L2主币在L1的地址和精度.
   15. `isCustomGasToken`:是否是自由gas.
   16. `__CrossDomainMessenger_init`:初始化消息传递合约,设置另一条链的消息传递合约.

## L1ERC721Bridge
概述:负责NFT跨链,用户从这个合约起调.

### 常量
   1. `messenger`:l1上的跨链消息合约.
   2. `otherBridge`:l2上的桥合约.
   3. `version`:版本.
   
### 变量
   1. `deposits`:`[l1地址][l2地址][tokenid]->[bool]`,用来记录是否存储(跨链).
   2. `superchainConfig`:超级链配置合约.

### 函数
   1. `initialize`:初始化方法,设置超级链配置,另一条链的跨链桥,消息跨链合约.
   2. `paused`:合约是否暂停.
   3. `finalizeBridgeERC721`:完成跨链nft的方法,会转nft到指定用户.
   4. `_initiateBridgeERC721`:初始化跨链nft方法.
   5. `__ERC721Bridge_init`:初始化nft桥合约.
   6. `MESSENGER`:后续会删除,返回跨链消息合约.
   7. `OTHER_BRIDGE`:返回另一端的跨链桥合约地址.
   8. `bridgeERC721`:跨链nft到本地址.
   9. `bridgeERC721To`:跨链nft到指定地址.

## L1StandardBridge
概述:负责ERC20跨链,用户从这个合约起调.
### 常量
   1. `RECEIVE_DEFAULT_GAS_LIMIT`:存入`ETH`时设置的`L2gas`限制.
   2. `version`:版本号.
### 变量
   1. `superchainConfig`:超级链配置.
   2. `systemConfig`:系统配置.
   3. `deposits`:`[l1地址][l2地址]->[数量]`,代币跨链的数量记录.或者说质押在`L1`的锁仓数量.
   4. `messenger`:L1跨链合约地址.
   5. `otherBridge`:另一条链L2上的跨链桥的地址.
### 函数
   1. `initialize`:设置超级链配置,链配置,跨链信使等合约地址.
   2. `paused`:返回是否合约暂停.
   3. `receive`:转到跨链`ETH`方法.
   4. `gasPayingToken`:返回`L2`主币的地址和精度.
   5. `depositETH`:存储`ETH`,进行跨链.
   6. `depositETHTo`:存储`ETH`,跨链到指定地址.
   7. `depositERC20`:跨链`ERC20` 代币.
   8. `depositERC20To`:跨链`ERC20` 代币到指定地址.
   9. `finalizeETHWithdrawal`:完成`L2`到`L1`的跨链`ETH`.
   10. `finalizeERC20Withdrawal`:完成`L2`到`L1`的跨链`ERC20` 代币.
   11. `l2TokenBridge`:后续会删除,返回`L2`上的跨链桥合约地址.
   12. `_initiateETHDeposit`:初始化跨链`ETH`消息.
   13. `_initiateERC20Deposit`:初始化跨链`ERC20` 消息.
   14. `_emitETHBridgeInitiated`:触发事件.
   15. `_emitETHBridgeFinalized`:触发事件.
   16. `_emitERC20BridgeInitiated`:触发事件.
   17. `_emitERC20BridgeFinalized`:触发事件.
   18. `isCustomGasToken`:是否是自由`gas`.

## L2OutputOracle
概述:原来的`Proposer`提交状态根的合约,现不使用.
## OptimismPortal
概述:配合`L2OutputOracle`使用的合约现在也不使用.

## OptimismPortal2
概述:`OptimismPortal2`是一个负责在以太坊 `L1` 和 `L2` 之间传递消息的底层合约.
### 常量
   1. PROOF_MATURITY_DELAY_SECONDS:取款交易别证明后需要等待的延迟时间.
   2. DISPUTE_GAME_FINALITY_DELAY_SECONDS:争议游戏解决后到针对其证明的取款可最终完成之间的延迟时间(以秒为单位).
   3. DEPOSIT_VERSION:存款版本号.
   4. RECEIVE_DEFAULT_GAS_LIMIT:使用receive函数存入ETH时设置的L2gas限额,固定为100,000.
   5. SYSTEM_DEPOSIT_GAS_LIMIT:从L1发起的系统存款交易L2gas限额,固定位200,000.
### 变量
   1. l2Sender:本次交易中发起存款的L2地址,可以用来检测重入.
   2. finalizedWithdrawals:用于记录取款是否完成的映射.
   3. superchainConfig:超级链配置的合约.
   4. systemConfig:系统配置.
   5. disputeGameFactory:争议游戏工厂合约实例.
   6. provenWithdrawals:[取款哈希][L2提交者]->ProvenWithdrawal的映射.
   7. disputeGameBlacklist:争议游戏黑名单.
   8. respectedGameType:用于查询输出提案的类型.
   9. respectedGameTypeUpdatedAt:游戏上次更新的时间戳.
   10. proofSubmitters:取款哈希到提交证明地址的映射.
   11. _balance:在L2中铸造的原生代币资产.
### 函数  
   1. initialize:初始化方法,用于设置争议游戏工厂,系统配置,超级链配置,初始化防重入信息等.
   2. balance:返回L2主币在本合约的余额.
   3. guardian:未来会删除的返回守护者地址.
   4. paused:返回是否暂停状态.
   5. proofMaturityDelaySeconds:返回取款证明被验证后需要等待的延迟时间.
   6. disputeGameFinalityDelaySeconds:返回争议游戏针对其证明的取款可最终完成之间的延迟时间.
   7. minimumGasLimit:根据输入的字节数,返回存款需要的最小gas.
   8. receive:对接到跨链交易中.
   9. donateETH:空实现,可用于存款ETH.
   10. gasPayingToken:获取L2主币的地址和精度.
   11. _resourceConfig:从系统配置合约中获取资源配置.
   12. proveWithdrawalTransaction:证明取款交易.
   13. finalizeWithdrawalTransaction:完成最终取款.
   14. finalizeWithdrawalTransactionExternalProof:使用其他人的证明完成提款.
   15. depositERC20Transaction:跨链ERC20交易的入口方法.
   16. depositTransaction:跨链ETH交易的入口方法.
   17. _depositTransaction:创建跨链存款交易的实现.
   18. setGasPayingToken:设置L2主币的token信息.
   19. blacklistDisputeGame:将争议游戏列入黑名单,只有守护者能调用此合约.
   20. setRespectedGameType:设置游戏类型.
   21. checkWithdrawal:检查取款是否可以最终完成,包含各项时间和状态的检查.
   22. numProofSubmitters:获取指定取款哈希的提交者长度.

## SuperchainConfig
概述:超级链相关的配置.
### 常量
   1. PAUSED_SLOT:用于存储超级链是否暂停状态的存储槽位标识,通过特定的哈希计算得出.
   2. GUARDIAN_SLOT:用于存储守护者地址的存储槽位标识,通过特定的哈希计算得出.
   3. version:版本号.
###  函数
   1. initialize:初始化方法,设置是否暂停,和守护者地址.
   2. guardian:获取守护者地址.
   3. paused:返回是否出入暂停状态.
   4. pause:暂停取款操作的函数.
   5. _pause:内部实现设置槽位中的状态为true.
   6. unpause:解除暂停状态.
   7. _setGuardian:内部实现用于设置守护者地址.

##  SystemConfig
概述:本L2链的系统配置.
### 常量
   1. VERSION:版本号.
   2. UNSAFE_BLOCK_SIGNER_SLOT:存储不安全块签名者的存储槽位标识.
   3. L1_CROSS_DOMAIN_MESSENGER_SLOT:存储跨链信使(L1CrossDomainMessenger)地址的槽位.
   4. L1_ERC_721_BRIDGE_SLOT:存储nft跨链桥地址的槽位.
   5. L1_STANDARD_BRIDGE_SLOT:存储erc20跨链桥地址的槽位.
   6. OPTIMISM_PORTAL_SLOT:存储OptimismPortal2地址的槽位.
   7. OPTIMISM_MINTABLE_ERC20_FACTORY_SLOT:存储OptimismMintableERC20Factory地址的槽位.
   8. BATCH_INBOX_SLOT:存储batch 信箱地址的槽位.
   9. START_BLOCK_SLOT:存储L2在L1哪个区块开始.
   10. DISPUTE_GAME_FACTORY_SLOT:存储DisputeGameFactory地址的槽位.
   11. GAS_PAYING_TOKEN_DECIMALS:L2主币的精度.
   12. MAX_GAS_LIMIT:L2块的gas最大限制.
### 变量
   1. overhead:固定的L2gas开销,Ecotone升级后,已弃用.
   2. scalar:动态L2gas开销,Ecotone升级后,已启用.
   3. batcherHash:batcher处理者标识.
   4. gasLimit:L2块的限制.
   5. basefeeScalar:基础费用的标量值,Ecotone升级后,用于计算L2gas费用.
   6. blobbasefeeScalar:blob基础费用标量值,Ecotone升级后,启用.
   7. _resourceConfig:资源配置用于OptimismPortal计量L1购买L2gas的成本.
### 函数
   1. initialize:初始化函数,将合约地址都设置,变量也进行初始化.
   2. minimumGasLimit:返回系统安全运行所需的最小L2gas限制.
   3. maximumGasLimit:返回 MAX_GAS_LIMIT.
   4. unsafeBlockSigner:获取不安全的块签名者地址.
   5. l1CrossDomainMessenger:获取L1CrossDomainMessenger地址.
   6. l1ERC721Bridge:获取l1ERC721Bridge地址.
   7. l1StandardBridge:获取l1StandardBridge地址.
   8. disputeGameFactory:获取disputeGameFactory地址.
   9. optimismPortal:获取optimismPortal地址.
   10. optimismMintableERC20Factory:获取optimismMintableERC20Factory地址.
   11. batchInbox:返回batchInbox地址.
   12. startBlock:返回L1开始区块号.
   13. gasPayingToken:返回主币信息.
   14. isCustomGasToken:返回是否是自定义的主币.
   15. gasPayingTokenName:返回L2主币的name.
   16. gasPayingTokenSymbol:返回L2主币的symbol.
   17. _setGasPayingToken:设置主币地址.
   18. setUnsafeBlockSigner:设置不安全的块签名地址.
   19. _setUnsafeBlockSigner:设置不安全的块签名地址实现.
   20. setBatcherHash:设置批处理者哈希.
   21. _setBatcherHash:设置批处理这哈希实现.
   22. setGasConfig:设置gas配置,Ecotone升级后弃用.
   23. _setGasConfig:设置gas配置实现.Ecotone升级后弃用.
   24. setGasConfigEcotone:设置Ecotone升级后的gas配置.
   25. _setGasConfigEcotone:设置Ecotone升级后的gas配置实现.
   26. _setStartBlock:设置起始区块.
   27. resourceConfig:获取资源配置.
   28. _setResourceConfig:设置资源配置.

## DisputeGameFactory
概述:用于创建争议游戏的工厂合约.
### 常量
   1. version:版本号.
### 变量
   1. gameImpls:[GameType]->[实现合约]的映射.
   2. initBonds:[GameType]->[保证金额度]的映射.
   3. _disputeGames:[gameType || rootClaim || extraData]->[GameId]的映射.
   4. _disputeGameList:GameId的数组,用于链下使用方便.
### 函数
   1. initialize:初始化,设置合约所有者.
   2. gameCount:返回已创建的争议游戏数量,就是_disputeGameList的长度.
   3. games:根据给定的游戏类型、根声明和额外数据,返回对应的争议游戏代理和创建时间戳.
   4. gameAtIndex:根据索引返回游戏类型、时间戳和争议游戏代理.
   5. create:创建争议游戏.
   6. getGameUUID:获取游戏唯一标识.
   7. findLatestGames:查找最新的游戏.
   8. setInitBond:设置创建争议游戏的保证金.

## FaultDisputeGame
概述:实现争议游戏,也就是挑战相关的合约.
### 常量
   1. ABSOLUTE_PRESTATE:指令追踪前状态.
   2. MAX_GAME_DEPTH:最大游戏深度.
   3. SPLIT_DEPTH:游戏第二部分最大深度.
   4. MAX_CLOCK_DURATION:
   5. VM:执行单个指令的链上虚拟机.
   6. GAME_TYPE:游戏类型.
   7. WETH:weth的合约.
   8. ANCHOR_STATE_REGISTRY:
   9. ROOT_POSITION:全局根固定位置.
   10. HEADER_BLOCK_NUMBER_INDEX:RLP 编码块头中的块号索引.
   11. version:版本.
### 变量
   1. createdAt:创建挑战游戏的时间戳.
   2. resolvedAt:游戏全局解决的时间戳.
   3. status:游戏状态.
   4. initialized:防止initialize重复初始化.
   5. l2BlockNumberChallenged:标识L2块是否被挑战.
   6. l2BlockNumberChallenger:标识L2块的挑战者地址.
   7. claimData:争议期间所有claim的数组.
   8. credit:获胜参与者的信用余额映射.
   9. claims:快速查找现有claim的映射.
   10. subgames:将子游戏根声明索引映射到子游戏中的其他声明索引.
   11. resolvedSubgames:已解决的子游戏映射.
   12. resolutionCheckpoints:声明索引到解决检查点的映射.
   13. startingOutputRoot:最新的最终输出根,用作输出二分的锚点.
### 函数
   1. initialize:初始化,设置挑战起始阶段,保证金之类的.
   2. step:对单个指令步骤进行验算.
   3. move: 通用的移动函数,用于attack和defend操作.在游戏进行中时,进行多种检查,如争议声明是否正确、移动位置是否有效、保证金是否正确、时钟时长是否未超过限制、是否存在重复声明等,还涉及到时钟扩展的计算、新声明的创建、子游戏的更新、保证金的存入以及事件的发射.
   4. attack:true 实现攻击.
   5. defend:false 实现防御.
   6. addLocalData:将本地数据添加到预言机中.
   7. getNumToResolve:返回给定声明索引下需要解决的剩余子游戏数量,通过获取解决检查点和子游戏挑战索引来计算.
   8. l2BlockNumber:返回L2区块号.
   9. startingBlockNumber:返回起始区块号.
   10. startingRootHash:返回起始跟hash.
   11. challengeRootL2Block:在游戏进行中且根 L2 块号未被挑战时,验证输出根预映像和块头 RLP 编码,解码块头获取块号并与争议游戏中的块号进行比较,若验证通过则设置挑战者并标记 L2 块号已被挑战.
   12. resolve:在游戏进行中且绝对根子游戏已解决时,更新游戏状态为挑战者获胜或防御者获胜,设置解决时间戳,尝试更新锚状态并发出解决事件.
   13. resolveClaim:在游戏进行中时,对给定声明索引的子游戏进行解决操作,包括检查时钟是否到期、子游戏是否已解决、处理未竞争的声明、更新解决检查点、标记子游戏为已解决、分配保证金等操作.
   14. gameType:返回游戏类型.
   15. gameCreator:返回游戏创建者.
   16. rootClaim:返回根声明信息.
   17. l1Head:返回l1的块头.
   18. extraData:返回额外数据.
   19. gameData:返回游戏详细信息.
   20. getRequiredBond:根据给定的位置计算移动所需的保证金,通过一系列复杂的数学计算（涉及固定点数学库）来确定.
   21. claimCredit:允许声明者领取信用,先从信用映射中移除信用,若信用为 0 则回滚,尝试提取 WETH 并将信用转移给接收者,若转移失败则回滚
   22. getChallengerDuration:在游戏进行中时,计算给定声明索引的潜在挑战者的时钟已流逝时间,通过查询子游戏根声明及其父时钟（若存在）来计算.
   23. claimDataLen:以外部视图函数形式返回claimData数组的长度.
   24. _distributeBond:内部函数,用于将声明的保证金支付给指定的接收者,包括增加接收者的信用、解锁保证金等操作.
   25. _verifyExecBisectionRoot:内部函数,用于验证执行二分法子游戏的根声明的完整性,根据移动类型、争议输出根等情况检查根声明的状态字节是否符合预期,若不符合则回滚.
   26. _findTraceAncestor:内部函数,用于查找给定位置在有向无环图（DAG）中的跟踪祖先声明,根据是否全局搜索以及起始索引在 DAG 中向上查找直到找到匹配的祖先声明.
   27. _findStartingAndDisputedOutputs:内部函数,根据给定的起始索引在claimData中查找起始和争议的输出根声明及其位置,通过在 DAG 中向上查找并根据攻击或防御情况确定不同的输出根.
   28. _findLocalContext:内部函数,通过调用_findStartingAndDisputedOutputs函数计算给定声明索引的局部上下文哈希.
   29. _computeLocalContext:内部函数,根据起始声明、起始位置、争议声明和争议位置计算局部上下文哈希,对于特殊情况（起始位置为 0）有不同的计算方式.





