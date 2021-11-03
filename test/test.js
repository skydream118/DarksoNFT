const DARKNFT = artifacts.require("DARKNFT");
const { assert } = require('chai');
const utils = require('./utils');
var expect = require('chai').expect;
const truffleAssert = require('truffle-assertions');
const time = require("./time");
contract("DARKNFT", async accounts => {
	let [bob, alice] = accounts;
    let contractInstance;
    beforeEach(async () => {
        contractInstance = await DARKNFT.new("example.com");
    });

    // it("confirm token 1,2 information after construct", async() => {
    //  	let token_1 = await contractInstance.getTokenData(0);
    // 	console.log(token_1);
    // 	token_1 = await contractInstance.getTokenData(1);
    // 	console.log(token_1);
    // 	token_1 = await contractInstance.totalSupply();
    // 	console.log(token_1);
    // });

	it("should be able to mint a new pack", async () => {

	    const result = await contractInstance.mint_pack_withBnb( {from: alice, value:0.1*10**18});
	    expect(result.receipt.status).to.equal(true);
	    let tokenID = result.logs[0].args.tokenId;

	    console.log(result.logs[0].args.tokenId);
	    let owner = await contractInstance.ownerOf(tokenID);
	    expect(owner.toString()).to.equal(alice);
	});

	it("should not mint pack smaller than default price", async() => {
		await utils.shouldThrow(await contractInstance.mint_pack_withBnb({from: alice, value:0.01*10**18}));
	});


	it("should mint pack with darkso token", async() => {

		// let bal = await contractInstance.getBalance({from:alice});
		// console.log("alice balance : " + alice.toString() + " / " + bal.toString());

		bal = await contractInstance.getBalance({from:bob});
		console.log("alice balance : " + bob.toString() + " / " + bal.toString());


	    const result = await contractInstance.mint_pack_withToken({from: bob});
	    expect(result.receipt.status).to.equal(true);
	    let tokenID = result.logs[0].args.tokenId;

	    let token = await contractInstance.ownerOf(tokenID);
	    expect(token.toString()).to.equal(bob);
	    console.log("---- token information ------" + tokenID.toString());
	    console.log(result.logs[0].args);
	   	
	});

	it("should be able to training new", async () => {

	    const result = await contractInstance.TrainingDARK(0, 1, {from: accounts[0], value:0.05*10**18});
	    expect(result.receipt.status).to.equal(true);
	    let tokenID = result.logs[0].args.tokenId;

	    let owner = await contractInstance.ownerOf(tokenID);
	    
	    expect(owner.toString()).to.equal(accounts[0]);
	    
	    console.log("token information---------------- 2");
	    
	    console.log(await contractInstance.getTokenData(tokenID));
	});
	it("should not training smaller than default price", async() => {
		await utils.shouldThrow(await contractInstance.TrainingDARK(0,1,{from: alice, value:0.002*10**18}));
	});
	it("should not training with ongoing training token", async() => {
		const result = await contractInstance.TrainingDARK(0, 1, {value:0.05*10**18});
	    expect(result.receipt.status).to.equal(true);
	    let tokenID = result.logs[0].args.tokenId;

	    console.log("token information");
	    
	    console.log(await contractInstance.getTokenData(tokenID));

	    await utils.shouldThrow(await contractInstance.TrainingDARK(1,tokenID,{value:0.05*10**18}));
	});

	//Get address balance

})
