const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ClickerV2", function () {
  let clicker, owner, player;

  beforeEach(async function () {
    [owner, player] = await ethers.getSigners();
    const C = await ethers.getContractFactory("ClickerV2");
    clicker = await C.deploy();
  });

  it("should start with zero clicks", async function () {
    expect(await clicker.totalClicks()).to.equal(0);
  });

  it("should start active", async function () {
    expect(await clicker.gameActive()).to.be.true;
  });

  it("should allow click", async function () {
    await clicker.connect(player).click();
    expect(await clicker.totalClicks()).to.equal(1);
  });

  it("should track user stats", async function () {
    await clicker.connect(player).click();
    await clicker.connect(player).click();
    const stats = await clicker.getUserStats(player.address);
    expect(stats.clicks).to.equal(2);
  });

  it("should allow owner to pause", async function () {
    await clicker.setGameActive(false);
    await expect(clicker.connect(player).click()).to.be.revertedWith("Game paused");
  });

  it("should emit Clicked event", async function () {
    await expect(clicker.connect(player).click()).to.emit(clicker, "Clicked");
  });
});
