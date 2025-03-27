// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.8;
import {Script} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract fundFundME is Script {
    function fundfundme(address _most_recent_deploy) public {
        vm.startBroadcast();
        FundMe(payable(_most_recent_deploy)).fund{value: 18e18}();
        vm.stopBroadcast();
    }

    function run() external {
        address MostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundfundme(MostRecentDeployed);
    }
}

contract withdrawFundME is Script {}
