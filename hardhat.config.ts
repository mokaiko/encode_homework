
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from 'dotenv';
import { string } from "hardhat/internal/core/params/argumentTypes";

dotenv.config();

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY as string;
const GOERLI_PRIVATE_KEY1 = process.env.GOERLI_PRIVATE_KEY1 as string;
const GOERLI_PRIVATE_KEY2 = process.env.GOERLI_PRIVATE_KEY2 as string;
const GOERLI_PRIVATE_KEY3 = process.env.GOERLI_PRIVATE_KEY3 as string;

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY1, GOERLI_PRIVATE_KEY2, GOERLI_PRIVATE_KEY3],
    }
  }
};

export default config;
