// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./Exchange.sol";

contract Factory {
    mapping (address => address) public tokenToExchange;

    function createExchange(address _tokenAddress, uint8 fee) external returns (address) {
        require(_tokenAddress != address(0), "...");
        require(tokenToExchange[_tokenAddress] == address(0), "...");

        Exchange exchange = new Exchange(_tokenAddress, fee);
        tokenToExchange[_tokenAddress] = address(exchange);
        return address(exchange);
    }

    function getExchange(address _tokenAddress) external view returns(address) {
        return tokenToExchange[_tokenAddress];
    }
}