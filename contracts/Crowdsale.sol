pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {

  address public owner;
  uint public totalTokens;
  uint public tokensSold;
  uint public exchangeRate;
  uint public startTime;
  uint public endTime;
  uint private funds;

  Queue public queue;
  Token public token;

    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }
    modifier saleOpen {
        require(now > startTime && now < endTime);
        _;
    }

  event TokenPurchase(address buyer);
  event TokenRefund(address buyer);

    function Crowdsale(uint _initalTokens, uint _exchangeRate, uint _queueTime) public payable {
        owner = msg.sender;
        startTime = _queueTime;
        endTime = startTime + 30 days;
        totalTokens = _initalTokens;
        exchangeRate = _exchangeRate;
        tokensSold = 0;
        queue = new Queue();
        token = new Token(_initialTokens);
        funds = 0;
    }

    function mint(uint amount) ownerOnly() returns (bool) {
        return token.addTokens(amount);
    }

    function burn(uint amount) ownerOnly() returns (bool) {
        if (totalTokens >= amount) {
            return token.burn(amount);
        }
        return false;
    }

    function receiveFunds() ownerOnly() {
        if (now > endTime) {
            owner.transfer(funds);
        }
    }

    function buy(uint amount) public payable saleOpen() {
        require (queue.getFirst() == msg.sender && !queue.empty());
        if (amount <= msg.value * exchangeRate) {
            tokensSold += amount;
            funds += msg.value;

            TokenPurchase(msg.sender);
            queue.dequeue();
        }
    }

    function refund(uint amount) public saleOpen() {
        tokensSold -= amount;
        msg.sender.transfer(amount * exchangeRate);
        funds -= amount * exchangeRate;

        TokenRefund(msg.sender);
    }

    function joinQueue() public saleOpen() returns (bool){
        if (queue.qsize() < 5) {
            queue.enqueue(msg.sender);
            return true;
        }
        return false;
    }

    function checkTime() public saleOpen() {
        queue.checkTime();
    }

    function checkPlace() public saleOpen() returns (uint) {
        return queue.checkPlace();
    }

    function() public payable {
        revert();
    }

}
