// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/VolcanoNFT_V2.sol";

contract VolcanoNFT_V2Test is Test {
    VolcanoNFT_V2 private nft;
    VolcanoCoin private volcano;
    address deployer;
    address alice;
    address bob;

    function setUp() public {
        deployer = makeAddr("Deployer");
        alice = makeAddr("Alice");
        bob = makeAddr("Bob");

        vm.startPrank(deployer);
        nft = new VolcanoNFT_V2();
        volcano = nft.volcano();
        vm.stopPrank();
        console2.log("deployer:", deployer);
        console2.log("nft contract:", address(nft));
        console2.log("erc20 contract:", address(volcano));
        console2.log("this address:", address(this));

        vm.deal(alice, 100 ether);
        vm.deal(bob, 100 ether);
        console2.log("alice eth balance:", alice.balance);
        console2.log("bob eth balance:", bob.balance);
    }

    function testMintNewNftWithETH() public {
        vm.startPrank(alice);

        assertEq(nft.balanceOf(alice), 0);
        uint256 tokenId = nft.mintNftWithETH{value: 0.0001 ether}();
        assertEq(nft.ownerOf(tokenId), alice);
        assertEq(nft.balanceOf(alice), 1);
        console2.log("alice after mint with eth:", alice.balance);
        assertEq(alice.balance, 99.9999 ether);

        vm.stopPrank();

        vm.startPrank(bob);

        assertEq(nft.balanceOf(bob), 0);
        uint256 tokenId2 = nft.mintNftWithETH{value: 0.0001 ether}();
        assertEq(nft.ownerOf(tokenId2), bob);
        assertEq(nft.balanceOf(bob), 1);
        console2.log("bob after mint with eth:", alice.balance);
        assertEq(alice.balance, 99.9999 ether);

        vm.stopPrank();
    }

    function testMintNewNftWithErc20() public {
        vm.startPrank(alice);
        volcano.faucet();
        assertEq(volcano.balanceOf(alice), 100 ether);
        volcano.faucet();
        assertEq(volcano.balanceOf(alice), 200 ether);

        volcano.approve(address(nft), 10000 ether);
        uint256 tokenId = nft.mintNftWithERC20();

        assertEq(volcano.allowance(alice, address(nft)), 9990 ether);
        assertEq(volcano.balanceOf(alice), 190 ether);

        assertEq(nft.ownerOf(tokenId), alice);
        assertEq(nft.balanceOf(alice), 1);

        vm.stopPrank();
    }

    function testTransferNFT() public {
        console2.log("alice balance:", alice.balance);
        vm.startPrank(alice);

        assertEq(nft.balanceOf(alice), 0);
        uint256 tokenId1 = nft.mintNftWithETH{value: 0.0001 ether}();
        uint256 tokenId2 = nft.mintNftWithETH{value: 0.0001 ether}();
        uint256 tokenId3 = nft.mintNftWithETH{value: 0.0001 ether}();
        assertEq(nft.balanceOf(alice), 3);

        nft.transferFrom(alice, address(0x1), tokenId1);
        nft.transferFrom(alice, address(0x2), tokenId2);
        nft.transferFrom(alice, address(0x3), tokenId3);
        assertEq(nft.balanceOf(alice), 0);
        assertEq(nft.balanceOf(address(0x1)), 1);
        assertEq(nft.balanceOf(address(0x2)), 1);
        assertEq(nft.balanceOf(address(0x3)), 1);

        assertEq(nft.ownerOf(tokenId1), address(0x1));
        assertEq(nft.ownerOf(tokenId2), address(0x2));
        assertEq(nft.ownerOf(tokenId3), address(0x3));

        assertEq(alice.balance, 99.9997 ether);
        vm.stopPrank();
    }
}
