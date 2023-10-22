// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../test/contracts/TestERC4626.sol";

contract DeployTestERC4626 is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address asset = 0x169fC7C4F6dC655c264354096989Cb8f8FA67BD3;
        new TestERC4626(asset);

        vm.stopBroadcast();
    }
}
