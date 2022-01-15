// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
 
contract Vault {
    uint256 constant DAYS_TO_SECONDS = 1 days * 24 hours * 60 minutes * 60 seconds;
    address owner;
    uint256 daysTillSwitchActivates;
    address[] tokens_erc20;
    address[] beneficiaries;

    constructor(address _owner, uint256 _daysTillSwitchActivates) {
        owner = _owner;
        setDaysTillSwitchActivates(_daysTillSwitchActivates);
    }

    function setDaysTillSwitchActivates(uint256 _daysTillSwitchActivates) public {
        require(msg.sender == owner, "This account does not own this vault");
        daysTillSwitchActivates = block.timestamp + (_daysTillSwitchActivates * DAYS_TO_SECONDS);
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

    function claimVault() public returns(bool) {
        require(block.timestamp > daysTillSwitchActivates * DAYS_TO_SECONDS, "This vault cannot be claimed yet");

        //Finish implementation...

        return true;
    }
}
