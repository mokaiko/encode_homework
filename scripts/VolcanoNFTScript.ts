import { ethers, network } from "hardhat";

async function deploy() {
    const [deployer] = await ethers.getSigners();
    console.log("deployer:", deployer.address);
    console.log("balance:", ethers.utils.formatEther(await deployer.getBalance()));

    const myNFT = await (await ethers.getContractFactory("VolcanoNFT")).deploy();
    await myNFT.deployed();
    console.log("NFT deployed to:", network.name, myNFT.address);
}

async function mint() {
    const nft = await (await ethers.getContractAt("VolcanoNFT", "0xf465ed1069b3aaf6cea2014fcb93da64a01ce58d")).mintMyNFT();
    console.log("Minting is complete! Tx:", nft.hash);
}

async function main() {
    await deploy();
    await mint();

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});