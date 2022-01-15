pragma solidity ^0.7.0;

import "hardhat/console.sol";

import "./Vault.sol";

contract VaultFactory {
    mapping(uint256 => address) public vaultOwners;

    function createNewVault(uint256 nftId) public returns(address vaultAddress) {
        require(vaultOwners[nftId] == address(0), "A vault for this user already exists");

        vaultAddress = address(new Vault(msg.sender));

        vaultOwners[nftId] = vaultAddress;
    }
}