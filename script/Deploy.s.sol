// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/PersonalLocker.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string memory initialMessage = "Prazwal Ratti";
        string memory secretPassword = "I don't know Hardhat but I know Foundry";

        PersonalLocker locker = new PersonalLocker(initialMessage, secretPassword);

        console.log("PersonalLocker deployed at:", address(locker));
        console.log("Owner:", locker.owner());
        console.log("Initial Message:", locker.getMessage());

        vm.stopBroadcast();
    }
}