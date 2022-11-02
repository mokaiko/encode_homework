const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Test VolcanoCoin Contract", function () {

  /* We define a fixture to reuse the same setup in every test.
     We use loadFixture to run this setup once, snapshot that state,
     and reset Hardhat Network blockchain to that snapshot in every test.
     -volcanoCoin:  address of the deployed contract VolcanoCoin
     -owner:        private key of the deployer account
     -otherAccount  private key of a test account
  */

  async function deployVolcanoCoinFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();
    // Obtain the descriptor (ABI etc.) of the VolcanoCoin contract
    const volcanoCoin = await (await ethers.getContractFactory("VolcanoCoin")).deploy();
    // return contract address and private key of other account than owner
    return { volcanoCoin, owner, otherAccount };
  }

  /** 
   * Tests starts here
  */

  it("Should have initial total supply of 10000", async function () {
    const { volcanoCoin } = await loadFixture(deployVolcanoCoinFixture);
    expect(await volcanoCoin.getTotalSupply()).to.equals(10000);
  });

  it("Should increment by 1000 each time", async function () {
    const { volcanoCoin } = await loadFixture(deployVolcanoCoinFixture);
    await volcanoCoin.increase1000();
    expect(await volcanoCoin.getTotalSupply()).to.equals(11000);
    await volcanoCoin.increase1000();
    expect(await volcanoCoin.getTotalSupply()).to.equals(12000);
    await volcanoCoin.increase1000();
    expect(await volcanoCoin.getTotalSupply()).to.equals(13000);
  });

  // Need to be corrected
  it("Should only allow onwer to increase supply", async function () {
    const { volcanoCoin, owner, otherAccount } = await loadFixture(deployVolcanoCoinFixture);
    console.log("contract addr: %s, \r\nowner: %s, \r\nother: %s", volcanoCoin.address, owner.address, otherAccount.address);

    expect(volcanoCoin.increase1000()).to.be.reverted;
    expect(volcanoCoin.connect(owner).increase1000()).to.be.reverted;
    expect(volcanoCoin.connect(otherAccount).increase1000()).to.be.reverted;
  });
});