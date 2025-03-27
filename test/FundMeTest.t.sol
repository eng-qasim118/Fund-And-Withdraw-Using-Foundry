// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.8;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;
    DeployFundMe deploy = new DeployFundMe();
    address USER = makeAddr("user");

    function setUp() external {
        fundme = deploy.run();
        vm.deal(USER, 10e18);
    }

    function testMinimumDollarfive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerISDeployer() public {
        console.log("owner", fundme.getOwner());
        assertEq(fundme.getOwner(), msg.sender);
    }

    function testVersion() public {
        uint version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testFundReceive() public {
        vm.expectRevert();
        fundme.fund();
    }

    function testFundUpdates() public {
        vm.prank(USER);
        fundme.fund{value: 1e18}();
        uint ammount = fundme.getAddressToAmmount(USER);
        assertEq(ammount, 1e18);
    }

    function testFundArrayUpdate() public {
        vm.prank(USER);
        fundme.fund{value: 1e18}();
        address funder = fundme.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: 1e18}();
        _;
    }

    function testOnlyOwnerWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        uint startingOwnerBalance = fundme.getOwner().balance;
        uint startingFundMeBalance = address(fundme).balance;

        vm.prank(fundme.getOwner());
        fundme.withdraw();

        uint endingOwnerBalance = fundme.getOwner().balance;
        uint endingFundMeBalance = address(fundme).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
    }

    function testWithdrawWithMultipleFunder() public funded {
        uint160 noOfFunders = 10;
        uint160 startingFundedIndex = 1;

        for (uint160 i = startingFundedIndex; i <= noOfFunders; i++) {
            hoax(address(i), 2e18);
            fundme.fund{value: 1e18}();
        }

        uint startingOwnerBalance = fundme.getOwner().balance;
        uint startingFundMeBalance = address(fundme).balance;

        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();
        assertEq(
            fundme.getOwner().balance,
            startingOwnerBalance + startingFundMeBalance
        );
        assertEq(address(fundme).balance, 0);
    }

    function testWithdrawCheaperWithMultipleFunder() public funded {
        uint160 noOfFunders = 10;
        uint160 startingFundedIndex = 1;

        for (uint160 i = startingFundedIndex; i <= noOfFunders; i++) {
            hoax(address(i), 2e18);
            fundme.fund{value: 1e18}();
        }

        uint startingOwnerBalance = fundme.getOwner().balance;
        uint startingFundMeBalance = address(fundme).balance;

        vm.startPrank(fundme.getOwner());
        fundme.withdrawCheaper();
        vm.stopPrank();
        assertEq(
            fundme.getOwner().balance,
            startingOwnerBalance + startingFundMeBalance
        );
        assertEq(address(fundme).balance, 0);
    }
}
