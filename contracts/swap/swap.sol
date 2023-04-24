// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Exchange {
    address tokenAddr;

    constructor(address _tokenADdr) {
        tokenAddr = _tokenADdr;
    }

    function getReserve() public view returns(uint256) {
        return IERC20(tokenAddr).balanceOf(address(this));
    }
    
    function getAmount(
        uint256 inputToken,
        uint256 inputTokenReserve,
        uint256 outputTokenReserve
    ) public pure returns(uint256){
        return outputTokenReserve * inputToken / (inputToken + inputTokenReserve);
    }

    function addLiquidity(uint256 _tokenAmount) external payable {
        if (getReserve() == 0) {
            IERC20(tokenAddr).transferFrom(
                msg.sender, 
                address(this), 
                _tokenAmount
                );
        } else {
            uint256 ethReserve = address(this).balance - msg.value;
            uint256 tokenAmount = msg.value * getReserve() / (ethReserve);
            require(_tokenAmount >= tokenAmount, "...");
            IERC20(tokenAddr).transferFrom(
                msg.sender,
                address(this),
                tokenAmount
            );
            
            _mint(msg.sender, totalSupply() * msg.value/ethReserve);
        }
    }
}