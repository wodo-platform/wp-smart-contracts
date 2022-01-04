// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract WodoGamingToken is ERC20, ERC20Burnable, Pausable, AccessControlEnumerable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BLOCKER_ROLE = keccak256("BLOCKER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    mapping(address => bool) internal blocklist;

    event Blocked(address indexed _account);
    event UnBlocked(address indexed _account);

    constructor() ERC20("Wodo Gaming Token", "XWGT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // see AccessControl.sol for this one
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(BLOCKER_ROLE, msg.sender);
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

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

     /**
     * @dev Checks if account is blocked
     * @param _account The address to check    
    */
    function isBlocked(address _account) public view returns (bool) {
        return blocklist[_account];
    }

    /**
     * @dev Adds account to block list
     * @param _account The address to block
    */
    function blockAccount(address _account) public virtual onlyRole(BLOCKER_ROLE) {
        blocklist[_account] = true;
        emit Blocked(_account);
    }

    /**
     * @dev Removes account from block list
     * @param _account The address to remove from the block list
    */
    function unBlockAccount(address _account) public virtual onlyRole(BLOCKER_ROLE) {
        blocklist[_account] = false;
        emit UnBlocked(_account);
    }


    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        require (!isBlocked(from), "ERC20Blockable: token transfer rejected. Sender is blocked.");
        require (!isBlocked(to), "ERC20Blockable: token transfer rejected. Receiver is blocked.");
        super._beforeTokenTransfer(from, to, amount);
    }
}