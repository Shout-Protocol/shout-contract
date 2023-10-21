// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../../src/interfaces/IYieldVault.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC4626.sol";

contract TestYieldVault is IYieldVault {

    IERC20 private _token;
    uint256 private _deposited;
    uint256 private _yieldAmount;

    constructor(address token_) {
        _token = IERC20(token_);
    }

    function deposit(uint amount) external override {
        _token.transferFrom(msg.sender, address(this), amount);
        _deposited += amount;
        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint amount) external override {
        _token.transfer(msg.sender, amount);
        _deposited -= amount;
        emit Withdrew(msg.sender, amount);
    }

    function withdrawYield(uint amount) external override {
        require(amount <= _yieldAmount, "ERC4626YieldVault: insufficient yield");

        _yieldAmount -= amount;
        _token.transfer(msg.sender, amount);
        emit YieldWithdrawn(msg.sender, amount);
    }

    // Read function
    function getDepositedAmount() public view returns(uint amount) {
        return _deposited;
    }

    function getYieldAmount() public view returns(uint amount) {
        return _yieldAmount;
    }

    function getTotalAmount() public view returns(uint amount) {
        return getDepositedAmount() + getYieldAmount();
    }

    function token() external view override returns(address) {
        return address(_token);
    }

    // Test functions
    function increseYieldAmount(uint amount) external {
        _yieldAmount += amount;
    }
}
