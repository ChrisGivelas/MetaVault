// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract JuansVault {
    address[] erc20_tokens;

    function balanceOf(address erc20_token)
        public
        view
        virtual
        returns (uint256)
    {
        return IERC20(erc20_token).balanceOf(address(this));
    }

    function withdraw(
        address erc20_token,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        IERC20(erc20_token).transfer(recipient, amount);
        return true;
    }
}
