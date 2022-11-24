// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InteractWithUniswapTest is Test {
    uint256 private mainnetFork;
    string private MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    address private constant binanceAccount =
        0xDFd5293D8e347dFe59E90eFd55b2956a1343963d;

    address private constant daiStablecoinAddress =
        0x6B175474E89094C44Da98b954EedeAC495271d0F;

    address private constant uniswapV3RouterAddress =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;

    IERC20 DAI = IERC20(daiStablecoinAddress);

    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
    }

    function testBalance() public {
        vm.selectFork(mainnetFork);
        console2.log("Binance account ETH:", binanceAccount.balance);
        console2.log("Binance account DAI:", DAI.balanceOf(binanceAccount));
    }
}
