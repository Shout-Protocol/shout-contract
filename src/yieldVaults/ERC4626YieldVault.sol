// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IShoutYieldVault.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC4626.sol";

contract ERC4626YieldVault is IShoutYieldVault {

    IERC4626 private _yieldToken;
    uint256 private _deposited;

    constructor(address yieldToken_) {
        _yieldToken = IERC4626(yieldToken_);
    }

    function deposit(uint amount) external override {
        IERC20 _token = IERC20(token());
        _token.transferFrom(msg.sender, address(this), amount);
        _yieldToken.deposit(amount, msg.sender);

        _deposited += amount;
        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint amount) external override {
        _yieldToken.withdraw(amount, msg.sender, address(this));

        _deposited -= amount;
        emit Withdrew(msg.sender, amount);
    }

    function withdrawYield(uint amount) external override {
        uint yieldAmount = getYieldAmount();
        require(amount <= yieldAmount, "ERC4626YieldVault: insufficient yield");

        _yieldToken.withdraw(amount, msg.sender, address(this));
        emit Withdrew(msg.sender, amount);
    }

    // Read function
    function getDepositedAmount() public view returns(uint amount) {
        return _deposited;
    }

    function getYieldAmount() public view returns(uint amount) {
        return getTotalAmount() - getDepositedAmount();
    }

    function getTotalAmount() public view returns(uint amount) {
        return _yieldToken.previewWithdraw(_deposited);
    }

    function token() public view override returns(address) {
        return address(_yieldToken.asset());
    }
}
