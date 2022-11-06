// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "../src/VolcanoNFT_V2.sol";

contract VolcanoNFT_V2Script is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        VolcanoNFT_V2 nft = new VolcanoNFT_V2();
        console2.log("nft contract:", address(nft));

        VolcanoCoin volcano = nft.volcano();
        console2.log("erc20 contract:", address(volcano));

        nft.mintNftWithETH{value: 0.0001 ether}();
        volcano.faucet();
        volcano.approve(address(nft), 10000 ether);
        nft.mintNftWithERC20();

        nft.transferFrom(vm.addr(deployerPrivateKey), address(0x1), 0x1);

        vm.stopBroadcast();
    }
}
