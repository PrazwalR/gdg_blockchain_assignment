// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/PersonalLocker.sol";

contract PersonalLockerTest is Test {
    PersonalLocker public locker;
    address public owner;
    string constant INITIAL_MESSAGE = "Prazwal Ratti";
    string constant PASSWORD = "I don't know Hardhat but I know Foundry";

    function setUp() public {
        owner = address(this);
        locker = new PersonalLocker(INITIAL_MESSAGE, PASSWORD);
    }

    function testConstructor() public {
        assertEq(locker.owner(), owner);
        assertEq(locker.getMessage(), INITIAL_MESSAGE);
    }

    function testUpdateMessage() public {
        string memory newMessage = "Assignment Completed";
        
        vm.expectEmit(true, true, true, true);
        emit PersonalLocker.MessageUpdated(INITIAL_MESSAGE, newMessage);
        
        locker.updateMessage(newMessage, PASSWORD);
        assertEq(locker.getMessage(), newMessage);
    }

    function testUpdateMessageFailsWithWrongPassword() public {
        vm.expectRevert("Incorrect password");
        locker.updateMessage("New Message", "WrongPassword");
    }

    function testUpdateMessageFailsWithNonOwner() public {
        vm.prank(address(0x123));
        vm.expectRevert("Only owner can call this function");
        locker.updateMessage("New Message", PASSWORD);
    }

    function testGetPassword() public {
        assertEq(locker.getPassword(), PASSWORD);
    }

    function testGetPasswordFailsWithNonOwner() public {
        vm.prank(address(0x123));
        vm.expectRevert("Only owner can call this function");
        locker.getPassword();
    }

    function testReceiveFunctionReverts() public {
        vm.expectRevert("Contract does not accept Ether");
        payable(address(locker)).transfer(1 ether);
    }

    function testFallbackFunctionReverts() public {
        vm.expectRevert("Function does not exist");
        (bool success,) = address(locker).call(abi.encodeWithSignature("nonExistentFunction()"));
        assertFalse(success);
    }
}