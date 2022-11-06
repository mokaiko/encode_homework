import { ethers, network } from "hardhat";
import { parseEther } from "ethers/lib/utils";

async function deploy() {
    const [deployer, alice, bob] = await ethers.getSigners();
    console.log("deployer:", deployer?.address);
    console.log("alice:", alice?.address);
    console.log("bob:", bob?.address);
    console.log("balance:", ethers.utils.formatEther(await deployer.getBalance()));

    const Nft = await ethers.getContractFactory("VolcanoNFT_V2");
    console.log("Done 'getContractFactory'");
    const nft = await Nft.deploy();
    console.log("Done 'deploy'");
    await nft.deployed();
    console.log("NFT v2 deployed to:", network.name, nft.address);
    //const nft = Nft.attach("0xb67d31042a8aec97f1cc27c29f80f3894fad136d");

    const VolcanoCoin = await ethers.getContractFactory("VolcanoCoin");
    const volcanoCoin = VolcanoCoin.attach(await nft.volcano() as string);
    console.log("erc20 contract addr:", volcanoCoin.address);

    return { nft, volcanoCoin, deployer, alice, bob };
}

async function mintWithETH(_nft: any, _user: any) {
    const mintNft = await _nft.connect(_user).mintNftWithETH({ value: parseEther("0.0001") });
    await mintNft.wait();
    console.log("Minting with ETH is complete! Tx:", mintNft.hash);
}

async function mintWithErc20(_nft: any, _erc20: any, _user: any) {
    const userFaucet = await _erc20.connect(_user).faucet();
    await userFaucet.wait();
    console.log("got faucet tx hash:", userFaucet.hash);
    const userApprove = await _erc20.connect(_user).approve(_nft.address, parseEther("10000"));
    await userApprove.wait();
    console.log("approved tx hash:", userApprove.hash);
    const aliceNft = await _nft.connect(_user).mintNftWithERC20();
    await aliceNft.wait();
    console.log("Minting with ERC20 is complete! tx hash:", aliceNft.hash);
}

async function transferNft(_nft: any, _user1: any, _user2: any) {
    console.log("before transfer, owner:", await _nft.ownerOf(1));
    const tx = await _nft.connect(_user1).transferFrom(_user1.address, _user2.address, 1);
    await tx.wait();
    console.log("transfer hash:", tx.hash);
    console.log("after tansfer, owner:", await _nft.ownerOf(1));
}

async function main() {
    const { nft, volcanoCoin, deployer, alice, bob } = await deploy();
    await mintWithETH(nft, deployer);
    await mintWithErc20(nft, volcanoCoin, deployer);
    await transferNft(nft, deployer, alice);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});