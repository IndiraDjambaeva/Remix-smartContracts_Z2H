// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlipper{

    constructor() payable {
    }
    //1 BNB = 10^18 wei
    //1 BNB = 10^9 gwei
    //0.01 BNB = 10000000 gwei

    event GamePlayed(address player, bool isWinner);

    function playGame(uint8 _option) payable public returns(bool){
        require(_option <=1, "You can choose only 0 (head) or 1 (tail)");
        require(address(this).balance >= msg.value*2, "Smart-contract run out of funds");

        uint256 _output = block.timestamp%2; //pseudorandom

        if (_option == _output){
            payable(msg.sender).transfer(msg.value*2);
            emit GamePlayed(msg.sender, true);
            return true; 
        }
        emit GamePlayed(msg.sender, false); 
        return false;
        
    }

    receive () external payable {

    }
}