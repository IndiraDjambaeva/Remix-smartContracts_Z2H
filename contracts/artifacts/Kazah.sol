
//SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Token {
    uint public totalSuppl = 1000000e18;  //1000000 * 10 ** 18

    mapping(address => uint) public balancOF;
    mapping(address => mapping(address => uint)) public allowance;
    mapping (address => bool) public blackList;

    address public owner1;
    string public name = "Kazah";
    string public symbol = "KZ";
    uint public decimal = 18;

    constructor() {
        owner1 = msg.sender;
    }

    function toBlackList(address blackl) external returns (bool){
        require(owner1 == msg.sender, "Only the owner can add to the blacklist");
        require(!blackList[blackl], "The address is already blacklisted");
        blackList[blackl] = true;
        return true;
    }
    
    function fromBlackList(address blackl) external returns (bool){
        require(owner1 == msg.sender, "Only the owner can remove from the blacklist");
        require(blackList[blackl], "The address is not in the blacklist");
        blackList[blackl] = false;
        return true;
    }


    function totalSupply() external view returns(uint){
        return totalSuppl;
    }

    function balanceOF(address account) external view returns(uint){
        return balancOF[account];
    }

    function transfer(address recipient, uint amount) external returns(bool){
        balancOF[msg.sender] -= amount;
        balancOF[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowanc(address owner, address spender) external view returns(uint){
        return allowance[owner][spender];
    }

    function mint() public {
        balancOF[msg.sender] = 500e18;
    }

   
    function approve(address spender, uint amount) external returns(bool){
        allowance[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }



    function transferFrom(address sender, address recipient, uint amount) external returns(bool){
        allowance[sender][recipient] -= amount;
        balancOF[sender] -= amount;
        balancOF[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
    
    event Transfer(address indexed from, address indexed to, uint amount);
    event Approve(address indexed owner, address indexed spender, uint amount);

    function setName(string memory newName) public {

    }


}