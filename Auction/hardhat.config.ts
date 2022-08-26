import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require("dotenv").config();


const config: HardhatUserConfig = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_API_KEY,
      // @ts-ignore
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: "WPSFJ5S9EVIJUYSSVW1G14AJQ578YJ3MCP"
  }
};

export default config;