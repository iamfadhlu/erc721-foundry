// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FromeoNFT} from "../../src/FromeoNFT.sol";
import {DeployNFT} from "../../script/DeployNFT.s.sol";

contract FromeoNFTTest is Test {
    FromeoNFT public fromeoNFT;
    DeployNFT public deployer;
    address public USER = makeAddr("user");
    string constant PUG_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployNFT();
        fromeoNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        // Arrange
        string memory expectedName = "FromeoNFT";
        string memory actualName = fromeoNFT.name();

        // Assert
        assertEq(keccak256(abi.encodePacked(expectedName)), keccak256(abi.encodePacked(actualName)));
    }

    function testSymbolIsCorrect() public view {
        // Arrange
        string memory expectedSymbol = "FROMEO";
        string memory actualSymbol = fromeoNFT.symbol();

        // Assert
        assertEq(keccak256(abi.encodePacked(expectedSymbol)), keccak256(abi.encodePacked(actualSymbol)));
    }

    function testCanMintAndHaveABalance() public {
        // Arrange
        vm.prank(USER);

        // Act
        fromeoNFT.mintNFT(PUG_URI);

        // Assert
        assertEq(fromeoNFT.balanceOf(USER), 1);
        assertEq(keccak256(abi.encodePacked(PUG_URI)), keccak256(abi.encodePacked(fromeoNFT.tokenURI(0))));
    }
}
