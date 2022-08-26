//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IWordSanctuary {
    function safeMint(address to) external returns(uint256);
}