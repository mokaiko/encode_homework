// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "../src/InteractWithUniswap.sol";

contract InteractWithUniswapByContractTest is Test {
    InteractWithUniswap interactWithUniswap;

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
    // address private constant uniswapV3RouterAddress =
    //     0xE592427A0AEce92De3Edee1F18E0157C05861564;

    IERC20 dai = IERC20(DAI);
    IERC20 usdc = IERC20(USDC);
    IERC20 busd = IERC20(BUSD);
    // ISwapRouter swapRouter = ISwapRouter(uniswapV3RouterAddress);

    uint24 private constant poolFee_005percent = 500;
    uint24 private constant poolFee_030percent = 3000;
    uint256 private amountIn_DAI = 100e18;
    uint256 private amountOutMinimum_USDC = 90e6;
    uint256 private amountOutMinimum_BUSD = 90e18;

    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        vm.selectFork(mainnetFork);
        interactWithUniswap = new InteractWithUniswap();
    }

    function testSwapDaiForUsdc() public {
        vm.startPrank(binanceAccount);
        uint256 daiBalance = dai.balanceOf(binanceAccount);
        uint256 usdcBalance = usdc.balanceOf(binanceAccount);
        // uint256 busdBalance = busd.balanceOf(binanceAccount);

        dai.approve(address(interactWithUniswap), amountIn_DAI);

        uint256 allowance = dai.allowance(
            binanceAccount,
            address(interactWithUniswap)
        );
        assertEq(allowance, amountIn_DAI);

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

        uint256 amountOut = interactWithUniswap.swapFromDAI(params);

        assertEq(daiBalance - 100 ether, dai.balanceOf(binanceAccount));
        assertEq(usdcBalance + amountOut, usdc.balanceOf(binanceAccount));
    }

    function testSwapDaiForBusd() public {
        vm.startPrank(binanceAccount);
        uint256 daiBalance = dai.balanceOf(binanceAccount);
        // uint256 usdcBalance = usdc.balanceOf(binanceAccount);
        uint256 busdBalance = busd.balanceOf(binanceAccount);

        dai.approve(address(interactWithUniswap), amountIn_DAI);

        uint256 allowance = dai.allowance(
            binanceAccount,
            address(interactWithUniswap)
        );
        assertEq(allowance, amountIn_DAI);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: BUSD,
                fee: poolFee_005percent,
                recipient: binanceAccount,
                deadline: block.timestamp + 10,
                amountIn: amountIn_DAI,
                amountOutMinimum: amountOutMinimum_BUSD,
                sqrtPriceLimitX96: 0
            });

        uint256 amountOut = interactWithUniswap.swapFromDAI(params);

        assertEq(daiBalance - 100 ether, dai.balanceOf(binanceAccount));
        assertEq(busdBalance + amountOut, busd.balanceOf(binanceAccount));
    }
}
