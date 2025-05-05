// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

/*
    msg.data EMPTY?
    A. NO => The fallback() function is called
    B. SÍ => Is there a receive() function?
        B.1) YES => The receive() Sfunction is called
        B.2) NO  => The fallback() function is called
*/

contract Receive_Fallback {
    //EVENT
    event info (string _funcion, address _sender, uint _amount, bytes _data);

    fallback() external payable
    {
        emit info("fallback", msg.sender, msg.value, msg.data);
    }
/*
    receive() external payable
    {
        emit info("receive", msg.sender, msg.value, "");
    } */
}


