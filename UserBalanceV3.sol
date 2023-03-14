//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

    /// @title Mapping
    /// @author codetilda
    /// @notice Task#4 from Growic Solidity Developer Bootcamp - Modifiers 
    /// This task extends the functionality of the previous task. 
    /// Create a deposit function that allows anybody to send funds. 
    /// Store the user and the amount in a mapping as the previous task.
    ///
    /// Add a withdraw function and create a modifier that only allows 
    /// the owner of the contract to withdraw the funds.
    ///
    /// Add an addFund function and create a modifier that only allows users 
    /// that have deposited using the deposit function, to increase their balance on the mapping. 
    /// The function should accept the amount to be added and update the mapping 
    /// to have the new balance
    /// Hint: if their balance is zero on the mapping, it should revert
    /// Hint: theMapping[userId] = theMapping[userId] + _amount;
    ///
    /// Create a modifier that accepts a value(uint256 _amount):
    /// Create a private constant variable called Fee
    /// In the modifier check if the value(_amount) it accepts is less than the Fee, 
    /// revert with a custom error AmountToSmall()
    /// Add it to the addFund function
    /// Hint: addFund(uint256 _amount)....

contract UserBalanceV3 {

    uint256 private Fee = 10; // Contract Fee. User cannot add funds less than Fee;
    address payable public owner; // owner of the contract. Sets up in the constructor 
    mapping(address => uint256) public userBalance; // mapping of users balance
    
    struct UserDetails{
        string name;
        uint256 age;
    }
    mapping(address => UserDetails) public userDetails;

    error AmountToSmall(); // Error called if amount to add funds less than Fee;

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

    // Modifier to check that amount equal msg.value and more than Fee
    modifier value(uint256 amount) {
        require(msg.value == amount, "msg.value should be equal amount");
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
    function deposit(uint256 _amount) external payable value(_amount){
        userBalance[msg.sender] += _amount;
    }

    /// @notice Function to add funds to contract 
    /// @dev Onluy user that gave deposited before can call this function
    function addFund(uint256 _amount) external payable onlyUser value(_amount){
        userBalance[msg.sender] += _amount;
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
    }

    /// @notice Helper function to get user details
    function getUserDetail() external view returns (UserDetails memory){
        return userDetails[msg.sender];
    }
}
