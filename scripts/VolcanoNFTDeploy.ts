import { ethers, network } from "hardhat";

(async () => {
    const [deployer] = await ethers.getSigners();
    console.log("deployer:", deployer.address);
    console.log("balance:", ethers.utils.formatEther(await deployer.getBalance()));

    const myNFT = await (await ethers.getContractFactory("VolcanoNFT")).deploy();
    await myNFT.deployed();
    console.log("NFT deployed to:", network.name, myNFT.address);
})();