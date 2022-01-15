//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Vault.sol";

contract MetaVault is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => address) public vaultOwners;

    constructor() ERC721("Meta Vault NFT", "MV") {}

    function createVault(uint256 switchActivationDate)
        public
        returns (address vaultAddress)
    {
        require(
            this.balanceOf(msg.sender) == 0,
            "Account already has a vault token"
        );

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);

        vaultAddress = address(new Vault(msg.sender, switchActivationDate));
        vaultOwners[newItemId] = vaultAddress;
    }
}
