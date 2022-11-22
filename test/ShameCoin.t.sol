// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/ShameCoin.sol";

contract ShameCoinTest is Test {
    ShameCoin smc;
    address admin;
    address alice;
    address bob;

    function setUp() public {
        admin = makeAddr("Admin");
        alice = makeAddr("Alice");
        bob = makeAddr("Bob");

        vm.startPrank(admin);
        smc = new ShameCoin(admin);
        vm.stopPrank();

        console2.log("admin:", admin);
        console2.log("contract:", address(smc));
    }

    function testFaucet() public {
        vm.startPrank(alice);
        smc.faucet();
        assertEq(smc.balanceOf(alice), 10);
        vm.stopPrank();

        vm.startPrank(bob);
        smc.faucet();
        assertEq(smc.balanceOf(bob), 10);
        vm.stopPrank();
    }

    function testTransfer() public {
        vm.startPrank(admin);
        smc.faucet();
        assertEq(smc.balanceOf(admin), 10);

        smc.transfer(alice, 1);
        assertEq(smc.balanceOf(admin), 9);
        assertEq(smc.balanceOf(alice), 1);
        vm.stopPrank();

        vm.startPrank(alice);
        smc.transfer(bob, 1);
        assertEq(smc.balanceOf(alice), 2);
        vm.stopPrank();
    }

    function testApprove() public {
        vm.startPrank(alice);
        smc.faucet();
        vm.expectRevert();
        smc.approve(bob, 1);

        vm.expectRevert();
        smc.transferFrom(alice, bob, 1);

        smc.approve(admin, 1);
        assertEq(smc.allowance(alice, admin), 1);
        vm.stopPrank();

        vm.startPrank(admin);
        smc.transferFrom(alice, bob, 1);
        assertEq(smc.balanceOf(alice), 9);
        assertEq(smc.balanceOf(bob), 1);
        vm.stopPrank();
    }
}
