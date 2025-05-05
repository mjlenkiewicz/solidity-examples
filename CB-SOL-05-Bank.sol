// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

contract Bank {

    //Variables
    mapping (address => uint) balance ;

    //Events
    event Transfer (address _from, address _to, uint _amount);



    //Functions
    function addBalance (uint _amount) external returns (uint _balance){
        balance[msg.sender]+=_amount;
        return balance[msg.sender];
    }

    function getBalance() external view returns (uint _balance){
        return balance[msg.sender];
    }

    function transfer(address _to, uint _amount) external {
        _transfer (msg.sender, _to, _amount);
    }

    function _transfer(address _from, address _to, uint _amount) private {
        balance[_from]-=_amount;
        balance[_to]+=_amount;
        emit Transfer (_from, _to, _amount);
    }
}