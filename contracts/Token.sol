pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	uint totalSupply;
	mapping (address => uint) balances;
	mapping (address => mapping (address => uint)) allowances;

	function Token(_totalSupply) {
		totalsupply = _totalSupply;
		balances[msg.sender] = _totalSupply;
	}

	function totalSupply() public constant returns (uint) {
		return totalSupply;
	}
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
		return balances[tokenOwner];
	}
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
		return allowances[tokenOwner][spender];
	}
    function transfer(address to, uint tokens) public returns (bool success) {
		require(_to != 0x0);
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[to] + tokens > balanceOf[to]);
        uint previousBalances = balanceOf[msg.sender] + balanceOf[to];
        balanceOf[msg.sender] -= tokens;
        balanceOf[to] += tokens;
        Transfer(msg.sender, to, tokens);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
		return true;
	}
    function approve(address spender, uint tokens) public returns (bool success) {
        allowance[msg.sender][spender] = tokens;
		Approval(spender, tokens);
        return true;
	}
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
		require(tokens <= allowance[from][msg.sender]);
        allowance[from][msg.sender] -= tokens;
		Transfer(from, to, tokens);
        return true;
	}

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
	event Burn(address indexed tokenOwner, uint tokens);
}
