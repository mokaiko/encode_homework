// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract InteractWithUniswapTest is Test {
    uint256 private mainnetFork;
    string private MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    // account
    address private constant binanceAccount =
        0xDFd5293D8e347dFe59E90eFd55b2956a1343963d;

    // ERC20 token contract
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address private constant BUSD = 0x4Fabb145d64652a948d72533023f6E7A623C7C53;

    // uniswap contract
    address private constant uniswapV3RouterAddress =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;

    IERC20 dai = IERC20(DAI);
    IERC20 usdc = IERC20(USDC);
    IERC20 busd = IERC20(BUSD);
    ISwapRouter swapRouter = ISwapRouter(uniswapV3RouterAddress);

    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
    }

    function testBalance() public {
        vm.selectFork(mainnetFork);
        console2.log("Binance ETH balance:", binanceAccount.balance);
        console2.log("Binance DAI balance:", dai.balanceOf(binanceAccount));
        console2.log("Binance USDC balance:", usdc.balanceOf(binanceAccount));
        console2.log("Binance BUSD balance:", busd.balanceOf(binanceAccount));
    }
}
