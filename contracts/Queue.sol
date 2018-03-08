pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size = 5;
	uint timeLimit = 10 minutes;

	/* Add events */
	event Timeout(
        address addr,
		uint time
    );

	/* Add constructor */
	struct Queue {
        uint[] data;
		uint[] timeStamps;
		bool[] purchased;
        uint front;
        uint back;
    }

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		return back - front;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		return front == back;
	}
	
	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		if (front == back) {
			return;
		}
		return data[front];
	}
	
	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		for (uint i = front; i < back; i++) {
			if (data[i] == msg.sender) {
				return i - front + 1;
			}
		}
	}
	
	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		// YOUR CODE HERE
		if (now > timeStamps[front] + timeLimit) {
			dequeue();
		}
	}
	
	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		if (now > timeStamps[front] + timeLimit || purchased[front] == true) {
			front += 1;
			Timeout(data[front], now - timeStamps[front]);
		}
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		if (back < front + size) {
			back += 1;
			data[back] = addr;
			timeStamps[back] = now;
		}
	}
}
