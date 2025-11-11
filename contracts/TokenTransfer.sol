// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
}

contract TokenTransfer {
    address public owner;

    event TokenSent(address indexed token, address indexed from, address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el owner puede ejecutar esto");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transferToken(address token, address to, uint256 amount) external onlyOwner {
        bool success = IERC20(token).transfer(to, amount);
        require(success, "Transferencia fallida");
        emit TokenSent(token, address(this), to, amount);
    }

    function transferFromUser(address token, address from, address to, uint256 amount) external {
        bool success = IERC20(token).transferFrom(from, to, amount);
        require(success, "transferFrom fallida");
        emit TokenSent(token, from, to, amount);
    }

    function contractTokenBalance(address token) external view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }
}