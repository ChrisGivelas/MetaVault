//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;

// We import this library to be able to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./VaultFactory.sol";


// This is the main building block for smart contracts.
contract MetaVaultToken is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => address) public vaultOwners;

    constructor() ERC721("Meta Vault Token", "MVT"){}

    function createVault(uint256 switchActivationDate) public returns (address vaultAddress) {
        require(this.balanceOf(msg.sender) == 0, "Account already has a vault token");

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);

        vaultAddress = address(new Vault(msg.sender, switchActivationDate));
        vaultOwners[newItemId] = vaultAddress;
    }
}
