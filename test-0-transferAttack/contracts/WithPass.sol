// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WithPass is Ownable {
    bytes32 private password;

    constructor(address _owner, bytes32 _password) Ownable(_owner) {
        password = _password;
    }

    modifier checkPass(bytes32 _password) {
        require(password == _password, "Password not matched");
        _;
    }

    function deposit() external payable onlyOwner {}

    function withdraw(bytes32 _password) external checkPass(_password) {
        payable(msg.sender).transfer(address(this).balance);
    }
}
