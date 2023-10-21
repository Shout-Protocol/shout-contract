// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/yieldVaults/ERC4626YieldVault.sol";
import "./contracts/TestERC20.sol";
import "./contracts/TestERC4626.sol";
import "./contracts/TestYieldVault.sol";

contract ERC4626YieldVaultTest is Test {
    ERC4626YieldVault public yieldVault;

    TestERC20 public testERC20;
    TestERC4626 public testERC4626;

    function setUp() public {
        testERC20 = new TestERC20();
        testERC4626 = new TestERC4626(address(testERC20));
        yieldVault = new ERC4626YieldVault(address(testERC4626));
    }

    function testDeposit() public {
        uint amount = 100;
        testERC20.mint(address(this), amount);
        testERC20.approve(address(yieldVault), amount);

        yieldVault.deposit(amount);

        assertEq(yieldVault.getDepositedAmount(), 100);
        assertEq(yieldVault.getYieldAmount(), 0);
    }

    function testDepositAndAccrueYield() public {
        uint amount = 100;
        uint yieldAmount = 50;
        testERC20.mint(address(this), amount);
        testERC20.approve(address(yieldVault), amount);

        yieldVault.deposit(amount);
        testERC20.mint(address(testERC4626), yieldAmount);

        assertEq(yieldVault.getDepositedAmount(), amount);
        assertEq(yieldVault.getYieldAmount(), yieldAmount - 1);
    }

    function testWithdrawYield() public {
        uint amount = 100;
        uint yieldAmount = 50;
        testERC20.mint(address(this), amount);
        testERC20.approve(address(yieldVault), amount);

        yieldVault.deposit(amount);
        testERC20.mint(address(testERC4626), yieldAmount);

        yieldVault.withdrawYield(30);

        assertEq(yieldVault.getYieldAmount(), yieldAmount - 30 - 1);
    }

    function testFailWithdrawYield() public {
        uint amount = 100;
        uint yieldAmount = 50;
        testERC20.mint(address(this), amount);
        testERC20.approve(address(yieldVault), amount);

        yieldVault.deposit(amount);
        testERC20.mint(address(testERC4626), yieldAmount);

        yieldVault.withdrawYield(51);
    }
}
