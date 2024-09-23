# ERC20-Permit - EIP2612


## ERC20的问题
- 授权、转账需要两笔交易

![](https://github.com/WuEcho/knowldege/blob/main/%E6%99%BA%E8%83%BD%E5%90%88%E7%BA%A6/33_1_ERC20Permit/image/erc20.png)

能否在离线签名进⾏授权、转账时验证签名

## ERC20-Permit
`EIP-2612`提出了`ERC20Permit`，扩展了 `ERC20` 标准，添加了一个 `permit` 函数，允许用户通过 `EIP-712` 签名修改授权，而不是通过 `msg.sender`。这有两点好处：

- 签名授权
    - • （授权）可以在线下签名进⾏，签名信息可以在执⾏接收转账交易时提交到链上（permit），让授权和转账在⼀笔交易⾥完成。
    - • 同时转账交易也可以由接收⽅（或其他第三⽅）来提交，也避免了⽤户（ERC20的拥有者）需要有 ETH的依赖

![](https://github.com/WuEcho/knowldege/blob/main/%E6%99%BA%E8%83%BD%E5%90%88%E7%BA%A6/33_1_ERC20Permit/image/erc20permit.png)

## 合约
### IERC20Permit 接口合约
首先，让我们学习下`ERC20Permit`的接口合约，它定义了`3`个函数：

- `permit()`: 根据 `owner` 的签名, 将 `owenr` 的`ERC20`代币余额授权给 `spender`，数量为 `value`。要求：

    - `spender` 不能是零地址。
    - `deadline` 必须是未来的时间戳。
    - `v`，`r` 和 `s` 必须是 `owner` 对 `EIP712` 格式的函数参数的有效 `secp256k1` 签名。
    - 签名必须使用 `owner` 当前的 `nonce`。
- `nonces()`: 返回 `owner` 的当前 `nonce`。每次为 `permit()` 函数生成签名时，都必须包括此值。每次成功调用 `permit()` 函数都会将`owner`的`nonce`增加 1，防止多次使用同一个签名。

- `DOMAIN_SEPARATOR()`: 返回用于编码 `permit()` 函数的签名的域分隔符（`domain separator`），如[EIP712所定义](https://github.com/AmazingAng/WTF-Solidity/blob/main/52_EIP712/readme.md)。


```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev ERC20 Permit 扩展的接口，允许通过签名进行批准，如 https://eips.ethereum.org/EIPS/eip-2612[EIP-2612]中定义。
 */
interface IERC20Permit {
    /**
     * @dev 根据owner的签名, 将 `owenr` 的ERC20余额授权给 `spender`，数量为 `value`
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev 返回 `owner` 的当前 nonce。每次为 {permit} 生成签名时，都必须包括此值。
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev 返回用于编码 {permit} 的签名的域分隔符（domain separator）
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}
```

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
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

/**
 * @dev ERC20 Permit 扩展的接口，允许通过签名进行批准，如 https://eips.ethereum.org/EIPS/eip-2612[EIP-2612]中定义。
 *
 * 添加了 {permit} 方法，可以通过帐户签名的消息更改帐户的 ERC20 余额（参见 {IERC20-allowance}）。通过不依赖 {IERC20-approve}，代币持有者的帐户无需发送交易，因此完全不需要持有 Ether。
 */
contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
    mapping(address => uint) private _nonces;

    bytes32 private constant _PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    /**
     * @dev 初始化 EIP712 的 name 以及 ERC20 的 name 和 symbol
     */
    constructor(string memory name, string memory symbol) EIP712(name, "1") ERC20(name, symbol){}

    /**
     * @dev See {IERC20Permit-permit}.
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual override {
        // 检查 deadline
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        // 拼接 Hash
        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
        bytes32 hash = _hashTypedDataV4(structHash);
        
        // 从签名和消息计算 signer，并验证签名
        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");
        
        // 授权
        _approve(owner, spender, value);
    }

    /**
     * @dev See {IERC20Permit-nonces}.
     */
    function nonces(address owner) public view virtual override returns (uint256) {
        return _nonces[owner];
    }

    /**
     * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
     * DOMAIN_SEPARATOR = keccak256(
    abi.encode(
        keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
        keccak256(bytes(name)),
        keccak256(bytes(version)),
        chainid,
        address(this)
));
     */
    function DOMAIN_SEPARATOR() external view override returns (bytes32) {
        return _domainSeparatorV4();
    }

    /**
     * @dev "消费nonce": 返回 `owner` 当前的 `nonce`，并增加 1。
     */
    function _useNonce(address owner) internal virtual returns (uint256 current) {
        current = _nonces[owner];
        _nonces[owner] += 1;
    }
}```


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

## 安全注意
**签名时，一定要谨慎的阅读签名内容！**

同时，一些合约在集成`permit`时，也会带来`DoS`（拒绝服务）的风险。因为`permit`在执行时会用掉当前的`nonce`值，如果合约的函数中包含`permit`操作，则攻击者可以通过抢跑执行`permit`从而使得目标交易因为`nonce`被占用而回滚。

