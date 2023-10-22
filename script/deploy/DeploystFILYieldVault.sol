// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/yieldVaults/ERC4626YieldVault.sol";

contract DeploySDAIYieldVault is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address stFil = 0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844;
        new ERC4626YieldVault(stFil);

        vm.stopBroadcast();
    }
}
