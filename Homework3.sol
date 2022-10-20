// SPDX-License-Identifier: None

pragma solidity 0.8.17;


contract BootcampContract {

    address deployer;   // 1
    uint256 number;

    constructor() {
        deployer = msg.sender;    // 2
    }

    function store(uint256 num) public {
        number = num;
    }

    function retrieve() public view returns(uint256) {
        return number;
    }

    function getAddress() external view returns(address) {
        return deployer == msg.sender ? address(0x000000000000000000000000000000000000dEaD) : deployer;
    }
}