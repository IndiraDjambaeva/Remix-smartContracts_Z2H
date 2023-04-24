// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BnbVerseTokenAirdrop is ERC20, Ownable {
    uint public maxTotal = 5000e18;

    mapping(address=>bool) getters;

    constructor() ERC20("BnbVerseToken", "BVT") {

    }

    modifier alreadyGet(){
        require(!getters[msg.sender],"you are already get!");
        _;
    }

    function changeMaxTotal(uint total) external onlyOwner {
        maxTotal = total;
    }
 
    function claim() public alreadyGet{
        require(totalSupply() <= maxTotal,"Total's max");
        require(!getters[msg.sender],"no tokens for you sorry");
        getters[msg.sender]=true;

        _mint(msg.sender, 50e18);

    }

}