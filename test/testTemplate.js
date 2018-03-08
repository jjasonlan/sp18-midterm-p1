'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

contract('testTemplate', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {};
	let x, y, z;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		token = Crowdsale.new(100, 1.0, 1000);
	});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Basic Tests', function() {
		it("erc20 tests", async function() {
			Assert.equal(token.totalSupply, 100);
		});

	});

	describe('Your string here', function() {
		it("sending money", async function() {
			let balance = await Crowdsale.getBalance.call
		});
	});
});
