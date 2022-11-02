// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/VolcanoNFT.sol";

contract VolcanoNFTTest is Test {
    VolcanoNFT public nft;

    function setUp() public {
        nft = new VolcanoNFT();
    }

    function testMintNewNFT() public {
        vm.startPrank(address(0x1));
        assertEq(nft.balanceOf(address(0x1)), 0);
        uint256 tokenId = nft.mintMyNFT();
        assertEq(nft.ownerOf(tokenId), address(0x1));
        assertEq(nft.balanceOf(address(0x1)), 1);
        vm.stopPrank();

        vm.startPrank(address(0x2));
        assertEq(nft.balanceOf(address(0x2)), 0);
        uint256 tokenId2 = nft.mintMyNFT();
        assertEq(nft.ownerOf(tokenId2), address(0x2));
        assertEq(nft.balanceOf(address(0x2)), 1);
        vm.stopPrank();
    }

    function testTransferNFT() public {
        vm.startPrank(address(0x1));

        assertEq(nft.balanceOf(address(0x1)), 0);
        uint256 tokenId1 = nft.mintMyNFT();
        uint256 tokenId2 = nft.mintMyNFT();
        uint256 tokenId3 = nft.mintMyNFT();
        assertEq(nft.balanceOf(address(0x1)), 3);

        nft.transferFrom(address(0x1), address(0x11), tokenId1);
        nft.transferFrom(address(0x1), address(0x12), tokenId2);
        nft.transferFrom(address(0x1), address(0x13), tokenId3);
        assertEq(nft.balanceOf(address(0x1)), 0);
        assertEq(nft.balanceOf(address(0x11)), 1);
        assertEq(nft.balanceOf(address(0x12)), 1);
        assertEq(nft.balanceOf(address(0x13)), 1);

        assertEq(nft.ownerOf(tokenId1), address(0x11));
        assertEq(nft.ownerOf(tokenId2), address(0x12));
        assertEq(nft.ownerOf(tokenId3), address(0x13));
    }
}
