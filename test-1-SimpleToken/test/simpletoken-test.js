const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require("bignumber.js");

describe("SimpleToken", () => {
  let SimpleToken;
  let contract;

  let deployer;
  let account1;
  let account2;
  let attacker;

  beforeEach(async () => {
    [deployer, account1, account2, attacker] = await ethers.getSigners();

    SimpleToken = await ethers.getContractFactory("SimpleToken");
    contract = await SimpleToken.deploy(deployer, 10000);
  });

  it("Should allow a user to transfer", async () => {
    await contract.transfer(account1.address, 11);
    const _totalSupply = await contract.getTotalSupply();
    const totalSupply = new BigNumber(_totalSupply);

    expect(await contract.getBalanceOf(account1.address)).to.eq(11);
    expect(await contract.getBalanceOf(deployer.address)).to.eq(
      totalSupply - 11
    );
  });

  it.skip("Shouldn't transfer if the balance not enough", async () => {
    await contract.transfer(attacker.address, 10);
    await expect(
      contract.connect(attacker).transfer(account1.address, 11)
    ).to.be.revertedWith("Not enough to transfer");
  });

  it("Should overflow if an attacker transfer an amount of greater than its balance", async () => {
    await contract.transfer(attacker.address, 10);
    await expect(
      contract.connect(attacker).transfer(account1.address, 11)
    ).to.be.revertedWith("Not enough to transfer");
  });
});
