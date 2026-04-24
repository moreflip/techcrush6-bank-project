// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import {Test} from "forge-std/Test.sol";
import {BankProject1} from "../src/BankProject1.sol";

contract BankProjectTest is Test {
    BankProject1 public bank;
    address public user1;
    address public user2;

    function setUp() public {
        bank = new BankProject1();
        user1 = address(1);
        user2 = address(2);
    }

    function setupUser() internal {
        vm.prank(user1);
        bank.createAccount("John Brian");
    }

    function fundUser() internal {
        vm.deal(user1, 1 ether);
    }

    function testCreateAccount() public {
        setupUser();

        (string memory name, uint256 balance, address accountAddress, bool accountStatus) =
            bank.differentAccounts(user1);

        assertEq(name, "John Brian");
        assertEq(balance, 0);
        assertEq(accountAddress, user1);
        assertEq(accountStatus, true);
    }

    function testUserDeposit() public {
        // Give user1 some ETH to work with
        fundUser();

        // user1 must have an account before depositing
        setupUser();

        // Now deposit
        vm.prank(user1);
        bank.userDeposit{value: 1000}();

        // // Destructure tuple to read balance
        (, uint256 balance,,) = bank.differentAccounts(user1);

        assertEq(balance, 1000);
        assertEq(bank.getTotalBalanceInBank(), 1000);
    }

    function testUserWithdraw() public {
        // user must have a balance
        // user must have an account
        fundUser();
        setupUser();

        vm.prank(user1);
        bank.userDeposit{value: 1000}();

        vm.prank(user1);
        bank.userWithdraw(500);

        (, uint256 balance,,) = bank.differentAccounts(user1);

        assertEq(balance, 500);
        assertEq(bank.getTotalBalanceInBank(), 500);
    }

    function testTransferToUser() public {
        // user must have a balance
        // user must have an account
        // user2 must have an account too

        fundUser();
        vm.deal(user2, 1 ether);

        setupUser();
        vm.prank(user2);
        bank.createAccount("John Brian");

        vm.prank(user1);
        bank.userDeposit{value: 1000}();

        vm.prank(user1);
        bank.transferToUser(user2, 500);

        (, uint256 balance,,) = bank.differentAccounts(user1);
        (, uint256 balance2,,) = bank.differentAccounts(user2);

        assertEq(balance, 500);
        assertEq(balance2, 500);
        assertEq(bank.getTotalBalanceInBank(), 1000);
    }

    function testCloseAccount() public {
        // user must have an account

        setupUser();
        fundUser();

        vm.prank(user1);
        bank.userDeposit{value: 1000}();

        vm.prank(user1);
        bank.closeAccount();

        (, uint256 balance,,) = bank.differentAccounts(user1);

        assertEq(balance, 0);
        assertEq(bank.getTotalBalanceInBank(), 0);
    }

    // vm.deal to give user1 some ETH to work with
    // user1 must have an account before depositing
}
