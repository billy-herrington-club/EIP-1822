//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "./Proxiable.sol"; 

contract Sandwich is UUPSProxiable {

    string[] buns; 
    string[] meats;

    string public bun;
    string public meat; 

//0x8129fc1c
    function initialize() public {
        buns = ["white", "brown"];
        meats = ["beef", "chicken", "fish"]; 
        bun = buns[0];
        meat = buns[0];
    }

    function setRandomOrder() external {
        uint256 random = block.timestamp; 
        bun = buns[random % 2]; 
        meat = meats[random % 3]; 
    }

    function setImplementation(address newImplementation)
        external
    {
        _setImplementation(newImplementation);
    }

       function getOrder() external view returns (string[2] memory) {
        return [bun, meat];
    }
}

contract Burger is UUPSProxiable {

    string[] buns;
    string[] meats;
    string public bun;
    string public meat; 

    //Put new variables into empty storage slots
    string[] vegetables; 
    string[] sauces;

    string public vegetable;
    string public sauce; 

    function initialize() public {
        buns = ["white", "brown", "garlic"];
        meats = ["beef", "chicken", "fish"]; 
        vegetables = ["lettuce", "tomato", "pickle"];
        sauces =  ["ketchup", "bbq", "mustard"];
        bun = buns[2];
        meat = meats[2];
        vegetable = vegetables[0];
        sauce = sauces[0];
    }

    function setRandomOrder() external {
        uint256 random = block.timestamp;
        uint256 bunRandom = random % 3;
        uint256 allRandom = random % 3;  
        bun = buns[bunRandom]; 
        meat = meats[allRandom]; 
        vegetable = vegetables[allRandom];
        sauce = sauces[allRandom];
    }

    function setImplementation(address newImplementation)
        external
    {
        _setImplementation(newImplementation);
    }

    function getOrder() external view returns (string[4] memory) {
        return [bun, meat, vegetable, sauce];
    }
}