import { ethers } from "hardhat";

async function main() {

  const NFT = await ethers.getContractAt("IAnkara4yanga", "0xe7a28A901CF0F75CF467d54788781a27f043aD51");

  await NFT.safeMint("0x637CcDeBB20f849C0AA1654DEe62B552a058EA87", 0)

  //transfer the nft from my address to the contract address & interact


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
