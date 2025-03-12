// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

// Goal to test underflow and overflow uints

contract SimpleToken is Ownable {
    mapping(address => uint256) private balances;
    uint256 private totalSupply;

    constructor(address _owner, uint256 _initialSupply) Ownable(_owner) {
        totalSupply = _initialSupply;
        balances[msg.sender] = _initialSupply;
    }

    function getTotalSupply() external view returns (uint256) {
        return totalSupply;
    }

    function getBalanceOf(address _addr) external view returns (uint256) {
        return balances[_addr];
    }

    function transfer(address _to, uint256 _amount) external {
        require(balances[msg.sender] - _amount >= 0, "Not enough to transfer");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    function mint(uint256 amount) external {
        totalSupply += amount;
        balances[owner()] += amount;
    }
}
