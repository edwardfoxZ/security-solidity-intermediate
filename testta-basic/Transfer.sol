// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./RandomG.sol";

contract Transfer is Ownable, ReentrancyGuard {
    RandomG public randomG;
    address payable private to;

    constructor(address _randomG) Ownable(msg.sender) {
        require(_randomG != address(0), "Invalid RandomG address");
        randomG = RandomG(_randomG);
        address retrievedAddr = randomG.getAddr();
        require(retrievedAddr != address(0), "Invalid address from RandomG");
        to = payable(retrievedAddr);
    }

    function transfer(uint256 amount) external payable nonReentrant {
        require(msg.value >= 0.003 ether, "Not enough ether to transfer");
        require(to != address(0), "Recipient address is zero");
        require(
            address(this).balance >= amount,
            "Insufficient contract balance"
        );

        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed");
    }
}
