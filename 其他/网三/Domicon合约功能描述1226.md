# Domicon合约功能描述

## L1合约

### 合约1：DomiconNode.sol

DomiconNode.sol的主要的功能是对广播节点、存储节点进行管理，方便用户选择和查询。

对节点进行编号，并统计总数。

注册为广播节点：需要提供1.公钥地址；2.rpc接口（用来接收用户提交的数据）；3.节点名字；4.抵押足量的LP token(Domicon-ETH)。

注册为存储节点： 需要提供1.公钥地址；2.rpc接口（用来查询用户存储的数据）；3.节点名字；4.抵押足量的LP token(Domicon-ETH)。

合约内的LP token，可以被来自L2的消息罚没。

同时监听该合约，将注册信息同步到l2。

## 合约2：DomiconCommitment.sol

该合约的主要功能是存储用户的Commitment，输入包括[[cm,index,len,A,B],sign]，其中cm是数据的kzg commitment，需要检查长度。index表示用户的第几次提交，需要按顺序进行。len表示此次数据的长度，用于计费。A为数据拥有者的地址。B为提交本次交易的广播节点的地址。sign是用户A对上述的签名。

### 合约3：RentandAudit.sol

用户选择存储节点进行租赁。

用户发起audit挑战。

## L2合约

### 合约1：DomiconNodeL2.sol

同步来自L1的domicon节点信息。

### 合约2：DataPublish.sol

该合约主要用于广播节点举报其他节点不广播数据。在广播节点通过P2P网络拿不到数据，并且通过data sampling也拿不到数据的时候，将会把相关节点就报到该合约。当广播节点被举报超过一半的广播节点举报，将会被惩罚。

### 合约3：ProofofPublic.sol

不定期的，会随机抽查一个节点，让节点证明自己获得了数据。



