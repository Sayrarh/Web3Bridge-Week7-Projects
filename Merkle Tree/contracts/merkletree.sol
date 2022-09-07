// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./INFT.sol";

contract Merkle{
    IWordSanctuary nftAddr;
    bytes32 public merkleRoot = 0x36aa3b65c321d69df189e026faa86d44b415330c17ac0e26045ead2284c63a6b;
    mapping(address => bool) public whitelistClaimed;

    constructor(IWordSanctuary _nftAddr) {
        nftAddr = _nftAddr;
    }
        
    function checkInWhitelist(bytes32[] calldata proof) public {
        require(!whitelistClaimed[msg.sender], "Address already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(proof, merkleRoot, leaf),
            "You are not among the whitelisted Addresses"
        );
        nftAddr.safeMint(msg.sender);
        whitelistClaimed[msg.sender] = true;
    }
}