
# 外部账户EOA与合约账户CA
 在以太坊中，账户拥有4个字段：{nonce,balance,codeHash,StorageRoot}。
    一共分为2种账户：外部账户、合约账户。
    外部账户，Externally Owned Accounts，简称EOA，它拥有私钥，其codeHash为空。
    合约账户，Contact Account，简称CA，它没有私钥，其codeHash非空。

 判断一个地址是否为合约地址的方法如下：
 
```
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;


library Address {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }
}    
   

```


