// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Shouter.sol";
import "../src/yieldVaults/ERC4626YieldVault.sol";

contract AddYieldVault is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Shouter shouter = Shouter(0x285CaB75045B02553e6d2f1b1e2B077f5F8d083b);

        address yieldVault = 0xE9A9510bbF05a11a73Dd8DF611fD410D0645a0BB;

        shouter.addYieldVault(yieldVault);

        vm.stopBroadcast();
    }
}
