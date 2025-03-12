// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RandomG is Ownable {
    address[] public Gaddrs;
    address private randomG;

    constructor(address _owner, address _randomG) Ownable(_owner) {
        randomG = _randomG;
    }

    function generate(
        address _randomG
    ) external onlyOwner returns (address _genAddr) {
        bytes32 hash = keccak256(
            abi.encodePacked(block.timestamp, _randomG, block.prevrandao)
        );
        _genAddr = address(uint160(uint256(hash)));
        Gaddrs.push(_genAddr);
        return _genAddr;
    }

    function getAddr() external view onlyOwner returns (address) {
        require(Gaddrs.length > 0, "No addresses generated yet");
        return Gaddrs[Gaddrs.length - 1];
    }
}
