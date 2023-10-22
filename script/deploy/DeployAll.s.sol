// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../test/contracts/TestERC20.sol";
import "../../test/contracts/TestERC4626.sol";
import "../../src/Shouter.sol";
import "../../src/yieldVaults/ERC4626YieldVault.sol";

contract DeployAll is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TestERC20 erc20 = new TestERC20();
        TestERC4626 erc4626 = new TestERC4626(address(erc20));

        Shouter shouter = new Shouter();

        ERC4626YieldVault yieldVault = new ERC4626YieldVault(address(erc4626));

        shouter.addYieldVault(address(yieldVault));
        vm.stopBroadcast();
    }
}
