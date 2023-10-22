//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0;

/**
 * @title ApeCoin Staking Contract
 * @notice Stake ApeCoin across four different pools that release hourly rewards
 * @author HorizenLabs
 */
interface IApeCoinStaking {

    function depositApeCoin(uint256 _amount, address _recipient) external;
    function depositSelfApeCoin(uint256 _amount) external;
    function claimApeCoin(address _recipient) external;
    function claimSelfApeCoin() external;
}