const Contest = artifacts.require("Contest");

module.exports = function (deployer) {
  deployer.deploy(Contest);
};
const Voting = artifacts.require("Voting");

module.exports = function (deployer) {
  deployer.deploy(Voting, "Election 2024");
};
