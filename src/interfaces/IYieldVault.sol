// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface IYieldVault {

    event Deposited(address indexed user, uint amount);
    event Withdrew(address indexed user, uint amount);
    event YieldWithdrawn(address indexed user, uint amount);

    // Write function
    function deposit(uint amount) external;
    function withdraw(uint amount) external;
    function withdrawYield(uint amount) external;

    // Read function
    function getDepositedAmount() external view returns(uint amount);
    function getTotalAmount() external view returns(uint amount);
    function getYieldAmount() external view returns(uint amount);
    function token() external view returns(address);

}