import { ethers } from "hardhat";

async function main() {

  const NFT= await ethers.getContractFactory("Ankara4yanga");
  const nft = await NFT.deploy();

  await nft.deployed();

  console.log("The NFT contract Address is:", nft.address);

 // await nft.safeMint("ipfs://QmUpgEXndveyDFkXDQW3dp7ZiaSpZ7X9cfK54XwWwhguG9", hexProof);

  const tokenID = await nft.tokenURI(0);

  console.log(tokenID);
  


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});