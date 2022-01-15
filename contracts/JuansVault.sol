// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract JuansVault {
    address public owner;
    address[] tokens_erc20;

    constructor() {
        owner = msg.sender;
    }

    function balanceOf(address token_erc20)
        public
        view
        virtual
        returns (uint256)
    {
        return IERC20(token_erc20).balanceOf(address(this));
    }

    function deposit(address token_erc20, uint256 amount)
        public
        returns (bool)
    {
        IERC20(token_erc20).transferFrom(owner, address(this), amount);
        return true;
    }

    function withdraw(
        address token_erc20,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        IERC20(token_erc20).transfer(recipient, amount);
        return true;
    }
}
