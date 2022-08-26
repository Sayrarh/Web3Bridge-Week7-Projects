import { ethers } from "hardhat";

async function main() {

  //Contract Address: 0xb25FA054028a83C2440eDff6654660d10773fA49

  const MerkleNFT= await ethers.getContractFactory("WordSanctuary");
  const merkleNft = await MerkleNFT.deploy(); //pass in the nft address

  await merkleNft.deployed();

  console.log("The NFT contract Address is:", merkleNft.address);

 //await merkleNft.safeMint("ipfs://QmUpgEXndveyDFkXDQW3dp7ZiaSpZ7X9cfK54XwWwhguG9", hexProof);

  const tokenID = await merkleNft.tokenURI(0);

  console.log(tokenID);
  


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});