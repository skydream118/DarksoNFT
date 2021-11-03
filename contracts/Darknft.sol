// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Darknft_factory.sol";

interface IBEP20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DARKNFT is DARKNFT_Factory, ERC721Enumerable, Ownable  {
    //using Strings for uint256;

    string private _baseTokenURI;
    uint256 private _limit_pack = 20000;
    uint256 private _saled_pack;
    uint256 private _price_bnb = 0.1 ether;
    uint256 private _price_darkso = 2000*10**6;
    uint256 private _training_fee = 0.05 ether;
    

    IBEP20 private DARKSOToken;

    constructor(string memory baseURI) ERC721("Hero and disciple", "COOL") {
        setBaseURI(baseURI);
        dark_tokens.push(TokenRecord("Nox", 1, 3, 4, 140, 178, uint32(block.timestamp)));
        dark_tokens.push(TokenRecord("Nox", 1, 3, 4, 140, 177, uint32(block.timestamp)));
        
        _safeMint(msg.sender, 0);//token ID ???????????? 0..100??

        _safeMint(msg.sender, 1);
        _saled_pack = 2;

        address darkso = 0x6407E501a017eCF9Ea94232876cD08E7CFF5A0aE;


        DARKSOToken = IBEP20(darkso);

    }

    function mint_pack_withBnb() public payable {

        require(
            _saled_pack + 1 < _limit_pack, // keeping the total supply of initial pack
            "Exceeds maximum pack" // less than 20,000
        );
        // msg.value = how many eth you send to this contract's function
        // proper amount of eth have been sent or not
        require(msg.value >= _price_bnb,"price incorrect");

        uint256 tokenId = totalSupply();
        
        require( _MintDARKToken(false) == true, "mint NFT error");
        _safeMint(msg.sender, tokenId);
        
        _saled_pack = _saled_pack + 1;
    }

    function mint_pack_withToken() public {
        require(
            _saled_pack + 1 < _limit_pack, // keeping the total supply of initial pack
            "Exceeds maximum initial pack" // less than 20,000
        );
        
        // proper amount of eth have been sent or not
        require(
            DARKSOToken.balanceOf(msg.sender) >= _price_darkso,
            "pack price error"
        );
        DARKSOToken.transfer(address(this),_price_darkso);

        uint256 tokenId = totalSupply();

        require( _MintDARKToken(false) == true, "mint NFT error");

        _safeMint(msg.sender, tokenId);
        _saled_pack = _saled_pack + 1;
    }
    function getBalance() public view returns(uint256){

        return DARKSOToken.balanceOf(msg.sender);
    }

    function TrainingDARK(uint tokenID_1, uint tokenID_2) public payable{

        require(msg.sender != address(0), "mint to the zero address");

        require(msg.value >= _training_fee, "has no enough training fee");

        require(ownerOf(tokenID_1) == msg.sender, "token owner fail");     
        require(ownerOf(tokenID_2) == msg.sender, "token owner fail");        
       
        require(dark_tokens[tokenID_1].training >= 1, "training count is limited.");
        require(dark_tokens[tokenID_2].training >= 1, "training count is limited.");

        require(dark_tokens[tokenID_1].readyTime < block.timestamp, "available time error");

        require(dark_tokens[tokenID_2].readyTime < block.timestamp, "available time error");

        uint256 tokenId = totalSupply();

        require( _MintDARKToken(true) == true, "mint NFT error");

        _safeMint(msg.sender, tokenId);
        
        dark_tokens[tokenID_1].training = dark_tokens[tokenID_1].training - 1;
        dark_tokens[tokenID_2].training = dark_tokens[tokenID_2].training - 1;

    }

    function getTokenData(uint tokenID)public view returns(string memory, uint8, uint8, uint8, uint32, uint32, uint32){
        require(msg.sender != address(0), "mint to the zero address");
        
        require(ownerOf(tokenID) == msg.sender, "token owner fail");

        TokenRecord memory dark = dark_tokens[tokenID];
        return (dark.name,dark.token_type,dark.rarity, dark.training, dark.strength, dark.defense, dark.readyTime);
    }

    
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function restart_pack(uint256 _pack_amount) public onlyOwner{
        _limit_pack = _pack_amount;
        _saled_pack = 0; 
    }
    function get_pack_info() public view returns (uint256, uint256) {
        return (_limit_pack, _saled_pack);
    }

    function withdrawNative(address payable recipient) external onlyOwner {
    
        recipient.transfer(address(this).balance);                
    }
    function get_NativeAmount() public view onlyOwner returns (uint256){
        return address(this).balance;
    } 

    function set_darkso_address(address darkso) external onlyOwner returns(bool){
        DARKSOToken = IBEP20(darkso);        
        return true;
    }

    function withdrawToken(address recipient) external onlyOwner {
        uint amount = DARKSOToken.balanceOf(address(this));
        require( DARKSOToken.approve((recipient), amount) == true, "withdrow approve error");
        DARKSOToken.transferFrom(address(this), recipient, amount);
    }

}
