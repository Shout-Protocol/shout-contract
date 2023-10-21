// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Shouter.sol";
import "./contracts/TestERC20.sol";
import "./contracts/TestERC4626.sol";
import "./contracts/TestYieldVault.sol";

contract ShouterTest is Test {
    Shouter public shoutVault;

    TestERC20 public testERC20;
    TestYieldVault public testYieldVault;

    event PostCreated(
        uint indexed postId,
        address indexed owner,
        string ipfsHash
    );
    event BoostAdjusted(
        uint indexed postId,
        uint indexed yieldVaultId,
        uint oldAmount,
        uint newAmount
    );
    event YieldVaultAdded(
        uint indexed yieldVaultId,
        address indexed yieldVault
    );
    event YieldVaultPaused(uint indexed yieldVaultId, bool paused);
    event YieldClaimed(
        uint indexed yieldVaultId,
        address indexed yieldVault,
        uint amount
    );

    function setUp() public {
        shoutVault = new Shouter();

        testERC20 = new TestERC20();
        testYieldVault = new TestYieldVault(address(testERC20));

        shoutVault.addYieldVault(address(testYieldVault));
    }

    function testCreatePost() public {
        vm.expectEmit(true, true, true, false);
        string memory _ipfsHash = "ipfsHash";
        uint _postId = 1;

        emit PostCreated(_postId, address(this), _ipfsHash);
        shoutVault.createPost(_ipfsHash);

        assertEq(shoutVault.postCount(), _postId);
        assertEq(shoutVault.postOwner(_postId), address(this));
    }

    function testDepositBoost() public {
        testERC20.mint(address(this), 100);
        testERC20.approve(address(shoutVault), 100);

        uint256 postId = shoutVault.createPost("ipfsHash");
        uint256 yieldVaultId = 1;
        uint256 amount = 100;

        vm.expectEmit(true, true, true, true);
        emit BoostAdjusted(postId, yieldVaultId, 0, amount);
        shoutVault.depositBoost(postId, yieldVaultId, amount);

        assertEq(shoutVault.boostScore(postId, yieldVaultId), amount);
    }

    function testWithdrawBoost() public {
        uint256 postId = shoutVault.createPost("ipfsHash");
        uint256 yieldVaultId = 1;
        uint256 amount = 50;

        testERC20.mint(address(this), 100);
        testERC20.approve(address(shoutVault), 100);
        shoutVault.depositBoost(postId, yieldVaultId, 100);
        uint preAmount = shoutVault.boostScore(postId, yieldVaultId);

        vm.expectEmit(true, true, true, true);
        emit BoostAdjusted(postId, yieldVaultId, preAmount, preAmount - amount);
        shoutVault.withdrawBoost(postId, yieldVaultId, amount);
    }

    function testYieldCollecting() public {
        uint256 postId = shoutVault.createPost("ipfsHash");
        uint256 yieldVaultId = 1;

        testERC20.mint(address(this), 100);
        testERC20.approve(address(shoutVault), 100);
        shoutVault.depositBoost(postId, yieldVaultId, 100);

        testYieldVault.increseYieldAmount(10);

        uint256[] memory vaultIds = new uint256[](1);
        uint256[] memory amounts = new uint256[](1);

        vaultIds[0] = yieldVaultId;
        amounts[0] = 10;
        shoutVault.claimYields(vaultIds, amounts);

        assertEq(shoutVault.getClaimableYield(yieldVaultId), 0);
        assertEq(testERC20.balanceOf(address(this)), 10);
    }

    function testFail_YieldCollecting() public {
        uint256 postId = shoutVault.createPost("ipfsHash");
        uint256 yieldVaultId = 1;

        testERC20.mint(address(this), 100);
        testERC20.approve(address(shoutVault), 100);
        shoutVault.depositBoost(postId, yieldVaultId, 100);

        testYieldVault.increseYieldAmount(10);

        uint256[] memory vaultIds = new uint256[](1);
        uint256[] memory amounts = new uint256[](1);

        vaultIds[0] = yieldVaultId;
        amounts[0] = 10;
        shoutVault.claimYields(vaultIds, amounts);
        shoutVault.claimYields(vaultIds, amounts);
    }

}
