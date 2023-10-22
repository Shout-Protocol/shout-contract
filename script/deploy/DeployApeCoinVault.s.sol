// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/yieldVaults/ApeCoinYieldVault.sol";

contract DeployApeCoinVault is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address apeCoin = 0x328507DC29C95c170B56a1b3A758eB7a9E73455c;
        address apeCoinStakingPool = 0xeF37717B1807a253c6D140Aca0141404D23c26D4;
        new ApeCoinYieldVault(apeCoin, apeCoinStakingPool);

        vm.stopBroadcast();
    }
}
