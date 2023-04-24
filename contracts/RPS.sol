// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors {
    enum Move { ROCK, PAPER, SCISSORS }

    struct Game {
        address player;
        uint256 betAmount;
        Move playerMove;
        Move houseMove;
    }

    address public owner;
    mapping(uint256 => Game) public games;
    uint256 public gameIdCounter;

    uint256 private constant MIN_BET = 100000000000000; // 0.0001 tBNB in wei

    event GameResult(address indexed player, uint256 gameId, uint256 betAmount, uint256 payout);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function play(Move playerMove) external payable {
        require(msg.value >= MIN_BET, "Bet amount must be at least 0.0001 tBNB.");
        
        Move houseMove = generateRandomMove();
        uint256 payout = 0;
        gameIdCounter = gameIdCounter + 1;
        
        Game memory newGame = Game({
            player: msg.sender,
            betAmount: msg.value,
            playerMove: playerMove,
            houseMove: houseMove
        });

        games[gameIdCounter] = newGame;

        if ((playerMove == Move.ROCK && houseMove == Move.SCISSORS) || 
            (playerMove == Move.PAPER && houseMove == Move.ROCK) || 
            (playerMove == Move.SCISSORS && houseMove == Move.PAPER)) {
            payout = msg.value * 2;
            payable(msg.sender).transfer(payout);
        }

        emit GameResult(msg.sender, gameIdCounter, msg.value, payout);
    }

    function generateRandomMove() private view returns (Move) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 3;
        return Move(randomNum);
    }

    function withdrawBalance(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Not enough balance to withdraw.");
        payable(owner).transfer(amount);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}