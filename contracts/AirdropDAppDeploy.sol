//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

contract BNBVerseToken {
    string public name = "BNBverseToken";
    string public symbol = "BVT";

    uint256 public totalSupply = 10000;

    address public owner;

    mapping(address => uint256) balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor(string memory _name) {
        name = _name;
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough tokens");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}