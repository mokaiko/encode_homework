// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InteractWithUniswap {
    ISwapRouter private swapRouter;
    IERC20 private DAI;
    address private daiAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private routerAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    constructor() {
        swapRouter = ISwapRouter(routerAddress);
        DAI = IERC20(daiAddress);
    }

    function swapFromDAI(ISwapRouter.ExactInputSingleParams memory params)
        public
        returns (uint256)
    {
        require(
            DAI.transferFrom(msg.sender, address(this), params.amountIn),
            "transferFrom failed."
        );
        require(
            DAI.approve(address(routerAddress), params.amountIn),
            "approve failed."
        );

        return swapRouter.exactInputSingle(params);
    }
}
