// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract ShameCoin is ERC20 {
    address public immutable admin;

    constructor(address _admin) ERC20("ShameCoin", "SMC") {
        admin = _admin;
    }

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        require(amount == 1, "Only 1 token once.");
        if (msg.sender == admin) {
            _transfer(admin, to, 1);
        } else {
            _mint(msg.sender, 1);
        }

        return true;
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        require(
            spender == admin && amount == 1,
            "Only admin can be approved to spend 1 token."
        );
        _approve(msg.sender, admin, 1);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        require(
            msg.sender == admin && amount == 1,
            "Only admin can spend 1 token"
        );
        _spendAllowance(from, admin, 1);
        _transfer(from, to, 1);
        return true;
    }

    function faucet() external {
        _mint(msg.sender, 10);
    }
}
