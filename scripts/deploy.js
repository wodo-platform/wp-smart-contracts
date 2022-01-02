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
const TODAY_SECONDS = hre.ethers.BigNumber.from(Math.floor(new Date().getTime() / 1000));
const DURATION = hre.ethers.BigNumber.from(60);
const ADDRESS_IN_COSTADY = "0x2Ada54c4deEc63a5C629122C673fEcBE38b67fB8";

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

  const VestingWallet = await hre.ethers.getContractFactory("VestingWallet");

  const companyReserves = hre.ethers.utils.getAddress(ADDRESS_IN_COSTADY);
  console.log("vestingWallet arguments: address:"+ADDRESS_IN_COSTADY+" , start:"+TODAY_SECONDS+" , duration:"+DURATION);
  const vestingWallet = await VestingWallet.deploy(companyReserves,TODAY_SECONDS,DURATION);
  await vestingWallet.deployed();
  console.log("VestingWallet deployed to:", vestingWallet.address);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
