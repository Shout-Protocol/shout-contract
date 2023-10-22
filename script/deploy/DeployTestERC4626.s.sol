// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../test/contracts/TestERC4626.sol";

contract DeployTestERC4626 is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address asset = 0x927B303A496b273f3E90Ce01c54C9f9b7F5A76C2;
        new TestERC4626(asset);

        vm.stopBroadcast();
    }
}
