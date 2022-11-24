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

    uint24 private constant poolFee_005percent = 500;
    uint24 private constant poolFee_030percent = 3000;
    uint256 private amountIn_DAI = 100e18;
    uint256 private amountOutMinimum_USDC = 90e6;
    uint256 private amountOutMinimum_BUSD = 90e18;

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

    function testSwapDaiForUsdc() public {
        vm.selectFork(mainnetFork);
        vm.startPrank(binanceAccount);
        console2.log(
            "Binance DAI balance, before swap:\t",
            dai.balanceOf(binanceAccount)
        );
        console2.log(
            "Binance USDC balance, before swap:\t",
            usdc.balanceOf(binanceAccount)
        );
        console2.log("amountIn:", amountIn_DAI);

        // Approve the router to spend DAI.
        dai.approve(address(swapRouter), amountIn_DAI);

        // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
        // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: USDC,
                fee: poolFee_030percent,
                recipient: binanceAccount,
                deadline: block.timestamp + 10,
                amountIn: amountIn_DAI,
                amountOutMinimum: amountOutMinimum_USDC,
                sqrtPriceLimitX96: 0
            });
        uint256 amountOut = swapRouter.exactInputSingle(params);

        console2.log("amountOut:", amountOut);
        console2.log(
            "Binance DAI balance, after swap:\t",
            dai.balanceOf(binanceAccount)
        );
        console2.log(
            "Binance USDC balance, after swap:\t",
            usdc.balanceOf(binanceAccount)
        );

        vm.stopPrank();
    }

    function testSwapDaiForBusd() public {
        vm.selectFork(mainnetFork);
        vm.startPrank(binanceAccount);
        console2.log(
            "Binance DAI balance, before swap:\t",
            dai.balanceOf(binanceAccount)
        );
        console2.log(
            "Binance BUSD balance, before swap:\t",
            busd.balanceOf(binanceAccount)
        );
        console2.log("amountIn:", amountIn_DAI);

        // Approve the router to spend DAI.
        dai.approve(address(swapRouter), amountIn_DAI);

        // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
        // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: BUSD,
                fee: poolFee_005percent,
                recipient: binanceAccount,
                deadline: block.timestamp,
                amountIn: amountIn_DAI,
                amountOutMinimum: amountOutMinimum_BUSD,
                sqrtPriceLimitX96: 0
            });
        uint256 amountOut = swapRouter.exactInputSingle(params);

        console2.log("amountOut:", amountOut);
        console2.log(
            "Binance DAI balance, after swap:\t",
            dai.balanceOf(binanceAccount)
        );
        console2.log(
            "Binance BUSD balance, after swap:\t",
            busd.balanceOf(binanceAccount)
        );

        vm.stopPrank();
    }
}
