// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0; //컴파일러 버전

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
//ERC721 : NFT정의 프로토콜/인터페이스
//컴파일 명령어 : remixd -s . --remix-ide https://remix.ethereum.org
contract MintAnimalToken is ERC721Enumerable {
    constructor() ERC721("h662Animals", "HAS") {}   //name, symbol

    mapping(uint256 => uint256) public animalTypes;

    function mintAnimalToken() public {
        uint256 animalTokenId = totalSupply() + 1;  //totalSupply(): 발행된 nft 개수

        uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, animalTokenId))) % 5 + 1;

        animalTypes[animalTokenId] = animalType;

        _mint(msg.sender, animalTokenId);           //발행
    }
} 