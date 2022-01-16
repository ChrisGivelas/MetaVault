// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    uint256 constant DAYS_TO_SECONDS =
        1 days * 24 hours * 60 minutes * 60 seconds;

    address public owner;
    bool public claimed;
    address[] public tokens_erc20;
    mapping(address => bool) public beneficiaries;

    uint256 public claimableDateInSeconds;
    bool public isRollingClaimableDate;
    uint256 public rollingClaimableWindowSeconds;

    event Deposit(address indexed token_erc20, uint256 indexed amount);
    event Withdraw(address indexed token_erc20, uint256 indexed amount);
    event ClaimVault(address indexed beneficiaryAddress);
    event AddBeneficiary(address indexed beneficiaryAddress);
    event RemoveBeneficiary(address indexed beneficiaryAddress);

    modifier onlyOwner() {
        require(msg.sender == owner, "The current account does not own this vault");
        _;
    }

    modifier updateClaimableDateIfRolling() {
        _;
        if(isRollingClaimableDate) {
            claimableDateInSeconds = block.timestamp + rollingClaimableWindowSeconds;
        }
    }

    constructor(address _owner) {
        owner = _owner;
        isRollingClaimableDate = true;
        // Defaults to a claimability window of 100 days
        rollingClaimableWindowSeconds = 100 * DAYS_TO_SECONDS;
        claimed = false;
    }

    function setRollingClaimableWindow(uint256 rollingClaimableWindowDays)
        public
        onlyOwner
    {
        isRollingClaimableDate = true;
        rollingClaimableWindowSeconds = rollingClaimableWindowDays * DAYS_TO_SECONDS;
    }

    function setStaticClaimableDate(uint256 daysTillSwitchActivates)
        public
        onlyOwner
    {
        isRollingClaimableDate = false;
        claimableDateInSeconds = block.timestamp + (daysTillSwitchActivates * DAYS_TO_SECONDS);
    }

    function addBeneficiary(address _address)
        public
        onlyOwner
        updateClaimableDateIfRolling
    {
        beneficiaries[_address] = true;
        emit AddBeneficiary(_address);
    }

    function removeBeneficiary(address _address)
        public
        onlyOwner
        updateClaimableDateIfRolling
    {
        delete beneficiaries[_address];
        emit RemoveBeneficiary(_address);
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
        onlyOwner
        updateClaimableDateIfRolling
        returns (bool success)
    {
        success = IERC20(token_erc20).transferFrom(msg.sender, address(this), amount);
        if(success) {
            emit Deposit(token_erc20, amount);
        }
    }

    function withdraw(address token_erc20, uint256 amount)
        public
        onlyOwner
        updateClaimableDateIfRolling
        returns (bool success)
    {
        success = IERC20(token_erc20).transferFrom(address(this), msg.sender, amount);
        if(success) {
            emit Withdraw(token_erc20, amount);
        }
    }

    function claimVault() 
        public
        returns(bool)
    {
        require(beneficiaries[msg.sender], "This account is not a beneficiary of this vault");
        require(block.timestamp > claimableDateInSeconds, "This vault cannot be claimed yet");
        require(!claimed, "This vault has already been claimed. Sorry, too slow!");

        for(uint i=0; i < tokens_erc20.length; i++) {
            withdraw(tokens_erc20[i], balanceOf(tokens_erc20[i]));
        }

        claimed = true;
        emit ClaimVault(msg.sender);

        return true;
    }
}
