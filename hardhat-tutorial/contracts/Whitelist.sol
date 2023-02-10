// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Whitelist {
    uint8 public maxWhitelistAddress;

    mapping(address => bool) public whitelistedAddresses;

    uint8 public numAddressesWhitelisted;

    constructor(uint8 _maxWhitelistAddres) {
        maxWhitelistAddress = _maxWhitelistAddres;
    }

    function addAddressToWhitelist() public {
        require(!whitelistedAddresses[msg.sender], "Address is already been whitelisted.");
        require(numAddressesWhitelisted < maxWhitelistAddress, "Whitelist is already full!");

        // Add address if conditions above aren't met
        whitelistedAddresses[msg.sender] = true;
        // Increase number of whitelisted
        numAddressesWhitelisted += 1;

    }


}