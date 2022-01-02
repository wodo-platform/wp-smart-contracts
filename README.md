<p align="center">
  <a href="https://wodo.io/" target="blank"><img src="https://github.com/wodo-platform/wg-web-ui/blob/master/app/img/_src/branding/logo_purple.png" width="320" alt="Wodo Platform" /></a>
</p>

<div align="center">
<h2> Wodo Gaming Platform Smart Contracts </h2>
</div>

<div align="center">
  <h4>
    <a href="https://wodo.io/">
      Website
    </a>
    <span> | </span>
    <a href="#">
      Product Docs
    </a>
    <span> | </span>
    <a href="#">
      Architecture Docs
    </a>
    <span> | </span>
    <!-- <a href="#"> -->
    <!--   CLI -->
    <!-- </a> -->
    <!-- <span> | </span> -->
    <a href="#/CONTRIBUTING.md">
      Contributing
    </a>
    <span> | </span>
    <a href="https://twitter.com/wodoio">
      Twitter
    </a>
    <span> | </span>
    <a href="https://t.me/wodoio">
      Telegram
    </a>
    <span> | </span>
    <a href="https://discord.gg/fbyns8Egpb">
      Discourd
    </a>
    <span> | </span>
    <a href="https://wodoio.medium.com/">
      Medium
    </a>
    <span> | </span>
    <a href="https://www.reddit.com/r/wodoio">
      Reddit
    </a>
  </h4>
</div>

<h3> Table of Contents </h3> 

- [About](#about)
- [Contracts](#contracts)
  - [Wodo Gaming Token Contract - XWGT](#wodo-gaming-token-contract---xwgt)
  - [Vesting Wallet Contract - Token Distribution Locks](#vesting-wallet-contract---token-distribution-locks)
- [Audits](#audits)
- [Contract Deployment](#contract-deployment)
- [Useful Commands](#useful-commands)
----


# About

This module contains smart contracts implementation of the wodo gaming platform. The smart contracts are developed upon https://openzeppelin.com/ standards - version 4.4.1.

Wodo gaming contracts are located in "contracts/wodo" folder. All other openzeppelin contracts are copied into "contracts" folder in order to deploy the wodo contracts smotthly and run the unit tests properly.

The contracts are deployed to BCS test networks. you can find the deatils and sourcecode of the contracts in the following links

- XWGT Token:     https://testnet.bscscan.com/address/0x726Dc93175B455c1483fD31D2DF15C49275608b4
- Vesting Wallet: https://testnet.bscscan.com/address/0xF97Dca31ecC72b287b8Ac6b1a06589B71652FEc5

# Contracts

As of today, we provide 2 main contracts for wodo gaming token (XWGT) and lock some ditributes shares in our <a href="https://docs.wodo.io/wodo-gaming/tokenomics/wodo-gaming-token"> tokenomics plans</a>. 

## Wodo Gaming Token Contract - XWGT

WodoGamingToken contract - contracts/wodo/WodoGamingToken.sol - is a stanrad ERC20 built upon openzeppelin contracts. It is created with 1B fixed total supply and not possible to mint(generate) additional tokens once the contracts is deployed. It offers token burning , pausing and account blocking functionalties to adress business critical aspects. 

Multiple roles are defined, each allowed to perform different sets of actions described above. Also contract owner is assigned to admin role so that the owner can manage role assigments using the functions available in the contract.

```code
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BLOCKER_ROLE = keccak256("BLOCKER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
```

The initial role assigments are done in the constractor of the contract. The constructor is executed only once during contract deployment so that the owner is granted to admin role

```code
    constructor() ERC20("Wodo Gaming Token", "XWGT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // see AccessControl.sol for this one
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(BLOCKER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
        _mint(msg.sender, 1000000000 * 10 ** decimals()); // mint a fixed total supply of 1 billion tokens. The total supply can not be extended
    }
```

## Vesting Wallet Contract - Token Distribution Locks

This contract - contracts/wodo/WodoVestingWallet.sol -  handles the vesting of Eth and ERC20 tokens for a given beneficiary. Custody of multiple tokens can be given to the contract, which will release the token to the beneficiary following a given vesting schedule.

```code
    constructor(
        address beneficiaryAddress,
        uint64 startTimestamp,
        uint64 durationSeconds
    )
```
startTimestamp is considered as "cliff period". Before the start time no tokens are released for vesting. The value od the start time refers to a future date. Token will be locked on the contracts till the start time. Once the start time is reached, tokens will be released based on durationSeconds formula.

If 10M tokens are locked on the contracts with start time: 6 momths and duration 1 year, the vesting formula runs as below:

- No token release till the start time which is 6 months later than the contract deployment time.
- Once cliff period ends, tokens will be eligible for unlocking and releasing based on 1 year duration, which is 10M/365 = 27397 tokens will be released daily
- Actual transfer occurs to the given beneficiary account when the contract owner calls the release(token) method
- 

Any token transferred to this contract will follow the vesting schedule as if they were locked from the beginning.Consequently, if the vesting has already started, any amount of tokens sent to this contract will (at least partly) be immediately releasable.

# Audits

We plan to manage our auiditing process with Certik https://www.certik.com. Certic team will run a full audit regarding full coarse of security aspects as well as source code integrity to make sure that smart contracts are deployed properly to the BCS mainnet and functions as explained in our documentation.

We will share our audit reports.


# Contract Deployment

Simple deployment scripts are implemented to run deployment and source publishing on BCS test and main networks

-- deploy contracts ---

WogoGamingToken

```shell
$ npx hardhat run --network testnet scripts/deploy_token.js

WGT deployed to: 0x726Dc93175B455c1483fD31D2DF15C49275608b4

```

Verify contract by uploading the source codes

```shell
$ npx hardhat verify --network testnet --contract contracts/wodo/WodoGamingToken.sol:WodoGamingToken 0x726Dc93175B455c1483fD31D2DF15C49275608b4
```

Vesting Wallet

```shell
$ npx hardhat run --network testnet scripts/deploy_vasting_wallet.js 
vestingWallet arguments: address:0x2Ada54c4deEc63a5C629122C673fEcBE38b67fB8 , start:1641118122 , duration:86400
VestingWallet deployed to: 0x59aA28101fe6B8b09755e2320c36741e91Faf3cD
```
Now update parameters address, start and duration with the values printed above in scripts/vesting_wallet_constructor_args.js file

Verify contract by uploading the source codes


```shell
$ npx hardhat verify --network testnet --contract contracts/wodo/WodoVestingWallet.sol:WodoVestingWallet --constructor-args scripts/vesting_wallet_constructor_args.js 0x59aA28101fe6B8b09755e2320c36741e91Faf3cD
```


# Useful Commands

-- start local block chain in new bash console ---

```shell
$ npx hardhat node 
```

-- run tests in the project root-- 

```shell
$ npx hardhat test 
```

-- connect local chain to run some live commands ---

```shell
$ npx hardhat console --network localhost
```
and run some commands in the sessions

const WGT = await ethers.getContractFactory('WodoGamingToken');
const wgt = await WGT.attach('0x5FbDB2315678afecb367f032d93F642f64180aa3')



-- connect local chain to run some js files ---

```shell
$ npx hardhat run --network localhost ./scripts/index.js
```