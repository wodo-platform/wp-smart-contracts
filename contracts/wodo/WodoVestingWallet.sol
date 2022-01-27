// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (finance/VestingWallet.sol)
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/finance/VestingWallet.sol";


/**
 * @title VestingWallet
 * @dev This contract handles the vesting of Eth and ERC20 tokens for a given beneficiary. Custody of multiple tokens
 * can be given to this contract, which will release the token to the beneficiary following a given vesting schedule.
 * The vesting schedule is customizable through the {vestedAmount} function.
 *
 * Any token transferred to this contract will follow the vesting schedule as if they were locked from the beginning.
 * Consequently, if the vesting has already started, any amount of tokens sent to this contract will (at least partly)
 * be immediately releasable.
 */
contract WodoVestingWallet is VestingWallet, Ownable {

    uint64 private _additionalStartTime = 0;

    constructor(
        address beneficiaryAddress,
        uint64 startTimestamp,
        uint64 durationSeconds
    ) VestingWallet (beneficiaryAddress,startTimestamp,durationSeconds){
       
    }

    /**
     * @dev Release the native token (ether) that have already vested.
     *
     * Emits a {TokensReleased} event.
     */
    function release() public virtual override onlyOwner {
         super.release();
    }

    /**
     * @dev Release the tokens that have already vested.
     *
     * Emits a {TokensReleased} event.
     */
    function release(address token) public virtual override onlyOwner {
       super.release(token);
    }

    /**
     * @dev The vesting algorithm can be adjusted in this method
     */
    function _vestingSchedule(uint256 totalAllocation, uint64 timestamp) internal view virtual override returns (uint256) {
        if (timestamp < start()) {
            return 0;
        } else if (timestamp > start() + duration()) {
            return totalAllocation;
        } else {
            return (totalAllocation * (timestamp - start())) / duration();
        }
    }

    /**
    *  extend the lock period by the given positve value as seconds.
    *  eg: The initial start time was set as 1643323714 (Thu Jan 27 2022 22:48:34 GMT+0000) 
    *      and the lock release date needs to be extended for additional 10 days. This method is invoked by the owner
    *      with the value 864000, which is 10 days in seconds, to extend cumulative lock period. 
    *      "start()" method of the actual openzeppelin contract, which is overridden below, takes the  extened
    *      lock value into account while calculating release time in "_vestingSchedule" method above.
    *    
    *  validation-1: the given addedTimeSeconds value should be greater than zero. 
    *  validation-2: the given addedTimeSeconds cannot be less than the previous addedTimeSeconds to prevent the lock period from being moved earlier in time. 
    *  validation-3: if the vesting starts, the lock period can not be extended anymore -> uint64(block.timestamp) >= start()
    *
     */
    function extendLockPeriod(int64 addedTimeSeconds) external virtual onlyOwner {
        // ensures that the added lock period value is greater than zero and the current value so that the total lock value (iniital + added) can not be decreased. 
        require(addedTimeSeconds > 0, "addedTimeSeconds should be greater than zero");
        require(uint64(addedTimeSeconds) > _additionalStartTime, "addedTimeSeconds should be greater than the current addedTimeSeconds .");
        require(uint64(block.timestamp) < start(), "Vesting has already started.The lock time can not be extended.");
        _additionalStartTime = uint64(addedTimeSeconds);
    }

    /**
     * @dev Getter for the start timestamp.
     */
    function start() public view override returns (uint256) {
        return super.start() + additionalStartTime();
    }

    /**
     * @dev Getter for the start timestamp.
     */
    function additionalStartTime() public view virtual returns (uint256) {
        return _additionalStartTime;
    }
}
