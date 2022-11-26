import { expect } from "chai";
import { ethers } from "hardhat";
import { abi as SwapRouterABI } from "@uniswap/v3-periphery/artifacts/contracts/interfaces/ISwapRouter.sol/ISwapRouter.json";
import IERC20 from "../contracts/IERC20.json";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

const binanceAccount = "0xDFd5293D8e347dFe59E90eFd55b2956a1343963d";
const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const BUSD = "0x4Fabb145d64652a948d72533023f6E7A623C7C53";

const poolFee_005percent = 500;
const poolFee_030percent = 3000;

const amountIn_DAI = ethers.utils.parseEther("100");

const provider = ethers.provider;

const dai = new ethers.Contract(DAI, IERC20, provider);
const usdc = new ethers.Contract(USDC, IERC20, provider);
const busd = new ethers.Contract(BUSD, IERC20, provider);

describe("Test Interact With Uniswap", async () => {

    async function deployContracrFixture() {
        const binanceSigner = await ethers.getImpersonatedSigner(binanceAccount);
        console.log("binanceSigner:", binanceSigner.address);

        const Router = await ethers.getContractFactory("InteractWithUniswap");
        const router = await Router.deploy();
        await router.deployed();

        console.log("contract deployed to:", router.address);
        return { binanceSigner, router };
    }

    it("Should swap DAI to USDC", async () => {
        const { binanceSigner, router } = await loadFixture(deployContracrFixture);
        const daiBalance = await dai.balanceOf(binanceAccount);
        const usdcBalance = await usdc.balanceOf(binanceAccount);
        const busdBalance = await busd.balanceOf(binanceAccount);

        const txApprove = await dai.connect(binanceSigner).approve(router.address, amountIn_DAI);
        await txApprove.wait();
        const allowance = await dai.connect(binanceSigner).allowance(binanceAccount, router.address);
        expect(allowance).to.equals(amountIn_DAI);

        const params = {
            tokenIn: DAI,
            tokenOut: USDC,
            fee: poolFee_030percent,
            recipient: binanceAccount,
            deadline: Math.floor(Date.now() / 1000) + 600, // 600s, 10min
            amountIn: amountIn_DAI,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0,
        };

        const amountOut = await router.connect(binanceSigner).swapFromDAI(params);
        await amountOut.wait();

        expect(await dai.balanceOf(binanceAccount)).to.equals(daiBalance.sub(ethers.utils.parseEther("100")));
        expect(await usdc.balanceOf(binanceAccount)).to.greaterThan(usdcBalance);
    });

    it("Should swap DAI to BUSD", async () => {
        const { binanceSigner, router } = await loadFixture(deployContracrFixture);
        const daiBalance = await dai.balanceOf(binanceAccount);
        const usdcBalance = await usdc.balanceOf(binanceAccount);
        const busdBalance = await busd.balanceOf(binanceAccount);

        const txApprove = await dai.connect(binanceSigner).approve(router.address, amountIn_DAI);
        await txApprove.wait();

        const allowance = await dai.connect(binanceSigner).allowance(binanceAccount, router.address);
        expect(allowance).to.equals(amountIn_DAI);

        const params = {
            tokenIn: DAI,
            tokenOut: BUSD,
            fee: poolFee_005percent,
            recipient: binanceAccount,
            deadline: Math.floor(Date.now() / 1000) + 600, // 600s, 10min
            amountIn: amountIn_DAI,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0,
        };

        const amountOut = await router.connect(binanceSigner).swapFromDAI(params);
        await amountOut.wait();

        expect(await dai.balanceOf(binanceAccount)).to.equals(daiBalance.sub(ethers.utils.parseEther("100")));
        expect(await busd.balanceOf(binanceAccount)).to.greaterThan(busdBalance);
    });
});