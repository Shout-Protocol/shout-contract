// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/yieldVaults/ERC4626YieldVault.sol";

contract DeployERC4626YieldVault is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address yieldToken = 0x2A26e41F3F332D91BDF405902550116cBc84fbA0;
        new ERC4626YieldVault(yieldToken);

        vm.stopBroadcast();
    }
}
