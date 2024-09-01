# solidity是如何被EVM读懂并执行的

首先先展示一个智能合约的形式来阐述，以remix默认的一个智能合约为例：

```
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Storage {

    uint256 number;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
}
```
1. 那么这个智能合约是如何被evm解析并按照一定的逻辑进行的呢？

solidity 代码在部署到以太坊网络之前需要被编译成字节码。这个字节码对应的是 evm 所解析的一系列操作码指令。上面这段智能合约编译成bytecode内容如下：

```
{
	"functionDebugData": {},
	"generatedSources": [],
	"linkReferences": {},
	"object": "608060405234801561001057600080fd5b50610150806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80632e64cec11461003b5780636057361d14610059575b600080fd5b610043610075565b60405161005091906100a1565b60405180910390f35b610073600480360381019061006e91906100ed565b61007e565b005b60008054905090565b8060008190555050565b6000819050919050565b61009b81610088565b82525050565b60006020820190506100b66000830184610092565b92915050565b600080fd5b6100ca81610088565b81146100d557600080fd5b50565b6000813590506100e7816100c1565b92915050565b600060208284031215610103576101026100bc565b5b6000610111848285016100d8565b9150509291505056fea2646970667358221220522334dfd7decc643eeb644e28d6d7f11bae5f5b74d14e33980a35d12bc7771f64736f6c63430008110033",
	"opcodes": "PUSH1 0x80 PUSH1 0x40 MSTORE CALLVALUE DUP1 ISZERO PUSH2 0x10 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH2 0x150 DUP1 PUSH2 0x20 PUSH1 0x0 CODECOPY PUSH1 0x0 RETURN INVALID PUSH1 0x80 PUSH1 0x40 MSTORE CALLVALUE DUP1 ISZERO PUSH2 0x10 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH1 0x4 CALLDATASIZE LT PUSH2 0x36 JUMPI PUSH1 0x0 CALLDATALOAD PUSH1 0xE0 SHR DUP1 PUSH4 0x2E64CEC1 EQ PUSH2 0x3B JUMPI DUP1 PUSH4 0x6057361D EQ PUSH2 0x59 JUMPI JUMPDEST PUSH1 0x0 DUP1 REVERT JUMPDEST PUSH2 0x43 PUSH2 0x75 JUMP JUMPDEST PUSH1 0x40 MLOAD PUSH2 0x50 SWAP2 SWAP1 PUSH2 0xA1 JUMP JUMPDEST PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST PUSH2 0x73 PUSH1 0x4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH2 0x6E SWAP2 SWAP1 PUSH2 0xED JUMP JUMPDEST PUSH2 0x7E JUMP JUMPDEST STOP JUMPDEST PUSH1 0x0 DUP1 SLOAD SWAP1 POP SWAP1 JUMP JUMPDEST DUP1 PUSH1 0x0 DUP2 SWAP1 SSTORE POP POP JUMP JUMPDEST PUSH1 0x0 DUP2 SWAP1 POP SWAP2 SWAP1 POP JUMP JUMPDEST PUSH2 0x9B DUP2 PUSH2 0x88 JUMP JUMPDEST DUP3 MSTORE POP POP JUMP JUMPDEST PUSH1 0x0 PUSH1 0x20 DUP3 ADD SWAP1 POP PUSH2 0xB6 PUSH1 0x0 DUP4 ADD DUP5 PUSH2 0x92 JUMP JUMPDEST SWAP3 SWAP2 POP POP JUMP JUMPDEST PUSH1 0x0 DUP1 REVERT JUMPDEST PUSH2 0xCA DUP2 PUSH2 0x88 JUMP JUMPDEST DUP2 EQ PUSH2 0xD5 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP JUMP JUMPDEST PUSH1 0x0 DUP2 CALLDATALOAD SWAP1 POP PUSH2 0xE7 DUP2 PUSH2 0xC1 JUMP JUMPDEST SWAP3 SWAP2 POP POP JUMP JUMPDEST PUSH1 0x0 PUSH1 0x20 DUP3 DUP5 SUB SLT ISZERO PUSH2 0x103 JUMPI PUSH2 0x102 PUSH2 0xBC JUMP JUMPDEST JUMPDEST PUSH1 0x0 PUSH2 0x111 DUP5 DUP3 DUP6 ADD PUSH2 0xD8 JUMP JUMPDEST SWAP2 POP POP SWAP3 SWAP2 POP POP JUMP INVALID LOG2 PUSH5 0x6970667358 0x22 SLT KECCAK256 MSTORE 0x23 CALLVALUE 0xDF 0xD7 0xDE 0xCC PUSH5 0x3EEB644E28 0xD6 0xD7 CALL SHL 0xAE 0x5F JUMPDEST PUSH21 0xD14E33980A35D12BC7771F64736F6C634300081100 CALLER ",
	"sourceMap": "199:356:0:-:0;;;;;;;;;;;;;;;;;;;"
}
```

