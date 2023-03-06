//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// @title Mapping
// @author codetilda
// @notice Task#2 from Growic Solidity Developer Bootcamp - Mappings
// Create a smart contract that saves user balance. 
// The contract should have the functions:
// deposit (uint256 amount) this function accepts one argument 
// and it saves the amount a user is depositing into a mapping,
// checkBalance() this function searches for the user balance 
// inside the balance mapping and returns the balance of whoever is calling the contract 
// (i.e msg.sender). This function does not accept any arguments.

contract UserBalance {
    mapping(address => uint256) public userBalance;

    function deposit(uint256 _amount) external {
        userBalance[msg.sender] += _amount;
    }

    function checkBalance() external view returns (uint256) {
        return userBalance[msg.sender];
    }
}
