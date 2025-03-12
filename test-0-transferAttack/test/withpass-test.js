const hre = require("hardhat");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("WithPass", function () {
  let WithPass;
  let withPass;
  let owner;
  let acc1;
  let attacker;

  beforeEach(async function () {
    WithPass = await ethers.getContractFactory("WithPass");
    [owner, acc1, attacker] = await ethers.getSigners();

    const pwd = ethers.encodeBytes32String("myPass");
    withPass = await WithPass.deploy(owner.address, pwd);
  });

  it("should not allow everyone to pass to withdraw", async () => {
    let initialAcc1Balance = await ethers.provider.getBalance(acc1.address);
    let initialAttackerBalance = await ethers.provider.getBalance(
      attacker.address
    );

    const contractAddr = withPass.target;
    console.log("Contract Address: ", contractAddr);

    let pwd = await hre.network.provider.send("eth_getStorageAt", [
      contractAddr,
      "0x1",
    ]);

    const encoded = ethers.encodeBytes32String("myPass");
    const pwdToBytes = ethers.encodeBytes32String(pwd);

    await withPass.connect(acc1).withdraw(encoded);
    await withPass.connect(attacker).withdraw(pwdToBytes);

    console.log("=================");
    console.log("= password slot= ", pwd);
    console.log("legal: ", encoded);
    console.log("=================");
    console.log("balanceOfAcc1: ", initialAcc1Balance.toString());

    let finalAcc1Balance = await ethers.provider.getBalance(acc1.address);
    let finalAttackerBalance = await ethers.provider.getBalance(
      attacker.address
    );

    console.log("=================");
    console.log("balanceOfAttacker: ", finalAttackerBalance.toString());

    expect(finalAcc1Balance).to.eq(0);
    expect(finalAttackerBalance).to.be.eq(initialAttackerBalance);
  });
});
