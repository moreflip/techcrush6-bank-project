// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract BankProject1 {
    uint256 totalAmountInBank;
    uint userBalance = differentAccounts[msg.sender].balance;

    struct Accounts {
        string name;
        uint256 balance;
        address accountAddress;
        bool accountStatus;
        // bytes bvn;
    }

    mapping(address => Accounts) public differentAccounts;

    // internal functions for checks

    function checkAccounts() internal view {
        require(
            differentAccounts[msg.sender].accountStatus == true || differentAccounts[msg.sender].balance > 0,
            "Account not found or insufficient balance"
        );
    }

    function checkValues() internal {
        require(msg.value > 0, "Deposit amount must be greater than 0");
    }

    // user create account
    function createAccount(string memory _name) public {
        differentAccounts[msg.sender] =
            Accounts({name: _name, balance: 0, accountAddress: msg.sender, accountStatus: true});
    }

    // user deposit money into different banks

    function userDeposit() public payable {
        // first user pulls out his account
        checkAccounts();
        checkValues();
        userBalance += msg.value;
        totalAmountInBank += msg.value;
    }

    function userWithdraw(uint256 _amount) public {
        // user withdraw from their balance
        checkAccounts();
        require(userBalance >= _amount, "Insufficient balance");
        userBalance -= _amount;
        totalAmountInBank -= _amount;
        (bool isWithdrawn,) = payable(msg.sender).call{value: _amount}("");
        require(isWithdrawn, "Failed to withdraw");
    }

    //fuction for user to transfer to user b

    function transferToUser(address _to, uint256 _amount) public {
        checkAccounts();
        require(differentAccounts[_to].accountStatus == true, "Account not found");
        require(userBalance >= _amount, "Insufficient balance");
        userBalance -= _amount;
        differentAccounts[_to].balance += _amount;
    }

    function closeAccount() public {
        checkAccounts();
        totalAmountInBank -= userBalance;
        delete differentAccounts[msg.sender];
    }

    function getTotalBalanceInBank() public view returns (uint256) {
        return totalAmountInBank;
    }
}
