// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Auto {
    int public number;

    function inc() external {
        number += 1;
    }
}