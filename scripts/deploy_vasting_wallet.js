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

const cliff_date =  new Date(2022, 12, 31, 23, 59, 59, 0);
const cliff_date_sec = cliff_date.getTime() + 3600000;

//const CLIFF_PERIOD = hre.ethers.BigNumber.from(Math.floor(  (new Date().getTime() / 1000) ) + 86400); // --> total locked duration before vesting starts
const CLIFF_PERIOD = hre.ethers.BigNumber.from(cliff_date_sec/1000); // --> total locked duration before vesting starts


const DURATION = hre.ethers.BigNumber.from(63113904);


const ADDRESS_IN_COSTADY = "0xD08826eAb186689dDc939571640a46fE01478B5C";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  const VestingWallet = await hre.ethers.getContractFactory("WodoVestingWallet");
  
  const companyReserves = hre.ethers.utils.getAddress(ADDRESS_IN_COSTADY);
  console.log("vestingWallet arguments: address:"+ADDRESS_IN_COSTADY+" , start:"+CLIFF_PERIOD+" , duration:"+DURATION);
  const vestingWallet = await VestingWallet.deploy(companyReserves,CLIFF_PERIOD,DURATION);
  await vestingWallet.deployed();
  console.log("VestingWallet deployed to:", vestingWallet.address);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
