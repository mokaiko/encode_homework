// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "openzeppelin-contracts/access/Ownable.sol";
import "openzeppelin-contracts/security/Pausable.sol";
import "./strings.sol";

contract VolcanoCoin is Ownable, Pausable {
    using strings for *;

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

    function increase1000() public onlyOwner whenNotPaused {
        totalSupply = totalSupply + 1000;
        emit increaseTotalSupplyEvent(totalSupply);
    }

    function transfer(uint256 _amount, address _recipient)
        public
        whenNotPaused
    {
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

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function interactWithStringUtilsLibrary(string memory _str)
        public
        pure
        returns (string memory, uint256)
    {
        string memory resStr = strings.concat(
            _str.toSlice(),
            "from ETH Denver".toSlice()
        );
        return (resStr, strings.len(resStr.toSlice()));
    }
}
