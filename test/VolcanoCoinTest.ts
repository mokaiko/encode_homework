import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("Test VolcanoCoin contract", async () => {
    async function deployVolcanoFixture() {
        const [deployer, alice, bob] = await ethers.getSigners();
        console.log("deployer: %s, \r\naddress1: %s, \r\naddress2: %s", deployer.address, alice.address, bob.address);
        const volcano = await (await ethers.getContractFactory("VolcanoCoin")).deploy();
        console.log("contract addr:", volcano.address);
        return { volcano, deployer, alice, bob };
    }

    it("Should get faucet", async () => {
        const { volcano, alice, bob } = await loadFixture(deployVolcanoFixture);
        await volcano.connect(alice).faucet();
        expect(await volcano.balanceOf(alice.address)).to.equals(ethers.utils.parseEther("100"));

        await volcano.connect(bob).faucet();
        await volcano.connect(bob).faucet();
        expect(await volcano.balanceOf(bob.address)).to.equals(ethers.utils.parseEther("200"));
    });


});