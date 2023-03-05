//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract DonationWallet {

    // @title DonationWallet
    // @author codetilda
    // @notice Task#1 from Growic Solidity Developer Bootcamp - Primitive Data Types
    // Used data types: address, bool, int, uint, string, enum, bytes
    // Donation Wallet is a smart contract that allows bloggers, 
    // charity organizations, freelancers, and other individuals or groups to receive payments
    // in the form of ETH cryptocurrency.

    address payable public owner;   // owner of the DonationWallet contract. Initial set up in constructor
    bool public isActive;           // DonationWallet in nomal working mode. Initial set up in constructor
    int public transactionCounter;  // incrementet when incoming transaction, decrement when outcoming transaction
    string public walletName;       // owner can set up wallet Name
    
    enum WalletType {               // Owner can set up privacy of the wallet
        Private,                    // If wallet Private - only owner v=can withdraw,
        Public                      // If wallet Public - anyone can withdraw
    }
    WalletType public walletType;   // initial value Private - 0
   
    // 0x0000000000000000000000000000000000000000000000000000000000000001
    uint8 public u8_example = 1;

    // 0x02
    bytes1 public byte_example = 0x02;

    modifier onlyOwner {
        require(owner == msg.sender, "Not owner");
        _;
    }

    constructor () {
        owner = payable(msg.sender);
        isActive = true;
    }

    // @notice Public function to donate ETH to the contract
    // @dev Contract can recieve ETH only in case when wallet active (isActive == true)
    function donate() external payable {
        require(isActive, "Wallet is not Active");
        require(msg.value > 0, "Zero donation"); // we don't count 0 donations

        incTransactionCounter(); // count donation 
    }

    // @notice Withdra all amount to the owner of contract
    // @dev Only owner can withdraw if walletType is Private and anyone can withdraw if walletType = Public
    function withdraw(uint256 _amount) external {
        uint256 curBalance = getWalletBallance();
        require(curBalance > 0, "Zero wallet balance"); 
        require(curBalance >= _amount, "Not enouth balance");

        if(walletType == WalletType.Public){
            (bool success, ) = payable(msg.sender).call{value: curBalance}("");
            require(success, "Failed to send Ether");

            decTransactionCounter();
        }

        if(walletType == WalletType.Private){
            (bool success, ) = owner.call{value: curBalance}("");
            require(success, "Failed to send Ether");

            decTransactionCounter();
        }
    }

    function getWalletBallance() public view returns (uint256){
        return address(this).balance;
    }

    function pauseWallet() external onlyOwner{
        isActive = false;
    }

    function activateWallet() external onlyOwner{
        isActive = true;
    }

    function setPrivateWalletType() external onlyOwner{
        walletType = WalletType.Private;
    }

    function setPublicWalletType() external onlyOwner{
        walletType = WalletType.Public;
    }

    function nameWallet(string memory _walletName) external onlyOwner{
        require(bytes(_walletName).length < 30, "No more 30 symbols");
        walletName = _walletName;
    }

    function incTransactionCounter() internal {
        transactionCounter++;
    }

    function decTransactionCounter() internal {
        transactionCounter--;
    }

}
