// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "../src/VolcanoNFT_V3.sol";

contract VolcanoNFT_V3Script is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        VolcanoNFT_V3 nft = VolcanoNFT_V3(
            address(0x9f2C705fF34BA71a04F13e5ee1f0992E3bD012d9)
        );
        console2.log("nft contract:", address(nft));
        VolcanoCoin volcano = nft.volcano();
        console2.log("erc20 contract:", address(volcano));

        nft.mintNftWithETH{value: 0.0001 ether}();
        nft.mintNftWithETH{value: 0.0001 ether}();
        nft.mintNftWithETH{value: 0.0001 ether}();
        nft.mintNftWithETH{value: 0.0001 ether}();
        nft.mintNftWithETH{value: 0.0001 ether}();

        vm.stopBroadcast();
    }
}
