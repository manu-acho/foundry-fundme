// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// run "forge test" in bash to test the contract
// run "forge snapshot" in bash to find out how much gas is used in the test and take a snapshot of the contract
// use "forge coverage" to check the code coverage of the contract
// use "vm.prank" to send a transaction from a different address
// use "makeAddr" to create a new address
// use "vm.expectRevert" to check if a transaction reverts
// use "vm.deal" to send ether to an address
// use "vm.txGasPrice" to set the gas price for the next transaction
// "tx.gasprice" (different from vm.txGasPrice) is an inbuilt variable that tells the gas price of the transaction
// use "vm.startPrank" to send a transaction from a different address
// use "vm.stopPrank" to stop sending a transaction from a different address
// use "assertEq" to check if two values are equal
// use "assert" to check if a condition is true
// use "forge inspect FundMe storageLayout" to check the storage layout of the contract

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    // We are going to inherit from the Test contract
    FundMe fundMe; // The fundMe variable of type FundMe is an instance of the FundMe contract
    // The variable below is an address that represents a user created by the makeAddr function found in the Test contract
    address USER = makeAddr("user"); 
    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 100 ether;
    //uint256 constant GAS_PRICE = 1;


    function setUp() external {
        // This function will run before each test
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run(); 
        vm.deal(USER, STARTING_BALANCE); // This function is used to send ether to the USER address
       // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); // The fundMe variable of type FundMe is an instance of the FundMe contract  
    }

    function testMinimumUsdIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsDeployer() public {
        console.log(fundMe.getOwner());
        console.log(address(this));
        console.log(msg.sender);
        // assertEq(fundMe.i_owner(), address(this)); // Check if the owner is the deployer of the contract (and not the caller of the FundMeTest contract)
        assertEq(fundMe.getOwner(), msg.sender); // Check if the owner is the caller of the FundMeTest contract
    }

   function testPriceFeedVersion() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
        console.log(version);
    }

    function testFundFailswithoutEnoughEth() public {
        vm.expectRevert(); // This is equivalent to assert(This transaction should revert)
        fundMe.fund(); // This should revert because value is not enough to meet the minimum requirement
        
    }

    function testFundUpdatesAddrToAmtFunded () public {
        //fundMe.fund{value: 5e18}(); // This should not revert because value is enough to meet the minimum requirement
        //assertEq(fundMe.s_addressToAmountFunded(address(this)), 5e18); // Check if the address to amount funded mapping has been updated
        vm.prank(USER); // the next transaction would be sent by the USER address. 
        fundMe.fund{value: SEND_VALUE}(); // This should not revert because value is enough to meet the minimum requirement
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToFundersArray() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        //vm.prank(USER);
        //fundMe.fund{value: SEND_VALUE}();
        vm.prank(USER); // the next transaction would be sent by the USER address. This equivalent to msg.sender = USER
        vm.expectRevert(); // This is equivalent to assert(This transaction should revert)
        fundMe.withdraw(); // This should revert because the caller is not the owner

    }

    function testWithDrawWithASingleFunder() public funded {
        // Set UP: Declare test variables
        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialFundMeBalance = address(fundMe).balance;
        
        // Act: Call the withdraw function
      //  uint256 gasStart = gasleft(); // Tells how much gas is left before the withdraw function is called
      //  vm.txGasPrice(GAS_PRICE); // This is equivalent to tx.gasprice = GAS_PRICE; It also sets the gas price for the next transaction
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
       // uint256 gasEnd = gasleft(); // Tells how much gas is left after the withdraw function is called
       // uint256 gasUsed = gasStart - gasEnd * tx.gasprice; // tx.gasprice is an inbuilt variable that tells the gas price of the transaction
       // console.log(gasUsed);

        // Assert: Check if the owner's balance has been updated
        uint256 finalOwnerBalance = fundMe.getOwner().balance;
        uint256 finalFundMeBalance = address(fundMe).balance;
        assertEq(finalFundMeBalance, 0);
        assertEq(initialOwnerBalance + initialFundMeBalance, finalOwnerBalance);
    }

    function testWithDrawFromMultiFunders() public funded{
        // Set UP: Declare test variables
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i <= numberOfFunders; i++) {
           // vm.prank(makeAddr("funder" + i));
           hoax(address(i), SEND_VALUE); // This is equivalent to fundMe.fund{value: SEND_VALUE}();
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialFundMeBalance = address(fundMe).balance;

        // Act: Call the withdraw function

        vm.startPrank(fundMe.getOwner()); // This is equivalent to vm.prank(fundMe.getOwner()); 
        fundMe.withdraw();
        vm.stopPrank(); 

        // Assert: Check if the owner's balance has been updated
        assert(address(fundMe).balance == 0);
        assert(initialFundMeBalance + initialOwnerBalance == fundMe.getOwner().balance);
        
     
    }


    function testWithDrawFromMultiFundersCheaper() public funded{
        // Set UP: Declare test variables
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i <= numberOfFunders; i++) {
           // vm.prank(makeAddr("funder" + i));
           hoax(address(i), SEND_VALUE); // This is equivalent to fundMe.fund{value: SEND_VALUE}();
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialFundMeBalance = address(fundMe).balance;

        // Act: Call the withdraw function

        vm.startPrank(fundMe.getOwner()); // This is equivalent to vm.prank(fundMe.getOwner()); 
        fundMe.cheaperWithdraw();
        vm.stopPrank(); 

        // Assert: Check if the owner's balance has been updated
        assert(address(fundMe).balance == 0);
        assert(initialFundMeBalance + initialOwnerBalance == fundMe.getOwner().balance);
        
     
    }
}