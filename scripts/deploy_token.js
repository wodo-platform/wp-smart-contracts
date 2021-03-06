// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

const ONE_MILLION = 1000000;
const ONE_BILLION = 1000 * ONE_MILLION;
const TOTAL_SUPPLY = 5 * ONE_BILLION;
const WEI_DECIMALS = 18;
const WEI = 10 ** WEI_DECIMALS;
const WEI_ZEROES = '000000000000000000';

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const WodoGamingToken = await hre.ethers.getContractFactory("WodoGamingToken");
  const wgt = await WodoGamingToken.deploy();
  await wgt.deployed();

  console.log("WGT deployed to:", wgt.address);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
