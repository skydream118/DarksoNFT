const DARKNFT = artifacts.require("DARKNFT");

module.exports = function (deployer) {
  deployer.deploy(DARKNFT,"https://example.com");
};
