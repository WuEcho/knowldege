# 新增命令行参数解释

|命令行参数|说明|默认值|备注|
|:---|:---|:----|---|
|--ccRpcPort|chainCode端口号|1234|
|--iaas|iass地址和端口号|\-|
|--rewardAddress|奖励地址|\-|如果写奖励会给挖矿地址|
|--nodeType|链类型|3|0-信任链,1-服务链,2-业务链,3-其他链|
|--keystorefile|生成csr使用keyStore文件|\-|
|--days|证书时效|365|
|--subj|证书的subj|\-|
|--perf|联盟链perf模式|false|

#默认的命令行参数
ETHEREUM选项:
--config value          TOML 配置文件
--datadir “xxx”         数据库和keystore密钥的数据目录
--keystore              keystore存放目录(默认在datadir内)
--nousb                 禁用监控和管理USB硬件钱包
--networkid value       网络标识符(整型, 1=Frontier, 2=Morden (弃用), 3=Ropsten, 4=Rinkeby) (默认: 1)
--testnet               Ropsten网络:预先配置的POW(proof-of-work)测试网络
--rinkeby               Rinkeby网络: 预先配置的POA(proof-of-authority)测试网络
--syncmode "fast"       同步模式 ("fast", "full", or "light")
--ethstats value        上报ethstats service  URL (nodename:secret@host:port)
--identity value        自定义节点名
--lightserv value       允许LES请求时间最大百分比(0 – 90)(默认值:0) 
--lightpeers value      最大LES client peers数量(默认值:20)
--lightkdf              在KDF强度消费时降低key-derivation RAM&CPU使用
开发者（模式）选项:
--dev               使用POA共识网络，默认预分配一个开发者账户并且会自动开启挖矿。
--dev.period value  开发者模式下挖矿周期 (0 = 仅在交易时) (默认: 0)
ETHASH 选项:
--ethash.cachedir                        ethash验证缓存目录(默认 = datadir目录内)
--ethash.cachesinmem value               在内存保存的最近的ethash缓存个数  (每个缓存16MB ) (默认: 2)
--ethash.cachesondisk value              在磁盘保存的最近的ethash缓存个数 (每个缓存16MB) (默认: 3)
--ethash.dagdir ""                       存ethash DAGs目录 (默认 = 用户hom目录)
--ethash.dagsinmem value                 在内存保存的最近的ethash DAGs 个数 (每个1GB以上) (默认: 1)
--ethash.dagsondisk value                在磁盘保存的最近的ethash DAGs 个数 (每个1GB以上) (默认: 2)
交易池选项:
--txpool.nolocals            为本地提交交易禁用价格豁免
--txpool.journal value       本地交易的磁盘日志：用于节点重启 (默认: "transactions.rlp")
--txpool.rejournal value     重新生成本地交易日志的时间间隔 (默认: 1小时)
--txpool.pricelimit value    加入交易池的最小的gas价格限制(默认: 1)
--txpool.pricebump value     价格波动百分比（相对之前已有交易） (默认: 10)
--txpool.accountslots value  每个帐户保证可执行的最少交易槽数量  (默认: 16)
--txpool.globalslots value   所有帐户可执行的最大交易槽数量 (默认: 4096)
--txpool.accountqueue value  每个帐户允许的最多非可执行交易槽数量 (默认: 64)
--txpool.globalqueue value   所有帐户非可执行交易最大槽数量  (默认: 1024)
--txpool.lifetime value      非可执行交易最大入队时间(默认: 3小时)
性能调优的选项:
--cache value                分配给内部缓存的内存MB数量，缓存值(最低16 mb /数据库强制要求)(默认:128)
--trie-cache-gens value      保持在内存中产生的trie node数量(默认:120)
帐户选项:
--unlock value              需解锁账户用逗号分隔
--password value            用于非交互式密码输入的密码文件
API和控制台选项:
--rpc                       启用HTTP-RPC服务器
--rpcaddr value             HTTP-RPC服务器接口地址(默认值:“localhost”)
--rpcport value             HTTP-RPC服务器监听端口(默认值:8545)
--rpcapi value              基于HTTP-RPC接口提供的API
--ws                        启用WS-RPC服务器
--wsaddr value              WS-RPC服务器监听接口地址(默认值:“localhost”)
--wsport value              WS-RPC服务器监听端口(默认值:8546)
--wsapi  value              基于WS-RPC的接口提供的API
--wsorigins value           websockets请求允许的源
--ipcdisable                禁用IPC-RPC服务器
--ipcpath                   包含在datadir里的IPC socket/pipe文件名(转义过的显式路径)
--rpccorsdomain value       允许跨域请求的域名列表(逗号分隔)(浏览器强制)
--jspath loadScript         JavaScript加载脚本的根路径(默认值:“.”)
--exec value                执行JavaScript语句(只能结合console/attach使用)
--preload value             预加载到控制台的JavaScript文件列表(逗号分隔)
网络选项:
--bootnodes value    用于P2P发现引导的enode urls(逗号分隔)(对于light servers用v4+v5代替)
--bootnodesv4 value  用于P2P v4发现引导的enode urls(逗号分隔) (light server, 全节点)
--bootnodesv5 value  用于P2P v5发现引导的enode urls(逗号分隔) (light server, 轻节点)
--port value         网卡监听端口(默认值:30303)
--maxpeers value     最大的网络节点数量(如果设置为0，网络将被禁用)(默认值:25)
--maxpendpeers value    最大尝试连接的数量(如果设置为0，则将使用默认值)(默认值:0)
--nat value             NAT端口映射机制 (any|none|upnp|pmp|extip:<IP>) (默认: “any”)
--nodiscover            禁用节点发现机制(手动添加节点)
--v5disc                启用实验性的RLPx V5(Topic发现)机制
--nodekey value         P2P节点密钥文件
--nodekeyhex value      十六进制的P2P节点密钥(用于测试)
矿工选项:
--mine                  打开挖矿
--minerthreads value    挖矿使用的CPU线程数量(默认值:8)
--etherbase value       挖矿奖励地址(默认=第一个创建的帐户)(默认值:“0”)
--targetgaslimit value  目标gas限制：设置最低gas限制（低于这个不会被挖？） (默认值:“4712388”)
--gasprice value        挖矿接受交易的最低gas价格
--extradata value       矿工设置的额外块数据(默认=client version)
GAS价格选项:
--gpoblocks value      用于检查gas价格的最近块的个数  (默认: 10)
--gpopercentile value  建议gas价参考最近交易的gas价的百分位数，(默认: 50)
虚拟机的选项:
--vmdebug        记录VM及合约调试信息
日志和调试选项:
--metrics            启用metrics收集和报告
--fakepow            禁用proof-of-work验证
--verbosity value    日志详细度:0=silent, 1=error, 2=warn, 3=info, 4=debug, 5=detail (default: 3)
--vmodule value      每个模块详细度:以 <pattern>=<level>的逗号分隔列表 (比如 eth/*=6,p2p=5)
--backtrace value    请求特定日志记录堆栈跟踪 (比如 “block.go:271”)
--debug                     突出显示调用位置日志(文件名及行号)
--pprof                     启用pprof HTTP服务器
--pprofaddr value           pprof HTTP服务器监听接口(默认值:127.0.0.1)
--pprofport value           pprof HTTP服务器监听端口(默认值:6060)
--memprofilerate value      按指定频率打开memory profiling    (默认:524288)
--blockprofilerate value    按指定频率打开block profiling    (默认值:0)
--cpuprofile value          将CPU profile写入指定文件
--trace value               将execution trace写入指定文件
WHISPER实验选项:
--shh                        启用Whisper
--shh.maxmessagesize value   可接受的最大的消息大小 (默认值: 1048576)
--shh.pow value              可接受的最小的POW (默认值: 0.2)
弃用选项：
--fast     开启快速同步
--light    启用轻客户端模式
其他选项:
–help, -h    显示帮助

