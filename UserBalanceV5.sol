//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
 
error AmountToSmall();

/// @title Payable
/// @author codetilda
/// @notice Task#7 from Growic Solidity Developer Bootcamp - Payable 
/// In this task, we will re-write the deposit function from the ‘Mappings’ topic. 
/// We will allow users to send real ETH deposits to our smart contract by adding a payable function.
/// Function deposit will be re-written to accept no arguments but receive real ETH deposits 
/// and still save and update user balance.deposit() accepts ETH through the payable modifier 
/// and updates user balance accordingly
contract UserBalanceV5 {

    event FundsDeposited(address user, uint256 amount);
    event FundsAdded(address user, uint256 amount);
    event ProfileUpdated(address user);

    uint256 constant private Fee = 10; // Contract Fee. User cannot add funds less than Fee;
    address payable public owner; // owner of the contract. Sets up in the constructor 
    mapping(address => uint256) public userBalance; // mapping of users balance
    
    struct UserDetails{
        string name;
        uint256 age;
    }
    mapping(address => UserDetails) public userDetails; // mapping of User Details

    constructor () {
        owner = payable(msg.sender);
    }
 
    // Modifier to check that the caller is the owner of the contract.
    modifier onlyOwner() {
        require( owner == msg.sender, "Caller is Not owner");
        _;
    }

    // Modifier to check that caller have deposited before 
    // with deposit function, so userBalance > 0
    modifier onlyUser() {
        require(userBalance[msg.sender]>0, "Caller is not User");
        _;
    }

    // Modifier to check that deposited amount more than Fee
    modifier value(uint256 amount) {
        if(amount <= Fee)
            revert AmountToSmall();
        _;
    }

    /// @notice Function to withdraw funds from contract 
    /// @dev Only owner of contract can withdraw all funds
    function withdraw() public onlyOwner {
        uint256 currentBalance = address(this).balance; // get current contract Balance

        if (currentBalance > 0 ) {
            (bool success, ) = owner.call{value: currentBalance}("");
            require(success, "Failed to send Ether");
        }    
    }

    /// @notice Function to deposit funds to contract 
    /// @dev Anyone can deposit funds with more than Fee amount
    function deposit() external payable value(msg.value){
        uint256 _amount = msg.value;

        userBalance[msg.sender] += _amount;
        emit FundsDeposited(msg.sender, _amount);
    }

    /// @notice Function to add funds to contract 
    /// @dev Only user that gave deposited before can call this function
    function addFund() external payable onlyUser value(msg.value){
        uint256 _amount = msg.value;

        userBalance[msg.sender] += _amount;
        emit FundsAdded(msg.sender, _amount);
    } 

    /// @notice Helper function to check user balance
    function checkBalance() external view returns (uint256) {
        return userBalance[msg.sender];
    }

    /// @notice Function to set up user details
    /// @param _name the user name, _age the user age 
    function setUserDetails(string calldata _name, uint256 _age) external {
        UserDetails memory _userDatails;
       
        _userDatails.name = _name;
        _userDatails.age = _age;

        userDetails[msg.sender] = _userDatails;

        emit ProfileUpdated(msg.sender);
    }

    /// @notice Helper function to get user details
    function getUserDetail() external view returns (UserDetails memory){
        return userDetails[msg.sender];
    }
}
