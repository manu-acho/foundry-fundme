// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol"; 
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";


contract DeployFundMe is Script {
    FundMe fundMe;
    HelperConfig helperConfig;

    function run() external returns (FundMe){
        // before broadcasting, we can set the activeNetworkConfig => not a real txn
        helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        // After start broadcast, we can't change the activeNetworkConfig => real txn
        vm.startBroadcast();
        //0x694AA1769357215DE4FAC081bf1f309aDC325306
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }

}

