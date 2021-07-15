// const Migrations = artifacts.require("Migrations");

// module.exports = function (deployer) {
//   deployer.deploy(Migrations);
// };

const datafeed = artifacts.require("Datafeed")

module.exports = (deployer) => {
  deployer.deploy(datafeed)
}