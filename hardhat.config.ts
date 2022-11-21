
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from 'dotenv';
import { string } from "hardhat/internal/core/params/argumentTypes";

dotenv.config();

const ALCHEMY_Goerli_API_KEY = process.env.ALCHEMY_Goerli_API_KEY as string;
const ALCHEMY_Mainnet_API_KEY = process.env.ALCHEMY_Mainnet_API_KEY as string;

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: ALCHEMY_Goerli_API_KEY,

    },
    mainnet: {
      url: ALCHEMY_Mainnet_API_KEY,
    }
  }
};

export default config;
