# POS共识解析

判断是pos的区块。首先，区块难度是零,区块的nonce是零，unclehash是空区块头的哈希值。时间戳不在检验，extradata限制在32bytes。判断区块号是否是符合eip-1559的即伦敦分叉高度。pos区块也没有叔块。



# POA 

clique共识详解

```go
type Clique struct {
    config      *params.CliqueConfig
    db          ethdb.Database
    recents     *lru.ARCCache     最近区块的snapshot用于加速重组
    signatures  *lru.ARCCache     最近区块的签名用于加速打块
    proposals   map[common.Address]bool  当前正在推行的提案的集合
    signer      common.Address    签名密钥的以太坊地址
    signFn      SignerFn          用于授权哈希的签名函数 
    lock        sync.RWMutex      
}
```

针对于共识引擎需要实现引擎接口的接个函数，函数如下：

```go
type Engine interface {
    //Author 返回给定区块挖矿的以太坊账户地址，也有可能会与区块中携带的地址不同，如果共识引擎是建立在签名的基础上
    Author(header *types.Header) (common.Address,error)
    //VerifyHeader 检测区块头是否与共识规则相匹配
    VerifyHeader(chain ChainHeaderReader,header *types.Header,seal bool) error
    //VerifyHeaders 与 VerifyHeader类似，但是会验证一批当前的区块头
    VerifyHeaders(chain ChainHeaderReader,headers []*types.Header.seals []bool) (chan<- struct{},<-chan error)
    //VerifyUncles 验证给定的区块的叔块是否与给定引擎的共识规则相匹配
    VerifyUncles(chain ChainReader,block *types.Block) error
    //Prepare 根据特定引擎的规则初始化块标头的初始化信息
    Prepare(chain ChainHeaderReader, header *types.Header) error
    //Finalize 运行任意推送过来的交易并修改状态但是不组装区块
    Finalize(chain ChainHeaderReader, header *types.Header, state *state.StateDB, txs []*types.Transaction,uncles []*types.Header)
    //FinalizeAndAssemble 运行任意推送过来的交易并修改状态但是不组装区块
    FinalizeAndAssemble(chain ChainHeaderReader, header *types.Header, state *state.StateDB, txs []*types.Transaction,
		uncles []*types.Header, receipts []*types.Receipt) (*types.Block, error)
    //Seal 为给定的输入块生成新的封装请求，并将结果推送到给定的通道中。
    Seal(chain ChainHeaderReader, block *types.Block, results chan<- *types.Block, stop <-chan struct{}) error
    //SealHash 返回块在封装之前的哈希值。
    SealHash(header *types.Header) common.Hash
    //CalcDifficulty 是难度调整算法。它返回新块应该具有的难度。
    CalcDifficulty(chain ChainHeaderReader, time uint64, parent *types.Header) *big.Int
    
    ...
}

```

下面详细阐述Clique共识算法的方法实现细节：

```go
func (c *Clique) Author(header *types.Header) (common.Address, error) {
	return ecrecover(header, c.signatures)
}

// ecrecover  从签名的区块头中提取以太坊账户地址 
func ecrecover(header *types.Header, sigcache *lru.ARCCache) (common.Address, error) {
	// 通过header的hash在缓存中查询是否缓存过
	hash := header.Hash()
	if address, known := sigcache.Get(hash); known {
		return address.(common.Address), nil
	}
	// 判断区块头携带的extra信息长度
	if len(header.Extra) < extraSeal {
		return common.Address{}, errMissingSignature
	}
	signature := header.Extra[len(header.Extra)-extraSeal:]

	// 提取公钥和以太坊地址
	pubkey, err := crypto.Ecrecover(SealHash(header).Bytes(), signature)
	if err != nil {
		return common.Address{}, err
	}
	var signer common.Address
	copy(signer[:], crypto.Keccak256(pubkey[1:])[12:])
  //将哈希和地址放到缓存里
	sigcache.Add(hash, signer)
	return signer, nil
}
```


验证区块头

