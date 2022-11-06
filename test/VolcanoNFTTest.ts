import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("Test VolcanoNFT contract", async function () {
    async function deployVolcanoNFTFixture() {
        const [deployer, account1, account2] = await ethers.getSigners();
        console.log("deployer: %s, \r\naddress1: %s, \r\naddress2: %s", deployer.address, account1.address, account2.address);
        const volcanoNFT = await (await ethers.getContractFactory("VolcanoNFT")).deploy();
        console.log("contract addr:", volcanoNFT.address);
        return { volcanoNFT, deployer, account1, account2 };
    }

    it("Should mint new NFTs", async function () {
        const { volcanoNFT, deployer, account1, account2 } = await loadFixture(deployVolcanoNFTFixture);
        await volcanoNFT.mintMyNFT();
        expect(await volcanoNFT.balanceOf(deployer.address)).to.equals(1);
        expect(await volcanoNFT.balanceOf(account1.address)).to.equals(0);
        expect(await volcanoNFT.balanceOf(account2.address)).to.equals(0);
        expect(await volcanoNFT.ownerOf(1)).to.equals(deployer.address);

        await volcanoNFT.connect(account1).mintMyNFT();
        expect(await volcanoNFT.balanceOf(deployer.address)).to.equals(1);
        expect(await volcanoNFT.balanceOf(account1.address)).to.equals(1);
        expect(await volcanoNFT.balanceOf(account2.address)).to.equals(0);
        expect(await volcanoNFT.ownerOf(2)).to.equals(account1.address);

        await volcanoNFT.connect(account2).mintMyNFT();
        expect(await volcanoNFT.balanceOf(deployer.address)).to.equals(1);
        expect(await volcanoNFT.balanceOf(account1.address)).to.equals(1);
        expect(await volcanoNFT.balanceOf(account2.address)).to.equals(1);
        expect(await volcanoNFT.ownerOf(3)).to.equals(account2.address);
    });

    it("Should transfer an NFT", async function () {
        const { volcanoNFT, deployer, account1, account2 } = await loadFixture(deployVolcanoNFTFixture);

        await volcanoNFT.mintMyNFT();

        await volcanoNFT.connect(deployer).transferFrom(deployer.address, account1.address, 1);
        expect(await volcanoNFT.balanceOf(deployer.address)).to.equals(0);
        expect(await volcanoNFT.balanceOf(account1.address)).to.equals(1);
        expect(await volcanoNFT.balanceOf(account2.address)).to.equals(0);

        await volcanoNFT.connect(account1).transferFrom(account1.address, account2.address, 1);
        expect(await volcanoNFT.balanceOf(deployer.address)).to.equals(0);
        expect(await volcanoNFT.balanceOf(account1.address)).to.equals(0);
        expect(await volcanoNFT.balanceOf(account2.address)).to.equals(1);
    });
});
