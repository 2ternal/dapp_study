// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "MintAnimalToken.sol";

contract SaleAnimalToken {
    MintAnimalToken public mintAnimalTokenAddress;

    constructor (address _mintAnimalTokenAddress) {
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenAddress);
    }

    mapping(uint256 => uint256) public animalTokenPrices;

    uint256[] public onSaleAnimalTokenArray;        //판매중인 토큰의 배열

    function setForSaleAnimalToken(uint256 _animalTokenId, uint256 _price) public {     //판매등록
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);

        require(animalTokenOwner == msg.sender, "Caller is not animal token owner.");   //require(조건T/F, 에러문)
        require(_price > 0, "Price is zero or lower.");
        require(animalTokenPrices[_animalTokenId] == 0, "This animal token is already on sale.");
        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner, address(this)), "Animal token owner did not approve token.");
        //address(this): SaleAnimalToken의 smart contract
        //isApprovedForAll: 승인 여부

        animalTokenPrices[_animalTokenId] = _price;

        onSaleAnimalTokenArray.push(_animalTokenId);
    }

    function purchaseAnimalToken(uint256 _animalTokenId) public payable {
        uint256 price = animalTokenPrices[_animalTokenId];
        address animalTokenOnwer = mintAnimalTokenAddress.ownerOf(_animalTokenId);

        require(price > 0, "Animal token not sale.");
        require(price <= msg.value, "Caller sent lower than price.");               //msg.value 보내는 matic의 양
        require(animalTokenOnwer != msg.sender, "Caller is animal token owner.");   //msg.sender 보내는 사람

        payable(animalTokenOnwer).transfer(msg.value);                              //주인에게 돈을 보냄
        mintAnimalTokenAddress.safeTransferFrom(animalTokenOnwer, msg.sender, _animalTokenId);  //보내는사람, 받는사람, 보내는것

        animalTokenPrices[_animalTokenId] = 0;                                      

        for(uint256 i = 0; i < onSaleAnimalTokenArray.length; i++) {                //mapping에서 제거
            if(animalTokenPrices[onSaleAnimalTokenArray[i]] == 0) {                 //팔렸으면
                onSaleAnimalTokenArray[i] = onSaleAnimalTokenArray[onSaleAnimalTokenArray.length - 1];
                onSaleAnimalTokenArray.pop();
            }
        }
    }

    function getOnSaleAnimalTokenArrayLength() view public returns (uint256) {      //판매중인 토큰 배열의 길이
        return onSaleAnimalTokenArray.length;
    }
} 