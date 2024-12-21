// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MentorshipTokens {
    
    // Define variables
    string public name = "MentorshipToken";
    string public symbol = "MTT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    // Constructor to initialize contract
    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }
    
    // Transfer function to send tokens
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Cannot transfer to the zero address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    
    // Approve function for delegation of tokens
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    // TransferFrom function for delegated token transfer
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(sender != address(0), "Cannot transfer from the zero address");
        require(recipient != address(0), "Cannot transfer to the zero address");
        require(balanceOf[sender] >= amount, "Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Allowance exceeded");

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        allowance[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }
    
    // Function for mentors to reward learners with tokens
    function rewardMentor(address learner, uint256 amount) public returns (bool) {
        require(msg.sender == owner, "Only the contract owner can reward mentors");
        require(balanceOf[owner] >= amount, "Insufficient contract balance");

        balanceOf[owner] -= amount;
        balanceOf[learner] += amount;

        emit Transfer(owner, learner, amount);
        return true;
    }

    // Function to check the contract owner
    function getOwner() public view returns (address) {
        return owner;
    }
}
