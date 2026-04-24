const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying ClickerV2...");
  const Contract = await ethers.getContractFactory("ClickerV2");
  const contract = await Contract.deploy();
  await contract.waitForDeployment();
  console.log("ClickerV2 deployed to:", await contract.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
