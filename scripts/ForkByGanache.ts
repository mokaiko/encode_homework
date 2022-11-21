import { ethers, network } from "hardhat";

(async () => {
    const address0 = '0x389E1123d517816b450171869a3C423d541A8B9D';  // account 0
    const addressV = '0xd8da6bf26964af9d7eed9e03e53415d37aa96045'; // vitalik.eth

    const lastBlockHeight = await ethers.provider.getBlockNumber();
    console.log("Block height:", lastBlockHeight);

    const balance = await ethers.provider.getBalance(address0);
    console.log("Before, Account 0 balance:", ethers.utils.formatEther(balance));

    const balanceV = await ethers.provider.getBalance(addressV);
    console.log("Before, V's balance:", ethers.utils.formatEther(balanceV));

    const tx = await ethers.provider.getSigner().sendTransaction({ to: address0, value: ethers.utils.parseEther("1") });
    await tx.wait();
    console.log("tx:", tx.hash);

    const balanceAfter = await ethers.provider.getBalance(address0);
    console.log("After transfer, Account 0 balance:", ethers.utils.formatEther(balanceAfter));

    const balanceVAfter = await ethers.provider.getBalance(addressV);
    console.log("After transfer, V's balance:", ethers.utils.formatEther(balanceVAfter));
})();

// Or Fork mainnet by ganache
// npx ganache-cli --f https://mainnet.infura.io/v3/<api key> --unlock 0xd8da6bf26964af9d7eed9e03e53415d37aa96045

// Run scripts
// npx hardhat run scripts/ForkByGanache.ts --network localhost