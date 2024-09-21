// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// IDO 要求：单价0.0001 eth /rnt  有效期7天 软顶：10eth 硬顶：100eth .超募均分
contract RNTIDO {
    uint256 public constant PRICE = 0.0001 ether;
    uint256 public constant SOFTCAP = 10 ether; //最低募集额度 总量 SOFTCAP / PRICE
    uint256 public constant HARDCAP = 100 ether;//最高募集额度 意味着0.0001ether 最低可领取0.1RNT
    uint256 public immutable END_AT;
    IERC20  public immutable RNT;
    uint256 public constant TOTAL_SUPPLY = 100_000;

    uint256 public totalSold;
    uint256 public totalRaised;
    mapping(address => uint256) public balances;
    event Presale(address indexed user,uint256 amount);

  constructor(IERC20 RNT_){
    END_AT =  block.timestamp + 7 days;
    RNT = RNT_;
  }

  function presale(uint256 amount) external payable{
    require(block.timestamp <= END_AT,"NOT IN Presale Time");
    require(msg.value == amount*PRICE,"invalid amount");
    require(totalRaised+msg.value <= HARDCAP,"hardcap reached");

    totalSold += amount;
    totalRaised += msg.value;
    balances[msg.sender] += amount;

    //require(RNT.balanceOf(address(this)) >= totalSold,"RNT is not enough");
    emit Presale(msg.sender,amount);
  }

  function claim() external {
    require(block.timestamp > END_AT,"not in claim time");
    require(totalSold >= SOFTCAP,"softcap not reached");

    uint256 amount = balances[msg.sender];
    require(amount > 0, "nothing to claim");

    //募集成功，平分
    uint256 share = totalSold / TOTAL_SUPPLY;
    uint256 claimValue = share * amount;
    balances[msg.sender] = 0;
    //可以线性解锁 锁仓x个月
    require(RNT.transfer(msg.sender,claimValue),"RNT claim not success"); 
  }

  function refund() external {
    require(block.timestamp > END_AT,"presale not succeed");
    require(totalSold < SOFTCAP,"presale not succeed");
    uint256 amount = balances[msg.sender];
    require(amount > 0, "notning to refund");
    balances[msg.sender] = 0;
    uint256 refundAmount = amount * PRICE;
    (bool success,) = msg.sender.call{value:refundAmount}("");
    require(success,"failed");
  }

  function withdraw() external {
    require(block.timestamp >= END_AT,"not in claim time");
    require(totalRaised >= SOFTCAP,"presale not succeed");

    (bool success,) = msg.sender.call{value:totalRaised}("");
     require(success,"withdraw failed");
     //要求将筹集到的资金的xx%,自动添加到dex做流动性
     //并burn掉lp token
  }

}