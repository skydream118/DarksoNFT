// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DARKNFT_Factory{
    //using Strings for uint256;

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
    //event NewDARKToken(uint tokenID, string name, uint token_type, uint tarity, uint training, uint strength,uint defense); 

    function _generateRandom(uint8 dnaModulus) internal view returns (uint8) {
        
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp)));
        return uint8(rand % dnaModulus);
    }

    function _MintDARKToken(bool isTraining) internal returns(bool){
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
                randStrength = randStrength + 100;
                randDefense = _generateRandom(21);
                randDefense = randDefense + 100;
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
        return true;
        //require(_tokenID == id, "tokenCount error");
        // if(isTraining){

        //     emit TrainingDARKToken(_tokenID);
        // }else{
        //     emit NewDARKToken(_tokenID, name, randType, randRarity, training, randStrength, randDefense);
        // }    
    }

}
