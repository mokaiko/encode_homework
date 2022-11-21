// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "forge-std/Test.sol";

contract ForkMainnetTest is Test {
    uint256 mainnetFork;
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
    address payable addressV =
        payable(0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045); // vitalik.eth
    address payable team1 = payable(0xE6AC36dcb627663D61538cBfd74438382aD18DF1); // team1

    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
    }

    function testGetBalance() public payable {
        vm.selectFork(mainnetFork);
        console2.log("Before, V's balance:", address(addressV).balance);
        console2.log("Before, Team1's balance:", address(team1).balance);

        vm.startPrank(addressV);
        team1.transfer(1 ether);
        console2.log("After, V's balance:", address(addressV).balance);
        console2.log("After, Team1's balance:", address(team1).balance);
        vm.stopPrank();
    }
} // forge test  --match-contract ForkMainnetTest -vvvv
