// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IShoutYieldVault.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC4626.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC4626YieldVault is IShoutYieldVault, Ownable {

    IERC4626 private _yieldToken;
    uint256 private _deposited;

    constructor(address yieldToken_) Ownable(msg.sender) {
        _yieldToken = IERC4626(yieldToken_);
    }

    function deposit(uint amount) external override onlyOwner {
        IERC20 _token = IERC20(token());
        _token.transferFrom(msg.sender, address(this), amount);
        _token.approve(address(_yieldToken), amount);
        _yieldToken.deposit(amount, address(this));

        _deposited += amount;
        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint amount) external override onlyOwner {
        _yieldToken.withdraw(amount, msg.sender, address(this));

        _deposited -= amount;
        emit Withdrew(msg.sender, amount);
    }

    function withdrawYield(uint amount) external override onlyOwner {
        uint yieldAmount = getYieldAmount();
        require(amount <= yieldAmount, "ERC4626YieldVault: insufficient yield");

        _yieldToken.withdraw(amount, msg.sender, address(this));
        emit YieldWithdrawn(msg.sender, amount);
    }

    // Read function
    function getDepositedAmount() public view returns(uint amount) {
        return _deposited;
    }

    function getYieldAmount() public view returns(uint amount) {
        return getTotalAmount() - getDepositedAmount();
    }

    function getTotalAmount() public view returns(uint amount) {
        return _yieldToken.convertToAssets(_yieldToken.balanceOf(address(this)));
    }

    function token() public view override returns(address) {
        return address(_yieldToken.asset());
    }
}
