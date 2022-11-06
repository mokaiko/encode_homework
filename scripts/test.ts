import { ethers, network } from "hardhat";

(async () => {
    const [deployer, alice, bob] = await ethers.getSigners();
    console.log("deployer:", deployer?.address);

    // for (let i = 3; i <= 4; i++) {
    const tx = await deployer.sendTransaction({ to: alice.address, value: ethers.utils.parseEther("0.00001"), nonce: 4 });

    console.log("tx:", tx.hash);
    tx.wait();
    // }
})();