```go
func (c *Clique) VerifyHeader(chain consensus.ChainHeaderReader, header *types.Header, seal bool) error {
	return c.verifyHeader(chain, header, nil)
}

func (c *Clique) verifyHeader(chain consensus.ChainHeaderReader, header *types.Header, parents []*types.Header) error {
	if header.Number == nil {
		return errUnknownBlock
	}
	number := header.Number.Uint64()

	// 当区块的时间戳超出当前时间则无需校验
	if header.Time > uint64(time.Now().Unix()) {
		return consensus.ErrFutureBlock
	}
    
   // 检查点区块需要强制零受益人 
	checkpoint := (number % c.config.Epoch) == 0
	if checkpoint && header.Coinbase != (common.Address{}) {
		return errInvalidCheckpointBeneficiary
	}
	
	// 区块的nonce必须是0x00..0 或 0xff..f，在检查点必须强制是0
	if !bytes.Equal(header.Nonce[:], nonceAuthVote) && !bytes.Equal(header.Nonce[:], nonceDropVote) {
		return errInvalidVote
	}
	if checkpoint && !bytes.Equal(header.Nonce[:], nonceDropVote) {
		return errInvalidCheckpointVote
	}
	
	// 检查携带信息都包含签名32字节前缀 和 签名
	if len(header.Extra) < extraVanity {
		return errMissingVanity
	}
	if len(header.Extra) < extraVanity+extraSeal {
		return errMissingSignature
	}
	
	// 确认携带的信息除了检查点的签名信息并不高含其他
	signersBytes := len(header.Extra) - extraVanity - extraSeal
	if !checkpoint && signersBytes != 0 {
		return errExtraSigners
	}
	if checkpoint && signersBytes%common.AddressLength != 0 {
		return errInvalidCheckpointSigners
	}
	
	// 确认混合摘要为零，因为没有分叉保护
	if header.MixDigest != (common.Hash{}) {
		return errInvalidMixDigest
	}
	
	// 确保区块并不包含叔块
	if header.UncleHash != uncleHash {
		return errInvalidUncleHash
	}

	// 确保区块的难度是有意义的
	if number > 0 {
		if header.Difficulty == nil || (header.Difficulty.Cmp(diffInTurn) != 0 && header.Difficulty.Cmp(diffNoTurn) != 0) {
			return errInvalidDifficulty
		}
	}
	
	// 验证gas限制小于2^63-1
	if header.GasLimit > params.MaxGasLimit {
		return fmt.Errorf("invalid gasLimit: have %v, max %v", header.GasLimit, params.MaxGasLimit)
	}
	// 所有的检测都通过，验证硬分支的任何特殊领域
	// If all checks passed, validate any special fields for hard forks
	if err := misc.VerifyForkHashes(chain.Config(), header, false); err != nil {
		return err
	}
	// All basic checks passed, verify cascading fields
	// 所有基础的检查都通过，验证级联字段
	return c.verifyCascadingFields(chain, header, parents)
}


func (c *Clique) verifyCascadingFields(chain consensus.ChainHeaderReader, header *types.Header, parents []*types.Header) error {
	// 如果是创世区块就直接通过
	number := header.Number.Uint64()
	if number == 0 {
		return nil
	}
	
	// 确认区块的时间戳不能太过邻近它的之前区块
	var parent *types.Header
	if len(parents) > 0 {
		parent = parents[len(parents)-1]
	} else {
		parent = chain.GetHeader(header.ParentHash, number-1)
	}
	if parent == nil || parent.Number.Uint64() != number-1 || parent.Hash() != header.ParentHash {
		return consensus.ErrUnknownAncestor
	}
	if parent.Time+c.config.Period > header.Time {
		return errInvalidTimestamp
	}
	
	// 验证使用的gas小于gas限制
	if header.GasUsed > header.GasLimit {
		return fmt.Errorf("invalid gasUsed: have %d, gasLimit %d", header.GasUsed, header.GasLimit)
	}
	if !chain.Config().IsLondon(header.Number) {
		// Verify BaseFee not present before EIP-1559 fork.
		if header.BaseFee != nil {
			return fmt.Errorf("invalid baseFee before fork: have %d, want <nil>", header.BaseFee)
		}
		if err := misc.VerifyGaslimit(parent.GasLimit, header.GasLimit); err != nil {
			return err
		}
	} else if err := misc.VerifyEip1559Header(chain.Config(), parent, header); err != nil {
		// Verify the header's EIP-1559 attributes.
		return err
	}
	
	// 检查需要验证的区块头的快照并且缓存
	snap, err := c.snapshot(chain, number-1, header.ParentHash, parents)
	if err != nil {
		return err
	}
	
	// 如果区块是检查点区块，需要验证签名列表
	// 对于检查区块是区块号对设置的epoch取余，等于零就是检测点区块
	if number%c.config.Epoch == 0 {
		signers := make([]byte, len(snap.Signers)*common.AddressLength)
		for i, signer := range snap.signers() {
			copy(signers[i*common.AddressLength:], signer[:])
		}
		extraSuffix := len(header.Extra) - extraSeal
		if !bytes.Equal(header.Extra[extraVanity:extraSuffix], signers) {
			return errMismatchingCheckpointSigners
		}
	}
	
	// 所有基础检测都通过，验证seal并返回
	return c.verifySeal(snap, header, parents)
}


func (c *Clique) snapshot(chain consensus.ChainHeaderReader, number uint64, hash common.Hash, parents []*types.Header) (*Snapshot, error) {

	var (
		headers []*types.Header
		snap    *Snapshot
	)
	for snap == nil {
		// 首先从内存里检索
		if s, ok := c.recents.Get(hash); ok {
			snap = s.(*Snapshot)
			break
		}
		
		// 如果在磁盘中的检查点快照可以被发现，就使用
		// 判断规则是区块号对1024取余
		if number%checkpointInterval == 0 {
			if s, err := loadSnapshot(c.config, c.signatures, c.db, hash); err == nil {
				log.Trace("Loaded voting snapshot from disk", "number", number, "hash", hash)
				snap = s
				break
			}
		}
		
		
		// 如果是在创世区块，快照就要初始化状态。或者处于没有父级的检查点块，或者区块高度增长到需要重新制定检测点的时候那么考虑信任该检查点并对其进行快照。
		if number == 0 || (number%c.config.Epoch == 0 && (len(headers) > params.FullImmutabilityThreshold || chain.GetHeaderByNumber(number-1) == nil)) {
			checkpoint := chain.GetHeaderByNumber(number)
			if checkpoint != nil {
				hash := checkpoint.Hash()

				signers := make([]common.Address, (len(checkpoint.Extra)-extraVanity-extraSeal)/common.AddressLength)
				for i := 0; i < len(signers); i++ {
					copy(signers[i][:], checkpoint.Extra[extraVanity+i*common.AddressLength:])
				}
				//创建新的快照
				snap = newSnapshot(c.config, c.signatures, number, hash, signers)
				//通过数据库保存
				if err := snap.store(c.db); err != nil {
					return nil, err
				}
				log.Info("Stored checkpoint snapshot to disk", "number", number, "hash", hash)
				break
			}
		}
		
		// 这个区块头没有快照，聚集区块头并且将它挪到后面
		var header *types.Header
		if len(parents) > 0 {
		   // 如果有明确的前驱那就取出来
			header = parents[len(parents)-1]
			if header.Hash() != hash || header.Number.Uint64() != number {
				return nil, consensus.ErrUnknownAncestor
			}
			parents = parents[:len(parents)-1]
		} else {
        // 没有明确的前驱就从数据库里面检索
			header = chain.GetHeader(hash, number)
			if header == nil {
				return nil, consensus.ErrUnknownAncestor
			}
		}
		headers = append(headers, header)
		number, hash = number-1, header.ParentHash
	}
	
	// 找到以前的快照并将pending的区块头压入在快照的前面
	for i := 0; i < len(headers)/2; i++ {
		headers[i], headers[len(headers)-1-i] = headers[len(headers)-1-i], headers[i]
	}
	
   //根据区块头的集合创建一个新的授权快照
   snap, err := snap.apply(headers)
   if err != nil {
		return nil, err
   }
   //将快照添加到lru的缓存中
	c.recents.Add(snap.Hash, snap)

   // 如果我们已经生成了一个信息检查点的快照就保存到磁盘中
	if snap.Number%checkpointInterval == 0 && len(headers) > 0 {
		if err = snap.store(c.db); err != nil {
			return nil, err
		}
		log.Trace("Stored voting snapshot to disk", "number", snap.Number, "hash", snap.Hash)
	}
	return snap, err
}

```

