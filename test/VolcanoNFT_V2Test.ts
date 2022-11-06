import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { parseEther } from "ethers/lib/utils";

describe("Test Volcano NFT V2 contract", async () => {
    async function deployVolcanoNFTv2Fixture() {
        const [deployer, alice, bob] = await ethers.getSigners();
        console.log("deployer: %s\r\naddress1: %s\r\naddress2: %s", deployer.address, alice.address, bob.address);
        const VolcanoNFT = await ethers.getContractFactory("VolcanoNFT_V2");

        const volcanoNFT = await VolcanoNFT.deploy();
        await volcanoNFT.deployed();
        console.log("nft contract addr:", volcanoNFT.address);

        const VolcanoCoin = await ethers.getContractFactory("VolcanoCoin");
        const volcanoCoin = VolcanoCoin.attach(await volcanoNFT.volcano() as string);
        console.log("erc20 contract addr:", volcanoCoin.address);
        return { volcanoNFT, volcanoCoin, deployer, alice, bob };
    }

    it("Should mint NFT with ETH", async () => {
        const { volcanoNFT, alice, bob } = await loadFixture(deployVolcanoNFTv2Fixture);
        const aliceNft = await volcanoNFT.connect(alice).mintNftWithETH({ value: parseEther("0.0001") });
        console.log("mint with eth complete! tx:", aliceNft.hash);
        expect(await volcanoNFT.balanceOf(alice.address)).to.equals(1);
        expect(await volcanoNFT.ownerOf(1)).to.equals(alice.address);
        const bobNft = await volcanoNFT.connect(bob).mintNftWithETH({ value: parseEther("0.0001") });
        console.log("mint with eth complete! tx:", bobNft.hash);
        expect(await volcanoNFT.balanceOf(bob.address)).to.equals(1);
        expect(await volcanoNFT.ownerOf(2)).to.equals(bob.address);
    });

    it("Should mint NFT with ERC20 token", async () => {
        const { volcanoNFT, volcanoCoin, alice } = await loadFixture(deployVolcanoNFTv2Fixture);

        await volcanoCoin.connect(alice).faucet();
        expect(await volcanoCoin.balanceOf(alice.address)).to.equals(parseEther("100"));
        await volcanoCoin.connect(alice).approve(volcanoNFT.address, parseEther("10000"));
        expect(await volcanoCoin.allowance(alice.address, volcanoNFT.address)).to.equals(parseEther("10000"));
        const aliceNft = await volcanoNFT.connect(alice).mintNftWithERC20();
        console.log("mint with erc20 token complete! tx:", aliceNft.hash);
        expect(await volcanoCoin.balanceOf(alice.address)).to.equals(parseEther("90"));
        expect(await volcanoNFT.balanceOf(alice.address)).to.equals(1);
        expect(await volcanoNFT.ownerOf(1)).to.equals(alice.address);

    });
});