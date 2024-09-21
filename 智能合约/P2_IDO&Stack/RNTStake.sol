// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
contract RNTStake {
    IERC20 public immutable RNT;
    
    uint256 public constant mintSeedPersecond = uint(1 * 1e18) / 1 days;
/**
这里原来用的是1 * 1e18 / 1 days；表示但是一直报错，可能原因是编译器对1e18的识别问题
**/
    // uint256 public constant dailyTokenAmount = 1e18;
    // uint256 public constant ONE_DAY = 1 days;
    constructor(IERC20 RNT_){
      RNT = RNT_;
    }

    mapping(address=>Stake) stakes;

    struct Stake {
      address staker;
      uint256 lastUpdate;
      uint256 debt;
      uint256 amount;
    }
    
    function stake(uint256 amount) external before {
       require(amount > 0, "amount must be egal");
       require(RNT.transferFrom(msg.sender,address(this),amount), "stake not successful");
       stakes[msg.sender].amount += amount; 
    } 

    function unstake(uint256 amount) external before {
      require(stakes[msg.sender].amount >= amount, "you dont have enough balance");
      stakes[msg.sender].amount -= amount;
      //RNT.transferFrom(address(this),msg.sender,stakes[msg.sender].amount);
      require(RNT.transfer(msg.sender,amount),"unstake not success");
    }

    function claim() external before {
      Stake storage s = stakes[msg.sender];
      uint256 claimValue = s.debt;
      require(claimValue > 0,"nothing to claim");
      s.debt = 0;
      // RNT 改成esRNT
      // RNT.transfer(esRNTContract,claimValue)
      // esRNT合约 mint(msg.sender,claimValue)
      require(RNT.transfer(msg.sender,claimValue));
    }

    modifier before() {
      Stake storage s = stakes[msg.sender];
      if(s.amount == 0 )  return;
      uint256 during = block.timestamp - s.lastUpdate;
      uint256 increase = s.amount * during * mintSeedPersecond;
     // s.debt += increase;//单利
      s.amount += increase; //复利
      s.lastUpdate = block.timestamp;
      _;
    }
} 