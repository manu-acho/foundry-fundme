// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; 

// To deploy mocks on a local anvil chain
// To keep track of contract addresses across different networks (chains)
// For cases where either Sepolia ETH/USD or Mainnet ETH/USD has a different address (or is not available)

import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "test/mocks/MockV3Aggregator.sol"; 

contract HelperConfig is Script {
    // If we are deploying on a local chain, we can use the MockV3Aggregator contract
    // If we are deploying on a testnet or mainnet, we can use the AggregatorV3Interface contract
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        //string networkName;
        address ethUsdPriceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            // Deploy Sepolia Price Feed contract
            activeNetworkConfig = getSepoliaEthConfig(); 
        } else if (block.chainid == 1) {
            // Deploy Mainnet Price Feed contract
            activeNetworkConfig = getMainnetEthConfig();
        }
        else {
            // Deploy Mock Price Feed contract
            activeNetworkConfig = getOrCreateAnvilEthConfig();}
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // Sepolia ETH / USD Address
        NetworkConfig memory sepoliaConfig = NetworkConfig({ethUsdPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }


     function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        // Mainnet ETH / USD Address
        NetworkConfig memory ethConfig = NetworkConfig({ethUsdPriceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});

        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if(activeNetworkConfig.ethUsdPriceFeed != address(0)){
            return activeNetworkConfig;
        }
        // Anvil ETH / USD Address
        // To deploy mocks on a local anvil chain
        // To return a mock address
        vm.startBroadcast();
        MockV3Aggregator mockethUsdPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({ethUsdPriceFeed: address(mockethUsdPriceFeed)});

        return anvilConfig;

    }
}