//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// only owner can NFT mint to users
contract Ankara4yanga is ERC721URIStorage {
    constructor() ERC721("Ankara4yanga", "A4Y"){}

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 MAX_SUPPLY = 29; // The NFT has a max supply of 29
    string nfturi = "ipfs://QmUpgEXndveyDFkXDQW3dp7ZiaSpZ7X9cfK54XwWwhguG9";


    function safeMint(address to) external returns(uint256) {
        uint256 newItemId = _tokenIds.current();
        require( newItemId <= MAX_SUPPLY, "Sorry, all NFTs have been minted");
        _mint(to, newItemId);
        _setTokenURI(newItemId, nfturi);

        _tokenIds.increment();
        return (newItemId);
    }

}