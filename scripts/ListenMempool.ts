import { ethers } from "hardhat";
import * as dotenv from 'dotenv';
dotenv.config();

async function listenMempool() {
    const WsProvider = new ethers.providers.WebSocketProvider(process.env.ALCHEMY_Mainnet_API_KEY as string);
    WsProvider.on("pending", (...e) => {
        console.log(e);
    });
}

listenMempool();