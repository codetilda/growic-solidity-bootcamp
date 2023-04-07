//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
 
/// @title Constructor
/// @author codetilda
/// @notice Task#Constructor from Growic Solidity Developer Bootcamp
/// contract A should have a variable called owner and it should be immutable
/// Set the owner as the person deploying the contract in the constructor
/// contract A should accept a parameter in its constructor called uint _fee and should be assigned 
/// to a variable called FEE
/// contract B should inherit contract A and pass in the required constructor parameters that A requires
contract A {
    address private immutable owner;
    uint FEE;

    constructor (uint _fee) {
        owner = msg.sender; 
        FEE = _fee;
    }

    function getFee() external view returns(uint) { 
        return FEE;
    }
}

contract B is A {
    address private owner;

    constructor () A(20) {
        owner = msg.sender;
    }
}
