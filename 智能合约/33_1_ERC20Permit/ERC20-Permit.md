# ERC20-Permit - EIP2612


## ERC20的问题
- 授权、转账需要两笔交易

![](https://github.com/WuEcho/knowldege/blob/main/%E6%99%BA%E8%83%BD%E5%90%88%E7%BA%A6/33_1_ERC20Permit/image/erc20.png)

能否在离线签名进⾏授权、转账时验证签名

## ERC20-Permit

- 签名授权
    - • （授权）可以在线下签名进⾏，签名信息可以在执⾏接收转账交易时提交到链上（permit），让授权和转账在⼀笔交易⾥完成。
    - • 同时转账交易也可以由接收⽅（或其他第三⽅）来提交，也避免了⽤户（ERC20的拥有者）需要有 ETH的依赖

![](https://github.com/WuEcho/knowldege/blob/main/%E6%99%BA%E8%83%BD%E5%90%88%E7%BA%A6/33_1_ERC20Permit/image/erc20permit.png)

## 实现

```
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC2612 is ERC20, ERC20Permit {
   constructor() ERC20("ERC2612", "ERC2612") ERC20Permit("ERC2612") {
   _mint(msg.sender, 1000 * 10 ** 18);
 }
}

```

[ERC20Permit更多实现可查看](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Permit.sol)
```
function permit(address owner, address spender, uint256 value, uint256 deadline, 
uint8 v, bytes32 r, bytes32 s) public virtual {
 if (block.timestamp > deadline) {
 revert ERC2612ExpiredSignature(deadline);
 }
 bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, 
value, _useNonce(owner), deadline));

 bytes32 hash = _hashTypedDataV4(structHash);
 address signer = ECDSA.recover(hash, v, r, s);
 if (signer != owner) {
 revert ERC2612InvalidSigner(signer, owner);
 }
 _approve(owner, spender, value);
 }
```


## Permit2
### 有没有办法让为所有的`Token`合约实现离线授权？
`Uniswap Permit2` 结合了 `approve` 与 `erc2612 - permit`

[https://github.com/Uniswap/permit2](https://github.com/Uniswap/permit2)
## 应⽤中使⽤签名要注意

**防⽌重⽤**
签名中加⼊:

- • `Nonce`
- • `ChainID` 
- • `Deadline` (可选，但推荐)
- • 业务逻辑 + 授权（`amount`：， `spender`）

