import { ethers } from "hardhat";
import { abi as SwapRouterABI } from "@uniswap/v3-periphery/artifacts/contracts/interfaces/ISwapRouter.sol/ISwapRouter.json";
import IERC20 from "../contracts/IERC20.json";

const binanceAccount = "0xDFd5293D8e347dFe59E90eFd55b2956a1343963d";
const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const BUSD = "0x4Fabb145d64652a948d72533023f6E7A623C7C53";
const uniswapV3RouterAddress = "0xE592427A0AEce92De3Edee1F18E0157C05861564";

const poolFee_005percent = 500;
const poolFee_030percent = 3000;
const amountIn_DAI = ethers.utils.parseEther("100");
const amountOutMinimum_USDC = ethers.BigNumber.from("90000000");
const amountOutMinimum_BUSD = ethers.utils.parseEther("90");

const dai = new ethers.Contract(DAI, IERC20, ethers.providers.getDefaultProvider());
const usdc = new ethers.Contract(USDC, IERC20, ethers.providers.getDefaultProvider());
const busd = new ethers.Contract(BUSD, IERC20, ethers.providers.getDefaultProvider());
const uniswapRouter = new ethers.Contract(uniswapV3RouterAddress, SwapRouterABI, ethers.providers.getDefaultProvider());

async function getBalance() {

    const daiBalance = await dai.balanceOf(binanceAccount);
    const usdcBalance = await usdc.balanceOf(binanceAccount);
    const busdBalance = await busd.balanceOf(binanceAccount);

    console.log("DAI balance:", ethers.utils.formatEther(daiBalance));
    console.log("USDC balance:", ethers.utils.formatUnits(usdcBalance, 6));
    console.log("BUSD balance:", ethers.utils.formatEther(busdBalance));
}

async function SwapDaiForUsdc() {
    const binanceSigner = await ethers.getImpersonatedSigner(binanceAccount);

    const txApprove = await dai.connect(binanceSigner).approve(uniswapV3RouterAddress, amountIn_DAI);
    txApprove.wait();
    console.log("txApprove hash:", txApprove.hash);
    const allowance = await dai.connect(binanceSigner).allowance(binanceAccount, uniswapV3RouterAddress);
    console.log("allowance:", allowance.toString());
    const params = {
        tokenIn: DAI,
        tokenOut: USDC,
        fee: poolFee_030percent,
        recipient: "0x34F3E4C1a8E93573433C1C23Aa159d0a3a383612",
        deadline: Math.floor(Date.now() / 1000) + 600, // 600s, 10min
        amountIn: amountIn_DAI,
        amountOutMinimum: 0,
        sqrtPriceLimitX96: 0,
    };
    // console.log("amountIn_DAI:", amountIn_DAI.toString());
    // let daiBalance = await dai.balanceOf(binanceAccount);
    // console.log("- DAI balance:", ethers.utils.formatEther(daiBalance));
    //console.log(params);

    const amountOut = await uniswapRouter.connect(binanceSigner).exactInputSingle(params);
    amountOut.wait();
    console.log("amountOut hash:", amountOut.hash);

}

async function main() {
    await getBalance();
    await SwapDaiForUsdc();
    await getBalance();
}

main().then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });