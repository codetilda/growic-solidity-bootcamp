//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
 
error AmountToSmall();

/// @title Events
/// @author codetilda
/// @notice Task#5 from Growic Solidity Developer Bootcamp - Events 
/// Extend the previous task to use blockchain events. 
/// The contact should emit the following events 
/// when a user deposits and updates their profile information respectively:
/// FundsDeposited(address user, uint256 amount)
/// ProfileUpdated(address user)
contract UserBalanceV4 {

    event FundsDeposited(address user, uint256 amount);
    event FundsAdded(address user, uint256 amount);
    event ProfileUpdated(address user);

    uint256 private Fee = 10; // Contract Fee. User cannot add funds less than Fee;
    address payable public owner; // owner of the contract. Sets up in the constructor 
    mapping(address => uint256) public userBalance; // mapping of users balance
    
    struct UserDetails{
        string name;
        uint256 age;
    }
    mapping(address => UserDetails) public userDetails;

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
        
        emit FundsDeposited(msg.sender, _amount);
    }

    /// @notice Function to add funds to contract 
    /// @dev Onluy user that gave deposited before can call this function
    function addFund(uint256 _amount) external payable onlyUser value(_amount){
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
