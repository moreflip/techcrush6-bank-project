// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// import {BankProject1} from "./BankProject1.sol";

contract ForLoop {
    struct Accounts {
        string name;
        uint256 balance;
        address accountAddress;
        bool accountStatus;
    }

    // BankProject1 public bank;
    Accounts[] public accounts;

    // constructor() {
    //   bank = new BankProject1();
    // }

    function addNewAccounts(string memory _name, uint256 _balance, address _accountAddress, bool _accountStatus)
        public
    {
        for (uint256 i = 0; i < 10; i++) {
            accounts.push(
                Accounts({
                    name: _name, balance: _balance, accountAddress: _accountAddress, accountStatus: _accountStatus
                })
            );
        }
    }
}
