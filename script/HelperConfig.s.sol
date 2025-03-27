// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.8;
import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address network;
    }

    NetworkConfig public activeNetwork;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaEthConfig();
        } else {
            activeNetwork = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory network = NetworkConfig({
            network: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return network;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetwork.network != address(0)) {
            return activeNetwork;
        }
        vm.startBroadcast();
        MockV3Aggregator mockobj = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();
        NetworkConfig memory network = NetworkConfig({
            network: address(mockobj)
        });
        return network;
    }
}
