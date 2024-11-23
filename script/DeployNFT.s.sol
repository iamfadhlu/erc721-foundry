// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {FromeoNFT} from "../src/FromeoNFT.sol";
import {Script} from "forge-std/Script.sol";

contract DeployNFT is Script {
    function run() external returns (FromeoNFT) {
        vm.startBroadcast();
        FromeoNFT fromeoNFT = new FromeoNFT();
        vm.stopBroadcast();
        return fromeoNFT;
    }
}
