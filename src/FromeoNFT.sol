// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FromeoNFT is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToURI;

    constructor() ERC721("FromeoNFT", "FROMEO") {
        s_tokenCounter = 0;
    }

    // This function is used to mint a new NFT to the msg.sender, assign a tokenURI to the corresponding tokenCounter
    function mintNFT(string memory tokenURI) external {
        s_tokenIdToURI[s_tokenCounter] = tokenURI;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    // Token URI is the metadata of the NFT
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToURI[tokenId];
    }
}
