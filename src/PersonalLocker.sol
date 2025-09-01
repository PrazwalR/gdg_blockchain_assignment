// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract PersonalLocker {
    address public owner;
    string private message;
    string private password;
    string public block_contr;

    event MessageUpdated(string oldMessage, string newMessage);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(string memory _initialMessage, string memory _password) {
        owner = msg.sender;
        message = _initialMessage;
        password = _password;
    }

    function updateMessage(string memory _newMessage, string memory _providedPassword) external onlyOwner {
        require(keccak256(abi.encodePacked(_providedPassword)) == keccak256(abi.encodePacked(password)), "Incorrect password");
        string memory oldMessage = message;
        message = _newMessage;
        emit MessageUpdated(oldMessage, _newMessage);
    }

    function getMessage() external view returns (string memory) {
        return message;
    }

    function getPassword() external view onlyOwner returns (string memory) {
        return password;
    }

    receive() external payable {
        revert("Contract does not accept Ether");
    }

    fallback() external payable {
        revert("Function does not exist");
    }
}