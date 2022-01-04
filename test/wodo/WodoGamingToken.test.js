const { BN, constants, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ZERO_ADDRESS } = constants;

const {
  shouldBehaveLikeERC20,
  shouldBehaveLikeERC20Transfer,
  shouldBehaveLikeERC20Approve,
} = require('./WodoGamingToken.behavior');

const WodoGamingToken = artifacts.require('WodoGamingToken');

contract('WodoGamingToken', function (accounts) {
  const [ initialHolder, recipient, anotherAccount ] = accounts;

  const name = 'Wodo Gaming Token';
  const symbol = 'XWGT';

  const initialSupply = new BN(1000000000);

  beforeEach(async function () {
    this.token = await WodoGamingToken.new();
  });

  it('has a name', async function () {
    expect(await this.token.name()).to.equal(name);
  });

  it('has a symbol', async function () {
    expect(await this.token.symbol()).to.equal(symbol);
  });

  it('has 18 decimals', async function () {
    expect(await this.token.decimals()).to.be.bignumber.equal('18');
  });

});
