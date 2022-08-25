// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./INFT.sol";

contract Merkle{
    IAnkara4yanga nftAddr;
    bytes32 public merkleRoot;
    mapping(address => bool) public whitelistClaimed;

    constructor(IAnkara4yanga _nftAddr) {
        nftAddr = _nftAddr;
    }
        
    function checkInWhitelist(bytes32[] calldata proof) public {
        require(!whitelistClaimed[msg.sender], "Address already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(proof, merkleRoot, leaf),
            "Invalid Merkle Proof."
        );
        nftAddr.safeMint(msg.sender);
        whitelistClaimed[msg.sender] = true;
    }
}