import { ethers } from "hardhat";

async function main() {

  //Contract Address: 0xe7a28A901CF0F75CF467d54788781a27f043aD51

  const AunctionNFT = await ethers.getContractFactory("Ankara4yanga");
  const nft = await AunctionNFT.deploy();

   await nft.deployed();

   console.log("NFT contract address is :", nft.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
