// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DARKNFT_Factory{
    //using Strings for uint256;

// 2 Characters will be Disciples:
// Name: Aurora and Bert
// Type: Disciple
// Rarity: Common
// Training: No
// Strength: 80 to 100
// Defense: 80 to 100

// 2 Characters will be Rare Heroes:
// Name: Sarah and Kaylan
// Type: Hero
// Rarity: Rare
// Training: 0/2
// Strength: from 120 to 140
// Defense: from 120 to 140

// 2 Characters will be Legendary Heroes:
// Name: Valkyria and Nox
// Type: Hero
// Rarity: Legendary
// Training: 0/4
// Strength: from 140 to 180
// Defense: from 140 to 180



    struct TokenRecord{        
        string name;

        uint8 token_type; //1 : hero, 2 discipline
        
        uint8 rarity; //1: common, 2: Rare, 3: legendary
        
        uint8 training;
        
        uint32 strength;
        
        uint32 defense;

        uint32 readyTime;
    }

    TokenRecord[] public dark_tokens;

    //event TrainingDARKToken(uint tokenId);
    event NewDARKToken(uint tokenID, string name, uint token_type, uint tarity, uint training, uint strength,uint defense,uint startTime); 

    function _generateRandom(uint8 dnaModulus) internal view returns (uint8) {
        
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp)));
        return uint8(rand % dnaModulus);
    }

    function _Mint_withStatic(string memory name) internal returns(uint){
        uint8 token_type;
        uint32 randStrength;
        uint32 randDefense;
        uint8 training;
        uint8 rarity;
        uint8 downTime;

        if(keccak256(bytes(name)) == keccak256(bytes("Aurora")) || keccak256(bytes(name)) == keccak256(bytes("Bert"))){
            token_type = 2;
            rarity = 1;
            randStrength = _generateRandom(21);
            randStrength = randStrength + 80;
            randDefense = _generateRandom(21);
            randDefense = randDefense + 80;
            training = 0;
        }else if(keccak256(bytes(name)) == keccak256(bytes("Sarah")) || keccak256(bytes(name)) == keccak256(bytes("Kaylan"))){
            token_type = 1;
            rarity = 2;
            randStrength = _generateRandom(21);
            randStrength = randStrength + 120;
            randDefense = _generateRandom(21);
            randDefense = randDefense + 120;
            training = 2;
        }else if(keccak256(bytes(name)) == keccak256(bytes("Valkyria")) || keccak256(bytes(name)) == keccak256(bytes("Nox"))){
            token_type = 1;
            rarity = 3;
            randStrength = _generateRandom(41);
            randStrength = randStrength + 140;
            randDefense = _generateRandom(41);
            randDefense = randDefense + 140;
            training = 4;
        }
        
        dark_tokens.push(TokenRecord(name, token_type, rarity, training, randStrength, randDefense, uint32(block.timestamp + downTime)));
        
        return dark_tokens.length - 1;
    }


    function _MintDARKToken(bool isTraining) internal returns(uint){
        uint8 randType = uint8(_generateRandom(100));

        uint8 training;
        uint32 randStrength;
        uint32 randDefense;
        uint8 randName;
        uint8 randRarity;
        string memory name;

        uint range = 75;

        uint downTime;
        if(isTraining){
            downTime = 1 days;
            range = 80;
        }

        randName = uint8(_generateRandom(2));

        if(randType >= range){
            if (randType < 95){
                randRarity = 2; //Rare
                if(randName == 1){
                    name = "Sarah";
                }else{
                    name = "Kaylan";
                }
                training = 2;
            }else{
                randRarity = 3; //Legendary
                if(randName == 1){
                    name = "Valkyria";
                }else{
                    name = "Nox";
                }
                training = 4;
            }

            randType = 1; //hero

            if(randRarity == 2){

                randStrength = _generateRandom(21);
                randStrength = randStrength + 120;
                randDefense = _generateRandom(21);
                randDefense = randDefense + 120;
            }else{

                randStrength = _generateRandom(41);
                randStrength = randStrength + 140;
                randDefense = _generateRandom(41);
                randDefense = randDefense + 140;                
            }

        }else{
            randType = 2; //disciple
            randRarity = 1;

            if(randName == 1){
                name = "Aurora";
            }else{
                name = "Bert";
            }

            randStrength = _generateRandom(21);
            randStrength = randStrength + 80;
            randDefense = _generateRandom(21);
            randDefense = randDefense + 80;
        }

        dark_tokens.push(TokenRecord(name, randType, randRarity, training, randStrength, randDefense, uint32(block.timestamp + downTime)));
        
        //require(_tokenID == id, "tokenCount error");
        // if(isTraining){

        //     emit TrainingDARKToken(_tokenID);
        // }else{
        emit NewDARKToken(dark_tokens.length - 1, name, randType, randRarity, training, randStrength, randDefense,uint32(block.timestamp + downTime));
        return dark_tokens.length - 1;
            
    }
}