对于检验叔块，VerifyUncles函数，只要区块中携带的叔块数量大于零，就直接报错

对于Prepare函数，说明如下：

```go
func (c *Clique) Prepare(chain consensus.ChainHeaderReader, header *types.Header) error {
	// If the block isn't a checkpoint, cast a random vote (good enough for now)
	header.Coinbase = common.Address{}
	header.Nonce = types.BlockNonce{}

	number := header.Number.Uint64()
   //取当前区块前一区块对应的快照
	snap, err := c.snapshot(chain, number-1, header.ParentHash, nil)
	if err != nil {
		return err
	}
	if number%c.config.Epoch != 0 {
		c.lock.RLock()

		// 收集所有有意义的提案进行投票
		addresses := make([]common.Address, 0, len(c.proposals))
		for address, authorize := range c.proposals {
		   //验证地址是否在授权快照中，只有不在授权列表中的地址
		   //并且添加授权的可以被追加到地址中，一个地址不可以被重复添加到列表中
			if snap.validVote(address, authorize) {
				addresses = append(addresses, address)
			}
		}
		
		// 如果当前区块的打块人在当前提案中，设置区块nonce为授权提案否则撤销授权 
		if len(addresses) > 0 {
			header.Coinbase = addresses[rand.Intn(len(addresses))]
			if c.proposals[header.Coinbase] {
				copy(header.Nonce[:], nonceAuthVote)
			} else {
				copy(header.Nonce[:], nonceDropVote)
			}
		}
		c.lock.RUnlock()
	}

  //设置并计算当前的难度，这里是核心,这里来确定自己是否有出块资格，代码实现原理如下
  /**
  func calcDifficulty(snap *Snapshot, signer common.Address) *big.Int {
	 //判断自己有没有资格出块，如果有返回难度2，没有就返回1
	 if snap.inturn(snap.Number+1, signer) {
		 return new(big.Int).Set(diffInTurn)
	 }
	 return new(big.Int).Set(diffNoTurn)
 }


 // inturn returns if a signer at a given block height is in-turn or not.
  func (s *Snapshot) inturn(number uint64, signer common.Address) bool {
   	//获取签名者的列表
   	signers, offset := s.signers(), 0
   	//遍历这个列表寻找自己再这个列表中的位置
   	for offset < len(signers) && signers[offset] != signer {
		  offset++
	  }
	  //将区块号对签名者列表长度取余，如果与自己再列表中的位置相等，那么就有打块的资格
	 return (number % uint64(len(signers))) == uint64(offset)
  }  
  **/
  
	header.Difficulty = calcDifficulty(snap, c.signer)

	// 确保extra包换所有的信息
	if len(header.Extra) < extraVanity {
		header.Extra = append(header.Extra, bytes.Repeat([]byte{0x00}, extraVanity-len(header.Extra))...)
	}
	header.Extra = header.Extra[:extraVanity]

   //如果到了检查点将所有签名放到区块extra中
	if number%c.config.Epoch == 0 {
		for _, signer := range snap.signers() {
			header.Extra = append(header.Extra, signer[:]...)
		}
	}
	header.Extra = append(header.Extra, make([]byte, extraSeal)...)

	// Mix digest is reserved for now, set to empty
	header.MixDigest = common.Hash{}

	// 确保时间戳是正确的是时间延迟
	parent := chain.GetHeader(header.ParentHash, number-1)
	if parent == nil {
		return consensus.ErrUnknownAncestor
	}
	header.Time = parent.Time + c.config.Period
	if header.Time < uint64(time.Now().Unix()) {
		header.Time = uint64(time.Now().Unix())
	}
	return nil
}
```

