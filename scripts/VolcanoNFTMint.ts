import { ethers, network } from "hardhat";

(async () => {
    const nft = await (await ethers.getContractAt("VolcanoNFT", "0xf465ed1069b3aaf6cea2014fcb93da64a01ce58d")).mintMyNFT();
    console.log("Minting is complete! Tx:", nft.hash);
})();