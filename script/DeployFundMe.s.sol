// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.8;

import {Script} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helpconfigObj = new HelperConfig();
        address ethpriceAddress = helpconfigObj.activeNetwork();
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethpriceAddress);
        vm.stopBroadcast();
        return fundme;
    }
}
