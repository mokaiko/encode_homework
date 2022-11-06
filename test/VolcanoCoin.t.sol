// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/VolcanoCoin.sol";

contract VolcanoCoinTest is Test {
    VolcanoCoin private volcano;
    address deployer;
    address alice;
    address bob;

    function setUp() public {
        deployer = makeAddr("Deployer");
        alice = makeAddr("Alice");
        bob = makeAddr("Bob");

        vm.startPrank(deployer);
        volcano = new VolcanoCoin();
        vm.stopPrank();

        console2.log("deployer:", deployer);
        console2.log("contract:", address(volcano));
    }

    function testFaucet() public {
        vm.startPrank(alice);
        volcano.faucet();
        assertEq(volcano.balanceOf(alice), 100 ether);
        vm.stopPrank();

        vm.startPrank(bob);
        volcano.faucet();
        assertEq(volcano.balanceOf(bob), 100 ether);
        vm.stopPrank();
    }
}
