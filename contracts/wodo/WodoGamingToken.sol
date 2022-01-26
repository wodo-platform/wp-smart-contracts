// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract WodoGamingToken is ERC20, ERC20Burnable, AccessControlEnumerable {

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("Wodo Gaming Token", "XWGT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // see openzeppelin/contracts/access/AccessControlEnumerable.sol for this one
        _grantRole(BURNER_ROLE, msg.sender);
        _mint(msg.sender, 1000000000 * 10 ** decimals()); // mint a fixed total supply of 1 billion tokens. The total supply can not be extended
    }

      /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual override onlyRole(BURNER_ROLE){
       super.burn(amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual override onlyRole(BURNER_ROLE){
        super.burnFrom(account, amount);
    }

}