对于Finalize函数，仅需要做的是，计算root根，然后填充叔块哈希，这个叔块哈希是空叔块的哈希


对于Seal函数,详情如下：

```go
func (c *Clique) Seal(chain consensus.ChainHeaderReader, block *types.Block, results chan<- *types.Block, stop <-chan struct{}) error {
	header := block.Header()

  //如果是创世区块直接返回错误
	number := header.Number.Uint64()
	if number == 0 {
		return errUnknownBlock
	}
	// 对于周期是0，并且没有交易的情况不封装区块
	if c.config.Period == 0 && len(block.Transactions()) == 0 {
		return errors.New("sealing paused while waiting for transactions")
	}
	// Don't hold the signer fields for the entire sealing procedure
	c.lock.RLock()
	signer, signFn := c.signer, c.signFn
	c.lock.RUnlock()

	// 如果没有授权签名区块就退出
	snap, err := c.snapshot(chain, number-1, header.ParentHash, nil)
	if err != nil {
		return err
	}
	if _, authorized := snap.Signers[signer]; !authorized {
		return errUnauthorizedSigner
	}
	// 如果是签名者中的一员，等待下一个区块
	for seen, recent := range snap.Recents {
		if recent == signer {
			// 签名者在最近的块中，仅当当前块未将其移出时才等待
			// 区块号小于签名人列表的一半，或者签名者所在的位置大于区块号与limit的差
			if limit := uint64(len(snap.Signers)/2 + 1); number < limit || seen > number-limit {
				return errors.New("signed recently, must wait for others")
			}
		}
	}
	// 协议允许我们对区块签名等待我们的时间
	delay := time.Unix(int64(header.Time), 0).Sub(time.Now()) // nolint: gosimple
	if header.Difficulty.Cmp(diffNoTurn) == 0 {
		// 通过比对难度确认自己没出块权限，等待下次出块时间
		wiggle := time.Duration(len(snap.Signers)/2+1) * wiggleTime
		delay += time.Duration(rand.Int63n(int64(wiggle)))

		log.Trace("Out-of-turn signing requested", "wiggle", common.PrettyDuration(wiggle))
	}
	// 对所有东西签名
	sighash, err := signFn(accounts.Account{Address: signer}, accounts.MimetypeClique, CliqueRLP(header))
	if err != nil {
		return err
	}
	copy(header.Extra[len(header.Extra)-extraSeal:], sighash)
	// Wait until sealing is terminated or delay timeout.
	log.Trace("Waiting for slot to sign and propagate", "delay", common.PrettyDuration(delay))
	go func() {
		select {
		case <-stop:
			return
		case <-time.After(delay):
		}

		select {
		case results <- block.WithSeal(header):
		default:
			log.Warn("Sealing result is not read by miner", "sealhash", SealHash(header))
		}
	}()

	return nil
}

```



vote，投票代表授权签字人为修改授权列表而进行的一次投票。
包含如下结构：

```go
type Vote struct {
    Signer   common.Address  授权签名人地址
    Block    uint64          投票的所在区块高度
    Address  common.Address  正在投票修改授权的账户     
    Authorize bool           授权或取消授权
}

```

Tally，是一个简单的投票计数器，用来记录当前投票的分数。只统计赞成的票数。

```go
type Tally struct {
    Authorize   bool     赋予授权还是剔除权限
    Votes       int      通过提案的票数
}
```

Snapshot，当前时间点授权投票状态

```go
type Snapshot struct {
 config   *params.CliqueConfig   
 sigcache  *lru.ARCCache    缓存最近的块签名以加速ecrecover
 
 Number   uint64        创建snapshot的区块高度
 Hash     common.Hash   创建snapshot的区块哈希
 Signers  map[common.Address]struct{}  当前授权签名的缓存
 Recents  map[uint64]common.Address    近期签名垃圾邮件的缓存
 Votes   []*Vote                      按时间排序的投票名单
 Tally   map[common.Address]Tally     当前投票统计器避免重复的
}
```

 

