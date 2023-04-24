// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BnbVerseTokenAirdrop is ERC20, Ownable {

    mapping(address=>bool) getters;
    address contractAddress=address(this);
    
    constructor(uint _initialSupply) ERC20("BnbVerseToken", "BVT") {
        _mint(contractAddress,_initialSupply);
    }

    modifier alreadyGet(){
        require(!getters[msg.sender],"you are already get!");
        _;
    }

    function addSupply(uint _amount) external onlyOwner {
        _mint(contractAddress, _amount);
    }
 
    function claim() public alreadyGet{
        getters[msg.sender]=true;
        _transfer(contractAddress,msg.sender, 50);
    }
}