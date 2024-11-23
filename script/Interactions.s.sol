// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FromeoNFT} from "../src/FromeoNFT.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintNFT is Script {
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FromeoNFT", block.chainid);
        console.log("FromeoNFT deployed at", mostRecentlyDeployed);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        console.log("Minting NFT on contract", contractAddress);
        vm.startBroadcast();
        FromeoNFT(contractAddress).mintNFT(PUG_URI);
        vm.stopBroadcast();
    }
}

contract MintMoodNFT is Script{
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNFT", block.chainid);
        console.log("MoodNFT deployed at", mostRecentlyDeployed);
        mintMoodNFTOnContract(mostRecentlyDeployed);
    }

    function mintMoodNFTOnContract(address contractAddress) public {
        console.log("Minting MoodNFT on contract", contractAddress);
        vm.startBroadcast();
        MoodNFT(contractAddress).mintNFT();
        vm.stopBroadcast();
    }
}

contract FlipMoodNFT is Script{
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNFT", block.chainid);
        console.log("Flip mood of MoodNFT deployed at", mostRecentlyDeployed);
        flipMintedMoodNFTOnContract(mostRecentlyDeployed);
    }

    function flipMintedMoodNFTOnContract(address contractAddress) public {
        console.log("Flipping MoodNFT minted on contract", contractAddress);
        vm.startBroadcast();
        MoodNFT(contractAddress).flipMood(0);
        vm.stopBroadcast();
    }
}
