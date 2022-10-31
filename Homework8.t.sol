// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VolcanoCoin.sol";

contract VolcanoCoinTest is Test {
    VolcanoCoin public volcanoCoin;

    function setUp() public {
        volcanoCoin = new VolcanoCoin();
    }

    function testInitialTotalSupply() public {
        assertEq(volcanoCoin.getTotalSupply(), 10000);
    }

    function testIncrease1000() public {
        volcanoCoin.increase1000();
        assertEq(volcanoCoin.getTotalSupply(), 11000);
        volcanoCoin.increase1000();
        assertEq(volcanoCoin.getTotalSupply(), 12000);
        volcanoCoin.increase1000();
        assertEq(volcanoCoin.getTotalSupply(), 13000);
    }

    function testOnlyOwnerCanIncrease() public {
        vm.expectRevert();
        vm.prank(address(0x1));
        volcanoCoin.increase1000();
    }
}
