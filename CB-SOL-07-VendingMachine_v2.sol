// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";

/*  CONTRACT PROPERTIES
1) Only the owner can add new products.
2) Only the owner can restock products.
3) Only the owner can access the machine's balance.
4) Anyone can buy products.
5) Only the owner can transfer the balance of the machine to his account.
*/

contract VendingMachine is Ownable {

    struct Snack {
        uint32 id;
        string name;
        uint32 quantity;
        uint256 price;  // USE uint256 TO SPECIFY THE PRICE IN wei
    }

    // Mapping from snack ID to Snack struct
    mapping(uint32 => Snack) private stock;
    uint32[] private snackIds;
    mapping(string => bool) private snackNameExists;
    uint32 private totalSnacks;

    // EVENTS
    event NewSnackAdded(string name, uint256 price);
    event SnackRestocked(string name, uint32 quantity);
    event SnackSold(string name, uint32 amount);

    constructor() Ownable(address(msg.sender)) {
        totalSnacks = 0;
    }

    function getAllSnacks() external view returns (Snack[] memory) {
        Snack[] memory snacks = new Snack[](snackIds.length);
        for (uint256 i = 0; i < snackIds.length; i++) {
            snacks[i] = stock[snackIds[i]];
        }
        return snacks;
    }

    function addNewSnack(string memory name, uint32 quantity, uint256 price) external onlyOwner {
        require(bytes(name).length != 0, "NULL NAME");                      // check if there is an input for the name
        require(price != 0, "NULL PRICE");                                  // check if there is an input for the price
        require(quantity != 0, "NULL QUANTITY");                            // check if there is an input for the quantity
        require(!snackNameExists[name], "SNACK ALREDY EXISTS");             // check if the product already exists (same name)

        Snack memory newSnack = Snack({
            id: totalSnacks,
            name: name,
            quantity: quantity,
            price: price        // price in wei
        //  price: price * 1e18 // price in ETH
        });

        stock[totalSnacks] = newSnack;
        snackIds.push(totalSnacks);
        snackNameExists[name] = true;
        totalSnacks++;
        emit NewSnackAdded(name, newSnack.price);
    }

    function restock(uint32 id, uint32 quantity) external onlyOwner {
        require(quantity != 0, "NULL QUANTITY");                            // check if there is an input for the required quantity
        require(id < totalSnacks, "INVALID SNACK ID");                      // check if there is an input for the required item ID

        stock[id].quantity += quantity;
        emit SnackRestocked(stock[id].name, stock[id].quantity);
    }

    function getMachineBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function buySnack(uint32 id, uint32 amount) external payable {
        require(amount > 0, "INVALID AMOUNT");                              // check if there is an input for the required quantity
        require(id < totalSnacks, "INVALID SNACK ID");                      // check if there is an input for the required item ID
        Snack storage snack = stock[id];
        require(snack.quantity >= amount, "INSUFFICIENT STOCK");            // check if there is enough stock
        require(msg.value >= amount * snack.price, "INSUFFICIENT BALANCE"); // check if there is enough balance for paying

        snack.quantity -= amount;

        // Refund excess payment if any
        uint256 totalCost = amount * snack.price;
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }

        emit SnackSold(snack.name, amount);
    }
}