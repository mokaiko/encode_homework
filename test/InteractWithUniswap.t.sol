// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "forge-std/Test.sol";

contract InteractWithUniswapTest is Test {
    uint256 private mainnetFork;
    string private MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    address payable private binanceAccount =
        payable(0xDFd5293D8e347dFe59E90eFd55b2956a1343963d);

    address private daiStablecoinAddress =
        0x6B175474E89094C44Da98b954EedeAC495271d0F;

    address private uniswapV3RouterAddress =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;

    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
    }

    function testBalance() public {
        vm.selectFork(mainnetFork);
        console2.log("Binance account ETH:", binanceAccount.balance);
    }
}
