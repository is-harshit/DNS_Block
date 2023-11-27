// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
error Unauthorized();
error AlreadyRegistered();
error InvalidName(string name);
// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {StringUtils} from "./libraries/StringUtils.sol";
// We import another help function
import "@openzeppelin/contracts/utils/Base64.sol";

import "hardhat/console.sol";


contract Domains is ERC721URIStorage {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  
  string public tld;
  
  // We'll be storing our NFT images on chain as SVGs
  string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 370 370" style="enable-background:new 0 0 512 512" xml:space="preserve" width="370" height="370"><path style="fill:#6eb4f0" d="M261.559 177.461s57.416 25.518 63.795 51.036c6.38 25.518-19.138 53.827-19.138 53.827-3.589 21.93-19.138 29.106-19.138 29.106-6.911 17.278-25.518 12.759-25.518 12.759-12.759 6.38-23.507-1.223-31.897-12.759-10.632-14.619-17.892-8.062-26.183-19.671-6.646-9.303-18.474-41.334-18.474-62.466V177.46h76.553z"/><path style="fill:#78c8ff" d="M197.764 177.461h63.795s57.416 25.518 63.795 51.036c6.38 25.518-19.138 53.827-19.138 53.827s-70.174-28.309-108.451-104.863z"/><path style="fill:#6b829b" d="M203.478 291.759c-6.645-9.303-18.473-41.334-18.473-62.466V177.46h12.759c.797 52.232 31.897 133.969 31.897 133.969-10.633-14.62-17.892-8.063-26.183-19.67z"/><path style="fill:#6eb4f0" d="M349.458 43.491c12.667 0 20.542 6.097 20.542 19.137 0 6.38-2.588 15.129-7.782 25.518-19.138 38.277-6.38 82.933-25.518 95.692-19.138 12.759-138.936-6.38-138.936-6.38v-12.759c.001.001 49.424-121.209 151.694-121.209z"/><path style="fill:#5f9beb" d="M349.458 43.491c12.667 0 20.542 6.097 20.542 19.137 0 2.301-.456 5.007-1.13 7.889-36.592 27.505-105.353 76.259-171.105 106.943v-12.759c0 .001 49.423-121.21 151.693-121.21z"/><path style="fill:#5a464b" d="M312.595 69.009c-61.614 15.403-96.269 74.629-111.579 108.956-2.079-.317-3.252-.504-3.252-.504v-12.759s49.423-121.21 151.695-121.21c12.667 0 20.541 6.097 20.541 19.137 0 6.294-2.542 14.909-7.598 25.115-10.983-17.324-30.383-23.591-49.807-18.735z"/><path style="fill:#6eb4f0" d="M108.441 177.461s-57.416 25.518-63.795 51.036 19.138 53.827 19.138 53.827c3.589 21.93 19.138 29.106 19.138 29.106 6.911 17.278 25.518 12.759 25.518 12.759 12.759 6.38 23.507-1.223 31.897-12.759 10.632-14.619 17.892-8.062 26.183-19.671 6.645-9.303 18.474-41.334 18.474-62.466V177.46h-76.553z"/><path style="fill:#78c8ff" d="M172.236 177.461h-63.795s-57.416 25.518-63.795 51.036 19.138 53.827 19.138 53.827 70.174-28.309 108.451-104.863z"/><path style="fill:#6b829b" d="M166.521 291.759c6.645-9.303 18.474-41.334 18.474-62.466V177.46h-12.759c-.797 52.232-31.897 133.969-31.897 133.969 10.632-14.62 17.892-8.063 26.183-19.67z"/><path style="fill:#908490" d="M184.995 155.132a3.189 3.189 0 0 1-3.128-2.567c-6.118-30.595-24.459-49.217-24.645-49.404a3.187 3.187 0 0 1 0-4.51 3.188 3.188 0 0 1 4.51 0c.704.704 15.213 15.437 23.263 40.601 8.05-25.163 22.558-39.896 23.263-40.601a3.18 3.18 0 0 1 4.504 0 3.188 3.188 0 0 1 .007 4.51c-.181.181-18.547 18.908-24.645 49.404a3.189 3.189 0 0 1-3.128 2.567z"/><path style="fill:#6eb4f0" d="M20.542 43.491C7.875 43.491 0 49.589 0 62.628c0 6.38 2.588 15.129 7.782 25.518 19.138 38.277 6.38 82.933 25.518 95.692s138.936-6.38 138.936-6.38v-12.757c0 .001-49.423-121.21-151.694-121.21z"/><path style="fill:#5f9beb" d="M20.542 43.491C7.875 43.491 0 49.589 0 62.628c0 2.301.456 5.007 1.13 7.889 36.594 27.506 105.354 76.26 171.106 106.943v-12.759c-.001.001-49.424-121.21-151.695-121.21z"/><path style="fill:#5a464b" d="M57.405 69.009c61.614 15.403 96.269 74.629 111.579 108.956 2.079-.317 3.252-.504 3.252-.504v-12.759S122.813 43.492 20.542 43.492C7.875 43.491 0 49.589 0 62.628c0 6.294 2.542 14.909 7.598 25.115 10.983-17.324 30.383-23.59 49.807-18.734zm127.59 133.969c-7.047 0-12.759-5.712-12.759-12.759v-25.518c0-7.047 5.712-12.759 12.759-12.759 7.047 0 12.759 5.712 12.759 12.759v25.518c-.001 7.047-5.713 12.759-12.759 12.759z"/><path style="fill:#463246" d="M184.995 164.701a6.38 6.38 0 0 1-6.38-6.38v-6.38a6.38 6.38 0 0 1 12.759 0v6.38a6.38 6.38 0 0 1-6.38 6.38z"/><g/><g/><g/><g/><g/><g/><g/><g/><g/><g/><g/><g/><g/><g/><g/><text x="54" y="270" font-size="29" fill="#ff0000" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
  string svgPartTwo = '</text></svg>';

  mapping(string => address) public domains;
  mapping(string => string) public records;
  mapping (uint => string) public names;

  address payable public owner;

  constructor(string memory _tld) ERC721 ("Innovate Name Service", "INS") payable {
  owner = payable(msg.sender);
  tld = _tld;
  console.log("%s name service deployed", _tld);
}

  function register(string calldata name) public payable {
    if (domains[name] != address(0)) revert AlreadyRegistered();
  if (!valid(name)) revert InvalidName(name);

    uint256 _price = price(name);
    require(msg.value >= _price, "Not enough Matic paid");
    
    // Combine the name passed into the function  with the TLD
    string memory _name = string(abi.encodePacked(name, ".", tld));
    // Create the SVG (image) for the NFT with the name
    string memory finalSvg = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));
    uint256 newRecordId = _tokenIds.current();
    uint256 length = StringUtils.strlen(name);
    string memory strLen = Strings.toString(length);

    console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

    // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
    string memory json = Base64.encode(
        abi.encodePacked(
            '{'
                '"name": "', _name,'", '
                '"description": "A domain on the Funk name service", '
                '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(finalSvg)), '", '
                '"length": "', strLen, '"'
            '}'
        )
    );

      string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

    console.log("\n--------------------------------------------------------");
    console.log("Final tokenURI", finalTokenUri);
    console.log("--------------------------------------------------------\n");

    _safeMint(msg.sender, newRecordId);
    _setTokenURI(newRecordId, finalTokenUri);
    domains[name] = msg.sender;

    names[newRecordId] = name;

    _tokenIds.increment();
  }

  function valid(string calldata name) public pure returns(bool) {
  return StringUtils.strlen(name) >= 3 && StringUtils.strlen(name) <= 10;
}

  // We still need the price, getAddress, setRecord and getRecord functions, they just don't change

  // This function will give us the price of a domain based on length
  function price(string calldata name) public pure returns(uint) {
    uint len = StringUtils.strlen(name);
    require(len > 0);
    if (len == 3) {
      return 5 * 10**17; // 5 MATIC = 5 000 000 000 000 000 000 (18 decimals). We're going with 0.5 Matic cause the faucets don't give a lot
    } else if (len == 4) {
      return 3 * 10**17; // To charge smaller amounts, reduce the decimals. This is 0.3
    } else {
      return 1 * 10**17;
    }
  }

  function getAddress(string calldata name) public view returns (address) {
      return domains[name];
  }

  function setRecord(string calldata name, string calldata record) public {
  if (msg.sender != domains[name]) revert Unauthorized();
  records[name] = record;
}

  function getRecord(string calldata name) public view returns(string memory) {
      return records[name];
  }

  modifier onlyOwner() {
  require(isOwner());
  _;
}

function isOwner() public view returns (bool) {
  return msg.sender == owner;
}

function withdraw() public onlyOwner {
  uint amount = address(this).balance;
  
  (bool success, ) = msg.sender.call{value: amount}("");
  require(success, "Failed to withdraw Matic");
} 

// Add this anywhere in your contract body

function getAllNames() public view returns (string[] memory) {
  console.log("Getting all names from contract");
  string[] memory allNames = new string[](_tokenIds.current());
  for (uint i = 0; i < _tokenIds.current(); i++) {
    allNames[i] = names[i];
    console.log("Name for token %d is %s", i, allNames[i]);
  }

  return allNames;
}


}