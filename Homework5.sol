// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoCoin is Ownable {

    uint private totalSupply = 10_000;

    // address public owner;

    mapping(address => uint) public balances;

    struct Payment {
        uint amount;
        address recipient;
    }

    mapping(address => Payment[]) private records;

    // modifier onlyOwner() {
    //     if (msg.sender == owner) {
    //         _;
    //     }
    // }

    event increaseTotalSupplyEvent(uint indexed);
    event transferEvent(uint indexed, address indexed);

    constructor() {
        // owner = msg.sender;
        balances[msg.sender] = totalSupply;
    }

    function getTotalSupply() public view returns(uint) {
        return totalSupply;
    }

    function increase1000() public onlyOwner {
        totalSupply = totalSupply + 1000;
        emit increaseTotalSupplyEvent(totalSupply);
    }

    function transfer(uint _amount, address _recipient) public {
        require(balances[msg.sender] >= _amount, "Hey! The value you send should be less than your current balance!");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit transferEvent(_amount, _recipient);
        records[msg.sender].push(Payment({amount: _amount, recipient: _recipient}));
    }

    function getPaymentRecords(address _sender) public view returns(Payment[] memory){
        return records[_sender];
    }

}
