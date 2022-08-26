import { ethers } from "hardhat";

const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

async function main() {
   // console.log("Obtaining the addresses for hardhat");
    
    //let whiteListedAddresses = await ethers.getSigners();

    let whiteListedAddresses = [
        "0xEB7A41D324ee4859E3cbFAd4b3820B82FCCe6658",
        "0x637CcDeBB20f849C0AA1654DEe62B552a058EA87",
        "0x2e504C9c22089cE75a600fF113e891d2c2D53d57",
        "0x235aAB1caE3D5dfD293aeaEC2CA4C6d0aABabdB2",
        "0xaEAA20f015E2711EfC318C9CC9Afb1b7096FFC9e",
        "0xBb3ecC8cFA0CE4C0fA2a7Fe875fB88A62420973a",
        "0xAEB9219D416D28f2EADB0A6C414E2776Fd9CD879"
    ]

    // Using keccak256 hashing algorithm to hash the leaves of the tree
   // const leafNodes = whiteListedAddresses.map(signer => keccak256(signer.address)); 
    const leafNodes = whiteListedAddresses.map(addr => keccak256(addr)); //this line of code would handle all the hashing

    //Creating a new array of leafNodes by hashing all the indexes of the whitelisted addresses using keccak256
     //Then create a new merkle tree object using keccak256 as the hashing algorithm
     //sortPairs is used incase the leafs is odd in numbers to be able to duplicate and make the 'leafNodes' even
    const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true});

    // obtaining the root hash
    const rootHash = merkleTree.getHexRoot();

    //testing if an address is in the merkle tree
    const claimingAddress = leafNodes[2];
    const hexProof = merkleTree.getHexProof(claimingAddress);

    console.log(`The proof of the inputed address is: ${hexProof}`);

    //We can get a great visual representation of the structure of our tree 
    //by utilizing the toString() method to console log our Merkle Tree.
    console.log("Whitelist Merkle Tree", merkleTree.toString());
    console.log("Root Hash: ", rootHash);


    // Test to see if it works
    console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });