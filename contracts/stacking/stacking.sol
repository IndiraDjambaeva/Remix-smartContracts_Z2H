// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract erc is ERC20 {
    constructor() ERC20("Main Token", "Token") {}

    function mint(address addr, uint256 amount) external {
        _mint(addr, amount);
    
    }
}

contract Stacking is ERC20 {
    IERC20 stakingToken;

    struct State {
        uint start;
        bool isEnd;
        uint256 amount;
    }

    mapping (address => State) public states;

    uint public  daysStake;
    uint256 public rewardPerTokenStored;

    event Staked(address indexed user, uint256 amount);

    event Withdrawn(address indexed user, uint256 amount, uint256 stAmount);

    event RewardPaid(address indexed user, uint256 reward);

    constructor(
        address addrStakingToken,
        uint countDaysStake,
        uint256 _rewardPerTokenStored 
    ) ERC20("Stake Token", "sToken") {
        require(_rewardPerTokenStored > 0, "Reward amount must be greater than zero");

        stakingToken = IERC20(addrStakingToken);
        rewardPerTokenStored = _rewardPerTokenStored;
        daysStake = countDaysStake * 1 minutes;
    }  
        
    function stake(uint256 amount) external {    
        require(states[msg.sender].start == 0 || states[msg.sender].isEnd, "You have active staking"); 
        require(stakingToken.allowance(msg.sender, address(this)) >= amount, "Allowance your token for address");

        stakingToken.transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
        states[msg.sender] = State(block.timestamp, false, amount);

        emit Staked(msg.sender, amount);
    }


    function withdraw(uint256 amount) external {
        require(!states[msg.sender].isEnd && states[msg.sender].amount >= amount, "You have inactive staking or insufficient funds to withdraw");

        _burn(msg.sender, amount);
        stakingToken.transfer(msg.sender, amount);

        states[msg.sender].amount -= amount;

        emit Withdrawn(msg.sender, amount, states[msg.sender].amount);
    }

    function getReward() external {
        require(!states[msg.sender].isEnd && states[msg.sender].start + daysStake <= block.timestamp, "Staking dont end");

        _burn(msg.sender, states[msg.sender].amount);
        uint256 reward = getBalanceStakes();
        stakingToken.transfer(msg.sender, reward);

        states[msg.sender].amount = 0;
        states[msg.sender].isEnd = true;

        emit RewardPaid(msg.sender, reward);
    }
        
    function getBalanceStakes() public view returns (uint256) {
        return states[msg.sender].amount + states[msg.sender].amount * rewardPerTokenStored / 10**18;
    }
}
        
    