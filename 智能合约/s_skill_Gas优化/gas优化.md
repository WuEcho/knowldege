# gas优化

参考文章：[gas优化](https://decert.me/tutorial/rareskills-gas-optimization/chapter_2)

1. gas 优化技巧并不总是有效

某些 gas 优化技巧只在特定情况下有效。例如，直观上，以下代码：

```
if (!cond) {
    // branch False
}
else {
    // branch True
}
```
比以下代码效率更低

```
if (cond) {
    // branch True
}
else {
    // branch False
}
```


2. 尽可能避免从零到一的存储写入

初始化存储变量是合约可以执行的最昂贵的操作之一。

当存储变量从零变为非零时，用户必须支付总共22,100 gas（20,000 gas 用于从零到非零的写入，2,100 gas 用于冷存储访问）。

这就是为什么 Openzeppelin 的重入保护使用1和2来注册函数的活动状态，而不是0和1。将存储变量从非零更改为非零只需花费5,000 gas。

3. 缓存存储变量：仅写入和读取存储变量一次

在高效的 Solidity 代码中，你经常会看到以下模式。从存储变量读取至少需要100 gas，因为 Solidity 不会缓存存储读取。写入要昂贵得多。因此，你应该手动缓存变量，以便仅进行一次存储读取和一次存储写入。

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Counter1 {
    uint256 public number;

    function increment() public {
        require(number < 10);
        number = number + 1;
    }
}

contract Counter2 {
    uint256 public number;

    function increment() public {
        uint256 _number = number;
        require(_number < 10);
        number = _number + 1;
    }
}
```
第一个函数读取了两次计数器，而第二个代码只读取了一次。


3. 打包相关变量

将相关变量打包到同一个槽位中可以通过最小化昂贵的存储相关操作来减少 gas 成本。

**手动打包是最高效的**

我们通过位移操作将两个 uint80 值存储在一个变量（uint160）中。这样只使用一个存储槽位，在单个事务中存储或读取各个值时更便宜。


```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract GasSavingExample {
    uint160 public packedVariables;

    function packVariables(uint80 x, uint80 y) external {
        packedVariables = uint160(x) << 80 | uint160(y);
    }

    function unpackVariables() external view returns (uint80, uint80) {
        uint80 x = uint80(packedVariables >> 80);
        uint80 y = uint80(packedVariables);
        return (x, y);
    }
}
```

**EVM 打包略微低效**

这个示例与上面的示例一样使用了一个槽位，但在单个事务中存储或读取值时可能稍微昂贵。 这是因为 EVM 会自行进行位移操作。

```
contract GasSavingExample2 {
    uint80 public var1;
    uint80 public var2;

    function updateVars(uint80 x, uint80 y) external {
        var1 = x;
        var2 = y;
    }

    function loadVars() external view returns (uint80, uint80) {
        return (var1, var2);
    }
}
```

**不打包是最低效的**


这种方式没有使用任何优化，在存储或读取值时更昂贵。

与其它示例不同，这里使用了两个存储槽位来存储变量。

```
contract NonGasSavingExample {
    uint256 public var1;
    uint256 public var2;

    function updateVars(uint256 x, uint256 y) external {
        var1 = x;
        var2 = y;
    }

    function loadVars() external view returns (uint256, uint256) {
        return (var1, var2);
    }
}    
```

4. 打包结构体

像打包相关状态变量一样，打包结构体成员可以帮助节省 gas 。（需要注意的是，在 Solidity 中，结构体成员按顺序存储在合约的存储中，从它们初始化的槽位位置开始）。

**未打包的结构体**

未打包的结构体 unpackedStruct 有三个成员，它们将存储在三个单独的槽位中。然而，如果这些成员被打包，只会使用两个槽位，这将使读取和写入结构体成员更便宜。


```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Unpacked_Struct {
    struct unpackedStruct {
        uint64 time; // Takes one slot - although it  only uses 64 bits (8 bytes) out of 256 bits (32 bytes).
        uint256 money; // This will take a new slot because it is a complete 256 bits (32 bytes) value and thus cannot be packed with the previous value.
        address person; // An address occupies only 160 bits (20 bytes).
    }

    // Starts at slot 0
    unpackedStruct details = unpackedStruct(53_000, 21_000, address(0xdeadbeef));

    function unpack() external view returns (unpackedStruct memory) {
        return details;
    }
}
```

**打包的结构体**

我们可以通过打包结构体成员来减少上面示例的 gas 消耗，如下所示。


```
contract Packed_Struct {
    struct packedStruct {
        uint64 time; // In this case, both `time` (64 bits) and `person` (160 bits) are packed in the same slot since they can both fit into 256 bits (32 bytes)
        address person; // Same slot as `time`. Together they occupy 224 bits (28 bytes) out of 256 bits (32 bytes).
        uint256 money; // This will take a new slot because it is a complete 256 bits (32 bytes) value and thus cannot be packed with the previous value.
    }
    
    // Starts at slot 0
    packedStruct details = packedStruct(53_000, address(0xdeadbeef), 21_000);

    function unpack() external view returns (packedStruct memory) {
        return details;
    }
}
```

5. 保持字符串长度小于32字节

在 Solidity 中，字符串是可变长度的动态数据类型，意味着它们的长度可以根据需要进行更改和增长。

如果长度为32字节或更长，它们定义的槽位中存储的是字符串长度 * 2 + 1，而实际数据存储在其它位置（该槽位的 keccak 哈希值）。

然而，如果字符串长度小于32字节，长度 * 2 存储在其存储槽位的最低有效字节中，并且字符串的实际数据从定义它的槽位的最高有效字节开始存储。

**字符串示例（小于32字节）**

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract StringStorage1 {
    // Uses only one slot
    // slot 0: 0x(len * 2)00...(hex"hello")
    // Has smaller gas cost due to size.
    string public exampleString = "hello";

    function getString() public view returns (string memory) {
        return exampleString;
    }
}
```

**字符串示例（大于32字节）**

```
contract StringStorage2 {
    // Length is more than 32 bytes. 
    // Slot 0: 0x00...(length*2+1).
    // keccak256(0x00): stores hex representation of "hello"
    // Has increased gas cost due to size.
    string public exampleString = "This is a string that is slightly over 32 bytes!";

    function getStringLongerThan32bytes() public view returns (string memory) {
        return exampleString;
    }
}
```

我们可以使用以下铸造测试脚本进行测试：

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../src/StringLessThan32Bytes.sol";

contract StringStorageTest is Test {
    StringStorage1 public store1;
    StringStorage2 public store2;

    function setUp() public {
        store1 = new StringStorage1();
        store2 = new StringStorage2();
    }

    function testStringStorage1() public {
        // test for string less than 32 bytes
        store1.getString();
        bytes32 data = vm.load(address(store1), 0); // slot 0
        emit log_named_bytes32("Full string plus length", data); // the full string and its length*2 is stored at slot 0, because it is less than 32 bytes
    }

    function testStringStorage2() public {
        // test for string longer than 32 bytes
        store2.getStringLongerThan32bytes();
        bytes32 length = vm.load(address(store2), 0); // slot 0 stores the length*2+1
        emit log_named_bytes32("Length of string", length);

        // uncomment to get original length as number
        // emit log_named_uint("Real length of string (no. of bytes)", uint256(length) / 2); 
        // divide by 2 to get the original length
        
        bytes32 data1 = vm.load(address(store2), keccak256(abi.encode(0))); // slot keccak256(0)
        emit log_named_bytes32("First string chunk", data1);

        bytes32 data2 = vm.load(address(store2), bytes32(uint256(keccak256(abi.encode(0))) + 1));
        emit log_named_bytes32("Second string chunk", data2);
    }
}
```

6. 从不更新的变量应为不可变的或常量

在 Solidity 中，不打算更新的变量应该是常量或不可变的。

这是因为常量和不可变值直接嵌入到它们所定义的合约的字节码中，不使用存储空间。

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Constants {
    uint256 constant MAX_UINT256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    function get_max_value() external pure returns (uint256) {
        return MAX_UINT256;
    }
}

// This uses more gas than the above contract
contract NoConstants {
    uint256 MAX_UINT256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    function get_max_value() external view returns (uint256) {
        return MAX_UINT256;
    }
}
```

7. 使用映射而不是数组以避免长度检查
当存储你希望按特定顺序组织并使用固定键/索引检索的项目列表或组时，通常使用数组数据结构是常见的做法。但可以实现一个技巧，每次读取时可以节省2000多个 gas
示例：

```
/// get(0) gas cost: 4860 
contract Array {
    uint256[] a;

    constructor() {
        a.push() = 1;
        a.push() = 2;
        a.push() = 3;
    }

    function get(uint256 index) external view returns(uint256) {
        return a[index];
    }
}

/// get(0) gas cost: 2758
contract Mapping {
    mapping(uint256 => uint256) a;

    constructor() {
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
    }

    function get(uint256 index) external view returns(uint256) {
        return a[index];
    }
}
```

8. 使用 unsafeAccess 在数组上避免冗余的长度检查

使用映射来避免 Solidity 在读取数组时进行的长度检查（同时仍然使用数组）的另一种方法是使用 Openzeppelin 的 Arrays.sol 库中的 unsafeAccess 函数。这使开发人员可以直接访问数组中任意给定索引的值，同时跳过长度溢出检查。但是，仅在确保传递给函数的索引不会超过传递的数组的长度时才使用此方法。

9. 在使用大量布尔值时，使用位图而不是布尔值

一个常见的模式，特别是在空投中，是在领取空投或 NFT 时将地址标记为“已使用”。

然而，由于只需要一个位来存储这些信息，而每个存储槽是 256 位，这意味着可以使用一个存储槽存储 256 个标志/布尔值。更多技术信息：[https://www.youtube.com/watch?v=Iv0cPT-7AR8](https://www.youtube.com/watch?v=Iv0cPT-7AR8)，[https://medium.com/donkeverse/hardcore-gas-savings-in-nft-minting-part-3-save-30-000-in-presale-gas-c945406e89f0](https://medium.com/donkeverse/hardcore-gas-savings-in-nft-minting-part-3-save-30-000-in-presale-gas-c945406e89f0)

10. 使用 SSTORE2 或 SSTORE3 存储大量数据

**SSTORE**
SSTORE 是一种 EVM 操作码，允许我们按键值方式存储持久数据。与 EVM 中的所有内容一样，键和值都是 32 字节的值。

写入（SSTORE）和读取（SLOAD）的成本在 gas 消耗方面非常昂贵。写入 32 字节的成本为 22,100 gas ，相当于每字节约 690 gas 。另一方面，写入智能合约的字节码的成本为每字节 200 gas 。

**SSTORE2**
SSTORE2 是一种独特的概念，它使用合约的字节码来写入和存储数据。为了实现这一点，我们利用了字节码的固有属性——不可变性。
SSTORE2 的一些特性：

   - 我们只能写入一次。实际上使用 CREATE 代替 SSTORE。
   - 要读取数据，我们不再使用 SLOAD，而是在存储特定数据的部署地址上调用 EXTCODECOPY。
   - 当需要存储越来越多的数据时，写入数据的成本显著降低。

示例；

- 写入数据
我们的目标是将特定的数据（以字节格式）存储为合约的字节码。为了实现这一目标，我们需要做两件事：

 1. 首先将我们的数据复制到内存中，然后 EVM 会从内存中获取这些数据并将其存储为运行时代码。你可以在我们的文章合约创建代码中了解更多信息。
 2. 返回并存储新部署的合约地址以供将来使用。
    - 我们在下面的代码 0x61000080600a3d393df300 中的四个零（0000）之间添加合约代码大小。因此，如果代码大小为 65，则变为 0x61004180600a3d393df300（0x0041 = 65）。
    - 这个字节码负责我们提到的第一步。
    - 现在我们返回新部署的地址以完成第二步。
最终合约字节码 = 00 + 数据（00 = STOP 被添加以确保字节码不能通过调用地址来执行）

- 读取数据

  - 要获取相关数据，你需要知道存储数据的地址。
  - 如果代码大小为 0，我们会回滚，原因是显而易见的
  - 现在我们只需从相关的起始位置返回合约的字节码，该位置在 1 字节之后（请记住第一个字节是 STOP OPCODE（0x00））
  - 我们还可以使用 CREATE2 来使用预确定的地址，在链上或链外计算指针地址，而无需依赖存储指针。   
参考：[solady](https://github.com/Vectorized/solady/blob/main/src/utils/SSTORE2.sol)

**SSTORE3**

- 写入数据
 SSTORE3 实现了这样一个设计，即新部署的地址与我们提供的数据无关。提供的数据首先使用 SSTORE 存储在存储器中。然后，我们在 CREATE2 中将一个名为 INIT_CODE 的常量作为数据传递，该常量在内部读取存储器中存储的提供的数据以将其部署为代码。

这种设计选择使我们能够通过仅提供盐值（可以少于 20 字节）高效地计算出数据的指针地址。从而使我们能够将指针与其它变量一起打包，从而降低存储成本。

- 读取数据
 我们可以通过提供盐值来轻松计算部署的地址，然后，在接收到指针地址后，使用相同的 EXTCODECOPY 操作码来获取所需的数据

**总结：**

 - SSTORE2 在写操作很少但读操作频繁（且指针 > 14字节）的情况下很有帮助。
 - SSTORE3 在你很少写入但经常读取的情况下更好（且指针 < 14字节）

11. 在适当的情况下使用存储指针而不是内存

在 Solidity 中，存储指针是引用合约存储位置的变量

示例；

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract StoragePointerUnOptimized {
    struct User {
        uint256 id;
        string name;
        uint256 lastSeen;
    }

    constructor() {
        users[0] = User(0, "John Doe", block.timestamp);
    }

    mapping(uint256 => User) public users;

    function returnLastSeenSecondsAgo(uint256 _id) public view returns (uint256) {
        User memory _user = users[_id];
        uint256 lastSeen = block.timestamp - _user.lastSeen;
        return lastSeen;
    }
}
```
上面的代码是一个函数，它返回给定索引处用户的最后一次查看时间。它获取 lastSeen 的值，并将其从当前 block.timestamp 中减去。然后，我们将整个结构体复制到内存中，并获取 lastSeen 的值，用于计算几秒钟前的最后一次查看时间。这种方法可以正常工作，但效率不高，因为我们将整个结构体从存储中复制到内存中，包括我们不需要的变量。只要有一种方法可以只从 lastSeen 存储槽中读取（而无需使用汇编语言）。这就是存储指针的作用

```
// This results in approximately 5,000 gas savings compared to the previous version.
contract StoragePointerOptimized {
    struct User {
        uint256 id;
        string name;
        uint256 lastSeen;
    }

    constructor() {
        users[0] = User(0, "John Doe", block.timestamp);
    }

    mapping(uint256 => User) public users;

    function returnLastSeenSecondsAgoOptimized(uint256 _id) public view returns (uint256) {
        User storage _user = users[_id]; 
        uint256 lastSeen = block.timestamp - _user.lastSeen;
        return lastSeen;
    }
}
```
上述实现与第一个版本相比，节省了约 5,000 gas，这里唯一的变化是将内存更改为存储

12. 避免 ERC20 代币余额变为零，始终保留一小笔金额

这与上面的避免零写入部分有关，但值得单独提出来，因为实现方式有点微妙。

如果一个地址频繁地清空（和重新加载）其账户余额，这将导致大量的零到一的写入操作

13. 从 n 倒数到零，而不是从零到 n 进行计数

当将存储变量设置为零时，会获得退款，因此如果存储变量的最终状态为零，则计数所花费的净 gas 将更少

14. 存储中的时间戳和区块编号不需要是 uint256

一个大小为 uint48 的时间戳可以工作数百万年。一个区块编号每 12 秒递增一次。这应该让你对合理的数字大小有所了解。


