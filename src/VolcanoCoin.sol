// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract VolcanoCoin is ERC20 {
    constructor() ERC20("Volcano Coin", "VC") {}

    function faucet() external {
        _mint(msg.sender, 100e18);
    }
}
