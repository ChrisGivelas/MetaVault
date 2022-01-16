//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "./Vault.sol";

interface IMetaVault {
    event VaultCreated(address indexed creator, address indexed vaultAddress);

    function createVault(uint256 switchActivationDate)
        external
        returns (address vaultAddress);
}

contract MetaVault is ERC721, IMetaVault {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => address) public vaultOwners;

    constructor() ERC721("Meta Vault NFT", "MV") {}

    function createVault(uint256 switchActivationDate)
        external
        override
        returns (address vaultAddress)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(_msgSender(), newItemId);

        vaultAddress = address(new Vault(_msgSender(), switchActivationDate));
        vaultOwners[newItemId] = vaultAddress;
        emit VaultCreated(_msgSender(), vaultAddress);
        return vaultAddress;
    }
}
