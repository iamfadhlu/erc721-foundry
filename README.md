# NFT Projects

This repository contains two NFT (Non-Fungible Token) smart contract implementations:

## Basic NFT

A simple NFT implementation that allows minting of tokens with sequential IDs. Each token has a fixed image URI that is set during deployment.

Features:
- ERC721 compliant
- Fixed token URI
- Sequential minting
- Gas efficient

## Mood NFT

An interactive NFT that can change its appearance based on the owner's mood.

Features:
- ERC721 compliant 
- Dynamic token URI that changes based on mood
- Two mood states: Happy 😊 and Sad 😢
- Owners can toggle their NFT's mood
- SVG images stored directly on-chain

## Storage Methods

### Basic NFT - IPFS Storage
The Basic NFT utilizes IPFS (InterPlanetary File System) for storing the NFT image:
- Image file is uploaded to IPFS network, generating a unique content hash
- Token URI points to IPFS metadata JSON file containing the IPFS image hash
- Decentralized storage ensures image permanence and immutability
- Cost effective since only the IPFS hash is stored on-chain

### Mood NFT - On-Chain SVG Storage
The Mood NFT stores artwork directly on the blockchain using SVG encoding:
- SVG images are encoded as base64 strings and stored fully on-chain
- No external storage dependencies or hosting required
- Images cannot be lost or changed since they're part of the contract state
- More gas intensive initially but guarantees permanent availability
- Dynamic SVG manipulation enables mood-based image switching


## Getting Started

1. Clone this repository
2. Install dependencies: `forge install`
3. Build: `forge build`
