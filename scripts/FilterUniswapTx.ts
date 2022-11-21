import { ethers } from "hardhat";
import * as dotenv from 'dotenv';
dotenv.config();

async function filterUniswapTx() {
    const uniswapRouterV3Address = "0xE592427A0AEce92De3Edee1F18E0157C05861564";
    const WsProvider = new ethers.providers.WebSocketProvider(process.env.ALCHEMY_Mainnet_API_KEY as string);
    WsProvider.on("pending", async (...e) => {
        const tx = await WsProvider.getTransaction(e[0]);
        //console.log(tx);
        if (tx != null && tx.to == uniswapRouterV3Address) {
            console.log(e[0]);
        }
        //console.log("-------");
    });
}

filterUniswapTx();