// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract erc is ERC20 {
    constructor() ERC20("Token", "TKN") {}

    function mint(address addr, uint256 amount) external {
        _mint(addr, amount);
    }
}