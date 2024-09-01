## utopia_baap


##基本介绍

　　本软件包存在的意义是方便用户下载，部署utopia节点，本软件包包含：utopia的linux可执行文件，以及utopia的初始化脚本init.sh,启动脚本utopia_start.sh,停止脚本utopia_stop.sh，清除数据文件的脚本fini.sh。baap.jar的java包,以及启动baap的启动脚本baap_start.sh,baap的停止脚本baap_stop.sh，以及控制utopia和baap启动/停止的脚本：start.sh,stop.sh。

## 注意事项
###1.支持系统
本软件包仅支持在Ubuntu系统下运行
###2.时间戳同步
　　utopia可执行程序对于出块时间有校验处理，因此要想正常参与到utopia公识中，请先确保本地时间的准确性，更新本地机器时间可通过命令`sudo sntp -sS pool.ntp.org`，

##使用说明
###1.使用步骤
　　请先使用init.sh脚本来初始化一些链的信息，然后运行start.sh,启动Utopia和baap。如果想停止运行已经在运行的Utopia和baap实例，可以使用stop.sh。

###2.具体说明
####2.1 init.sh
#####2.1.1 用户操作
运行init.sh以后,有两个选项可供选择：
1.创建一个新链，2.加入一个已存在的链。
#####2.1.2 链id
　　输入需要创建/加入的链id(主网id为739)，此信息会被记录在**utopia/conf/链id/chain-info.properties**中chainId字段
#####2.1.3 链类型
然后选择链的类型:
1.创建/加入一个公链，2.创建/加入一个联盟链。 
#####2.1.4 创建账户
　　如果是创建一个新链，需要输入创建新账户的密码，此密码会被记录，从而影响该账户的安全，因此请涉及到转账的操作尽量避免使用此账户(挖矿奖励会发放到指定的奖励账户，此账户地址需要用户设置)。账户地址信息记录在**/utopia/conf/链id/chain-info.properties**中miner_address字段
#####2.1.5 奖励地址
　　账户创建完成以后，会向用户索取奖励地址，即挖矿的奖励会直接发放到奖励地址上。此地址用来保护用户的财产安全。此信息会被记录在**/utopia/conf/链id/chain-info.properties**中reward_address字段
#####2.1.6 确定出块人身份
　　用户输入的第一个出块人身份会被写入到genesis里面,默认的第一个出块人为用户创建的账户地址,链接主网请忽略此步骤。此信息会被记录在**/utopia/conf/链id/chain-info.properties**中first_minner_address字段
#####2.1.7 bootnode信息
　　新部署的节点要想加入其它存在的链，需要bootnode信息,该信息被记录在**/utopia/conf/链id/bootnode.txt**文件中，此项输入，仅在用户创建自己的私链中会出现。

####2.2 stop.sh
　　停止脚本会读取本机上创建的所有链id的文件，用户可以选择要停止的链id的链。stop.sh是调用utopia_stop.sh和
    
####2.3 fini.sh
　　清理数据脚本会读取本机上创建的所有链id的文件，用户可以选择要清除哪个链id的链的数据文件。

