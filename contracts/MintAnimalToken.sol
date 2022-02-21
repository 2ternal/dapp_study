// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0; //컴파일러 버전

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
//ERC721 : NFT정의 프로토콜/인터페이스

contract MintAnimalToken is ERC721Enumerable {
    constructor() ERC721("h662Animals", "HAS") {}   //name, symbol

    function mintAnimalToken() public {
        uint256 animalTokenId = totalSupply() + 1;  //totalSupply(): 발행된 nft 개수

        _mint(msg.sender, animalTokenId);           //발행
    }
} 