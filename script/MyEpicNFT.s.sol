// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "../src/MyEpicNFT.sol";

contract MyEpicNFTScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MyEpicNFT myNFT = MyEpicNFT(
            address(0x62B3827733Fe4613E9Ca4cDD589CCAb19A741a38)
        );
        console2.log("nft contract:", address(myNFT));

        myNFT.makeAnEpicNFT();

        vm.stopBroadcast();
    }
}
