// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

interface ISavings {
    function deposit() external payable;
    function withdraw() external;
}

contract Invest is Ownable {
    ISavings public immutable savingsAccount;

    constructor(address _owner, address savingAccountAddress) Ownable(_owner) {
        savingsAccount = ISavings(savingAccountAddress);
    }

    function depostiToTheSavingsAccount() external payable onlyOwner {
        savingsAccount.deposit{value: msg.value}();
    }

    function withdrawToTheSavingsAccount() external payable onlyOwner {
        savingsAccount.withdraw();
    }

    receive() external payable {}
}
