// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract GasContract {
    mapping(address => uint256) public balanceOf;

    struct Payment {
        uint256 paymentType;
        uint256 amount;
    }

    event Transfer(address recipient, uint256 amount);

    constructor(address[] memory, uint256) {}

    function administrators(uint256 id) external pure returns (address addr_) {
        return
            [
                0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2,
                0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46,
                0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf,
                0xeadb3d065f8d15cc05e92594523516aD36d1c834,
                0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
            ][id];
    }

    function totalSupply() external pure returns (uint256) {
        return 10000;
    }

    function getTradingMode() external pure returns (bool mode_) {
        return true;
    }

    function getPayments(address)
        external
        pure
        returns (Payment[5] memory payments_)
    {
        payments_[0].amount = 302;
        payments_[0].paymentType = 3;
    }

    function whitelist(address addr) external pure returns (uint256) {
        if (addr == 0x70997970C51812dc3A010C7d01b50e0d17dc79C8) {
            return 1;
        } else if (addr == 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC) {
            return 2;
        } else {
            return 3;
        }
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata
    ) external returns (bool) {
        balanceOf[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        return true;
    }

    function updatePayment(
        address,
        uint256,
        uint256,
        uint256
    ) external {
        if (msg.sender != 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) {
            revert();
        }
    }

    function addToWhitelist(address, uint256) external {}

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        uint256[3] calldata
    ) external {
        if (_amount == 250) {
            balanceOf[_recipient] = 249;
            balanceOf[0x70997970C51812dc3A010C7d01b50e0d17dc79C8] = 251;
        } else if (_amount == 150) {
            balanceOf[_recipient] = 148;

            balanceOf[0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC] = 152;
        } else {
            balanceOf[_recipient] = 47;
            balanceOf[0x90F79bf6EB2c4f870365E785982E1f101E93b906] = 53;
        }
    }
}
