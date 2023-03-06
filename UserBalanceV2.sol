//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

    // @title Mapping
    // @author codetilda
    // @notice Task#3 from Growic Solidity Developer Bootcamp - Structs 
    // This task extends the functionality of the previous contract UserBalance 
    // by allowing users to save their additional info into the smart contract as a KYC measure.
    // The contract should now contain the following:
    // setUserDetails(string calldata name, uint256 age) this function accepts 2 arguments 
    // that represent the details of the user calling the smart contract 
    // and it saves them into a defined struct,
    // getUserDetail() this function retrieves and returns the details saved for the user calling the contract.

contract UserBalanceV2 {
    mapping(address => uint256) public userBalance;
    
    struct UserDetails{
        string name;
        uint256 age;
    }
    mapping(address => UserDetails) public userDetails;

    function deposit(uint256 _amount) external {
        userBalance[msg.sender] += _amount;
    }

    function checkBalance() external view returns (uint256) {
        return userBalance[msg.sender];
    }

    function setUserDetails(string calldata _name, uint256 _age) external {
        UserDetails memory _userDatails;
       
        _userDatails.name = _name;
        _userDatails.age = _age;

        userDetails[msg.sender] = _userDatails;
    }

    function getUserDetail() external view returns (UserDetails memory){
        return userDetails[msg.sender];
    }

}
