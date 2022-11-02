// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "openzeppelin-contracts/access/Ownable.sol";

contract VolcanoCoin is Ownable {
    uint256 private totalSupply = 10_000;

    mapping(address => uint256) public balances;

    struct Payment {
        uint256 amount;
        address recipient;
    }

    mapping(address => Payment[]) private records;

    event increaseTotalSupplyEvent(uint256 indexed);
    event transferEvent(uint256 indexed, address indexed);

    constructor() {
        balances[msg.sender] = totalSupply;
    }

    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function increase1000() public onlyOwner {
        totalSupply = totalSupply + 1000;
        emit increaseTotalSupplyEvent(totalSupply);
    }

    function transfer(uint256 _amount, address _recipient) public {
        require(
            balances[msg.sender] >= _amount,
            "Hey! The value you send should be less than your current balance!"
        );
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit transferEvent(_amount, _recipient);
        recordPayment(msg.sender, _recipient, _amount);
    }

    function recordPayment(
        address _sender,
        address _recipient,
        uint256 _amount
    ) private {
        records[_sender].push(
            Payment({amount: _amount, recipient: _recipient})
        );
    }

    function getPaymentRecords(address _sender)
        public
        view
        returns (Payment[] memory)
    {
        return records[_sender];
    }

    function getMyRecords() public view returns (Payment[] memory) {
        return records[msg.sender];
    }
}
