// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {

    string _baseTokenURI;
    uint256 public _price = 0.01 ether;
    bool public _paused;
    uint256 public maxTokenCount = 20;
    uint256 public currTokenCount;

    IWhitelist whitelist;

    bool public isPreSaleStarted;
    uint256 public endDate;


    modifier onlyWhenNotPaused {
        require(!_paused, "Minting not available at the moment");
        _;
    }

    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        isPreSaleStarted = true;
        endDate = block.timestamp + 15 minutes;
    }

    function preSaleMint() public payable onlyWhenNotPaused {
        require(isPreSaleStarted && block.timestamp < endDate, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(maxTokenCount > currTokenCount, "Maximum number of NFT already minted.");
        require(msg.value >= _price, "Insufficient Balance");
        currTokenCount++;

        _safeMint(msg.sender, currTokenCount);
    }

    function _mint() public payable onlyWhenNotPaused {
        require(isPreSaleStarted && block.timestamp < endDate, "Presale is not running");
        require(maxTokenCount < currTokenCount, "Maximum number of NFT already minted.");
        require(msg.value >= _price, "Insufficient Balance");
        currTokenCount++;

        _safeMint(msg.sender, currTokenCount);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

}