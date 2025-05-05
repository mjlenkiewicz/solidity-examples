// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract EthSender {
    
    //Events 
    event sendStatus (bool success);
    event callStatus (bool success, bytes data);

    constructor () payable {}
    receive () external payable {}

    //Transfer 
    function usingTransfer (address payable _to) public payable 
    {
        _to.transfer(1 ether); //1 ether = 1*10^18 wei
    }

    //Send
    function usingSend (address payable _to) public payable
    {
       bool success = _to.send(1 ether);
       emit sendStatus(success);
    }

    //Call
    function usingCall (address payable _to) public payable
    {
       (bool success, bytes memory data)= _to.call{value: 1 ether}("");
        emit callStatus(success, data);
    }
}


contract EthReceiver {
    //Event
    event transactInfo(uint amount, uint gas);
    receive () external payable {
        emit transactInfo (address(this).balance, gasleft());
    }

}