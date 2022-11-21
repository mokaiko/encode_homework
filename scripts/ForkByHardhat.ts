import { ethers, network } from "hardhat";

(async () => {
    const address0 = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';  // account 0
    const addressV = '0xd8da6bf26964af9d7eed9e03e53415d37aa96045'; // vitalik.eth

    const lastBlockHeight = await ethers.provider.getBlockNumber();
    console.log("Block height:", lastBlockHeight);

    const balance = await ethers.provider.getBalance(address0);
    console.log("Before, Account 0 balance:", ethers.utils.formatEther(balance));

    const balanceV = await ethers.provider.getBalance(addressV);
    console.log("Before, V's balance:", ethers.utils.formatEther(balanceV));

    const impersonatedSigner = await ethers.getImpersonatedSigner(addressV);
    console.log("Impersonated V's balance:", ethers.utils.formatEther(await impersonatedSigner.getBalance()));
    const tx = await impersonatedSigner.sendTransaction({ to: address0, value: ethers.utils.parseEther("1") });
    await tx.wait();
    console.log("tx:", tx.hash);

    const balanceAfter = await ethers.provider.getBalance(address0);
    console.log("After transfer, Account 0 balance:", ethers.utils.formatEther(balanceAfter));

    const balanceVAfter = await ethers.provider.getBalance(addressV);
    console.log("After transfer, V's balance:", ethers.utils.formatEther(balanceVAfter));
})();

// Fork mainnet by hardhat
// npx hardhat node --fork https://mainnet.infura.io/v3/xxxxx

// Run scripts
// npx hardhat run scripts/ForkByGanache.ts--network localhost