import { ethers } from "hardhat";

async function main() {

  //Contract Address:0x3bc9673c4f59511464F915515C5211453CFEFef2
  const Todo = await ethers.getContractFactory("TodoList");
  const todo = await Todo.deploy();

  await todo.deployed();

  console.log(`Todo contract deployed to ${todo.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
