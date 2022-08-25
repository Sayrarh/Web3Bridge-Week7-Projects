import { ethers } from "hardhat";

const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

async function main() {
    console.log("Obtaining the addresses for hardhat");
    
    let whiteListedAddresses = await ethers.getSigners();

    // Using keccak256 hashing algorithm to hash the leaves of the tree
    const leafNodes = whiteListedAddresses.map(signer => keccak256(signer.address)); //this line of code would handle all the hashing

    // Creating the merkle tree object
    const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true});

    // obtaining the root hash
    const rootHash = merkleTree.getHexRoot();

    //testing if an address is in the merkle tree
    const claimingAddress = leafNodes[0];
    const hexProof = merkleTree.getHexProof(claimingAddress);

    console.log(`The proof of the inputed address is: ${hexProof}`);

    // printing the merkle tree on the console
    console.log("Whitelist Merkle Tree", merkleTree.toString());
    console.log("Root Hash: ", rootHash);

    // User address, the proof (this would be gotten using the merkle tree object) and the root hash

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });