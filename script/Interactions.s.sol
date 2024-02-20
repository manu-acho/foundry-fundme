// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {Script, console} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";


contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 1 ether;
   // address mostRecentlyDeployed;

    function fundFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        console.log("Funded FundMe contract with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed=DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
      //  mostRecentlyDeployed = 0xA8452Ec99ce0C64f20701dB7dD3abDb607c00496;
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}


contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance!");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
    }
}



/*
pragma solidity ^0.8.18;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 1 ether;

    function fundFundMe(address fundMeAddress) public {
        require(fundMeAddress != address(0), "Invalid FundMe contract address");
        FundMe(payable(fundMeAddress)).fund{value: SEND_VALUE}();
        console.log("Funded FundMe contract with %s", SEND_VALUE);
    }

    function run(address fundMeAddress) external {
        vm.startBroadcast();
        fundFundMe(fundMeAddress);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address fundMeAddress) public {
        require(fundMeAddress != address(0), "Invalid FundMe contract address");
        vm.startBroadcast();
        FundMe(payable(fundMeAddress)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrawn from FundMe contract");
    }

    function run(address fundMeAddress) external {
        withdrawFundMe(fundMeAddress);
    }
}

*/