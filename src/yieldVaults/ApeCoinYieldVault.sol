// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IYieldVault.sol";
import "../interfaces/IApeCoinStaking.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC4626.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ApeCoinYieldVault is IYieldVault, Ownable {

    IERC20 private _apeCoin;
    IApeCoinStaking private _apeCoinStaking;
    uint256 private _deposited;

    constructor(address apeCoin_, address apeCoinStaking_) Ownable(msg.sender) {
        _apeCoin = IERC20(apeCoin_);
        _apeCoinStaking = IApeCoinStaking(apeCoinStaking_);
    }

    function deposit(uint amount) external override onlyOwner {
        IERC20 _token = IERC20(token());
        _token.transferFrom(msg.sender, address(this), amount);
        _token.approve(address(_apeCoinStaking), amount);
        _apeCoinStaking.depositApeCoin(amount, address(this));

        _deposited += amount;
        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint amount) external override onlyOwner {
        _apeCoinStaking.claimApeCoin(address(this));

        _deposited -= amount;
        emit Withdrew(msg.sender, amount);
    }

    function withdrawYield(uint amount) external override onlyOwner {
        uint yieldAmount = getYieldAmount();
        require(amount <= yieldAmount, "ERC4626YieldVault: insufficient yield");

        _apeCoinStaking.claimApeCoin(address(this));
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
        return _apeCoin.balanceOf(address(this));
    }

    function token() public view override returns(address) {
        return address(_apeCoin);
    }
}