以太坊虚拟机是一种基于堆栈的大端虚拟机。以太坊虚拟机是以读取操作码的方式进行工作的，操作码(opcode)的长度为一个字节，按照这个规则将object对应的值是进行分组为：

```
60 80 60 40 52 34 80 15 61 00 10 57 60 00 80 fd 5b 50 61 01 50 80 61 00 20 60 00 39 60 00 f3 fe 60 80 60 40 52 34 80 15 61 00 10 57 60 00 80 fd 5b 50 60 04 36 10 61 00 36 57 60 00 35 60 e0 1c 80 63 2e 64 ce c1 14 61 00 3b 57 80 63 60 57 36 1d 14 61 00 59 57 5b 60 00 80 fd 5b 61 00 43 61 00 75 56 5b 60 40 51 61 00 50 91 90 61 00 a1 56 5b 60 40 51 80 91 03 90 f3 5b 61 00 73 60 04 80 36 03 81 01 90 61 00 6e 91 90 61 00 ed 56 5b 61 00 7e 56 5b 00 5b 60 00 80 54 90 50 90 56 5b 80 60 00 81 90 55 50 50 56 5b 60 00 81 90 50 91 90 50 56 5b 61 00 9b 81 61 00 88 56 5b 82 52 50 50 56 5b 60 00 60 20 82 01 90 50 61 00 b6 60 00 83 01 84 61 00 92 56 5b 92 91 50 50 56 5b 60 00 80 fd 5b 61 00 ca 81 61 00 88 56 5b 81 14 61 00 d5 57 60 00 80 fd 5b 50 56 5b 60 00 81 35 90 50 61 00 e7 81 61 00 c1 56 5b 92 91 50 50 56 5b 60 00 60 20 82 84 03 12 15 61 01 03 57 61 01 02 61 00 bc 56 5b 5b 60 00 61 01 11 84 82 85 01 61 00 d8 56 5b 91 50 50 92 91 50 50 56 fe a2 64 69 70 66 73 58 22 12 20 52 23 34 df d7 de cc 64 3e eb 64 4e 28 d6 d7 f1 1b ae 5f 5b 74 d1 4e 33 98 0a 35 d1 2b c7 77 1f 64 73 6f 6c 63 43 00 08 11 00 33
```
切分完成后根据[此表](https://www.ethervm.io/)规则可以将上面的字节码转换成opcode,在代码中也有所体现，路径为core/vm/opcodes.go转换完成以后的结果就是opcodes的内容。 在以太坊代码中每个opcode都对应有自己的需要执行的函数以及消耗的gas值，该部分在路径core/vm/jump_table.go文件，如图所示：

```
     GAS: {
			execute:     opGas,
			constantGas: GasQuickStep,
			minStack:    minStack(0, 1),
			maxStack:    maxStack(0, 1),
		},
		JUMPDEST: {
			execute:     opJumpdest,
			constantGas: params.JumpdestGas,
			minStack:    minStack(0, 0),
			maxStack:    maxStack(0, 0),
		},
		PUSH1: {
			execute:     opPush1,
			constantGas: GasFastestStep,
			minStack:    minStack(0, 1),
			maxStack:    maxStack(0, 1),
		},
		PUSH2: {
			execute:     makePush(2, 2),
			constantGas: GasFastestStep,
			minStack:    minStack(0, 1),
			maxStack:    maxStack(0, 1),
		},
```

对应函数的详细实现
```
// opPush1 is a specialized version of pushN
func opPush1(pc *uint64, interpreter *EVMInterpreter, scope *ScopeContext) ([]byte, error) {
	var (
		codeLen = uint64(len(scope.Contract.Code))
		integer = new(uint256.Int)
	)
	*pc += 1
	if *pc < codeLen {
		scope.Stack.push(integer.SetUint64(uint64(scope.Contract.Code[*pc])))
	} else {
		scope.Stack.push(integer.Clear())
	}
	return nil, nil
}

```


2.那么在调用合约的时候，又是如何准确找到对应的函数并且执行的呢？

当我们调用一个合约函数时，我们需要 calldata，这些 calldata 指定了我们要调用的函数签名和任何需要传递的参数（入参）。通过读取call data的内容，EVM可以得知需要执行的函数，以及函数的传入值，并作出相应的操作。比如这里的"store(uint256)"和"retrieve()"。当我们想要调用函数store这个函数时，传入的calldata如下：

```
0x6057361d0000000000000000000000000000000000000000000000000000000000000001
```
首先calldata规则如下：
a. **函数选择器：** call data的前4个bytes对应了合约中的某个函数。因此evm通过这4个bytes,可以跳转到相应的函数。
b. **参数读取：** call data是32bytes的整数倍(头4bytes的函数签名除外)，evm通过CALLDATALOAD指令，每次能从32bytes的值，放入stack中
因此将如上的calldata进行拆分，可以拆成如下两个部分：
1.0x6057361d 
2.0x0000000000000000000000000000000000000000000000000000000000000001
而`6057361d`可以在上面的object对应的值中找到。
函数签名形式如下：
```
keccak256("store(uint256)")-> 前4个字节 = 6057361d
keccak256("retrieve()") -> 前4个字节 = 2e64cec1
```

3.在智能合约中是如何实现合约调用合约的？

在我们编写智能合约的时候，通常会引用到其他合约的某些函数来实现自己自定义的功能。那么evm是如何在底层实现合约调用合约的呢，具体的对应的opcode有两种：`CALL，CALLCODE`两个opcode对应到底层代码部分如下：

```
func opCall(pc *uint64, interpreter *EVMInterpreter, scope *ScopeContext) ([]byte, error) {
	stack := scope.Stack
	// Pop gas. The actual gas in interpreter.evm.callGasTemp.
	// We can use this as a temporary value
	temp := stack.pop()
	gas := interpreter.evm.callGasTemp
	// Pop other call parameters.
	addr, value, inOffset, inSize, retOffset, retSize := stack.pop(), stack.pop(), stack.pop(), stack.pop(), stack.pop(), stack.pop()
	toAddr := common.Address(addr.Bytes20())
	// Get the arguments from the memory.
	args := scope.Memory.GetPtr(int64(inOffset.Uint64()), int64(inSize.Uint64()))

  ...
  //最核心的部分就是此处的代码
	ret, returnGas, err := interpreter.evm.Call(scope.Contract, toAddr, args, gas, bigVal)

	if err != nil {
		temp.Clear()
	} else {
		temp.SetOne()
	}
	stack.push(&temp)
	if err == nil || err == ErrExecutionReverted {
		ret = common.CopyBytes(ret)
		scope.Memory.Set(retOffset.Uint64(), retSize.Uint64(), ret)
	}
	scope.Contract.Gas += returnGas

	interpreter.returnData = ret
	return ret, nil
}

evm.Call函数的核心函数实现为

ret, err = evm.interpreter.Run(contract, input, false)

```

而`CALLCODE`对应到的底层函数名为`opCall`，核心函数是`opCallCode`，函数opCallCode中的核心函数为`ret, err = evm.interpreter.Run(contract, input, false)`可以发现无论是哪种方式最后都会汇入同一个函数`Run`,该函数额实现如下：

```
func (in *EVMInterpreter) Run(contract *Contract, input []byte, readOnly bool) (ret []byte, err error) {

	// 此处的evm.depth就是严格控制调用多少层的核心参数
	in.evm.depth++
	defer func() { in.evm.depth-- }()

  //做一些判断，不重要
	...
	
	var (
		op          OpCode        // current opcode
		mem         = NewMemory() // bound memory
		stack       = newstack()  // local stack
		callContext = &ScopeContext{
			Memory:   mem,
			Stack:    stack,
			Contract: contract,
		}
		pc   = uint64(0) // program counter
		cost uint64
		// copies used by tracer
		pcCopy  uint64 // needed for the deferred EVMLogger
		gasCopy uint64 // for EVMLogger to log gas remaining before execution
		logged  bool   // deferred EVMLogger should ignore already logged steps
		res     []byte // result of the opcode execution function
	)
	defer func() {
		returnStack(stack)
	}()
	contract.Input = input

	if in.cfg.Debug {
		defer func() {
			if err != nil {
				if !logged {
					in.cfg.Tracer.CaptureState(pcCopy, op, gasCopy, cost, callContext, in.returnData, in.evm.depth, err)
				} else {
					in.cfg.Tracer.CaptureFault(pcCopy, op, gasCopy, cost, callContext, in.evm.depth, err)
				}
			}
		}()
	}

//对opcode进行循环读取	
for {
		if in.cfg.Debug {
			// Capture pre-execution values for tracing.
			logged, pcCopy, gasCopy = false, pc, contract.Gas
		}
		// Get the operation from the jump table and validate the stack to ensure there are
		// enough stack items available to perform the operation.
		op = contract.GetOp(pc)
		operation := in.cfg.JumpTable[op]
		cost = operation.constantGas // For tracing
		
		//各种检查不甚重要
		...
		
		// 执行读取的当前opcode的对应函数,每次执行都会更新callContext上下文的值
		res, err = operation.execute(&pc, in, callContext)
		if err != nil {
			break
		}
		pc++
	}

	if err == errStopToken {
		err = nil // clear stop token error
	}

	return res, err
}
```

抽象化上面的调用，假设有合约A调用到了B和C

Call()

```js
to = AccountRef(addr)
contract := NewContract(caller, to, value, gas)
 
// 假设有外部账户A，合约账户B和合约账户C
A Call B ——> ContractB
CallerAddress: A
Caller:        A
self:          B
 
B Call C ——> ContractC
CallerAddress: B
Caller:        B
self:          C
```

CallCode()

```js
to = AccountRef(caller.Address())
contract := NewContract(caller, to, value, gas)
 
// 假设有外部账户A，合约账户B和合约账户C
A Call B ——> ContractB
CallerAddress: A
Caller:        A
self:          B
 
B Callcode C ——> ContractC
CallerAddress: B
Caller:        B
self:          B
```



