// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Shouter.sol";
import "../src/yieldVaults/ERC4626YieldVault.sol";

contract AddYieldVault is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Shouter shouter = Shouter(0x60edA798a0503d81CCB2ACA7b2A098e1892e759d);

        ERC4626YieldVault yieldVault = ERC4626YieldVault(0x919a82b146fdE7415285bFf66826Aee8b608a963);

        shouter.addYieldVault(address(yieldVault));
        yieldVault.transferOwnership(address(shouter));

        vm.stopBroadcast();
    }
}
