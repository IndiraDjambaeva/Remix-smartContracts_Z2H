// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{

    address public owner;

    bool isStart = false;

    struct Voter{
        string lastVoted;
        uint vote;
    }

    mapping(address => Voter) voters;

    struct Option {
        uint optionNumber;
        string voteOption;   
        uint voteCount; 
    }

    Option[] private options;

    struct VoteSession {
        string question;
        Option[] options;
    }

    VoteSession public currentSession;

    VoteSession[] private voteSessions;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "only owner has rights to do this"
        );
        _;
    }
    modifier Stop(){
        require(isStart==false, "voting needs to stop to see winner or set new voting");
        _;
    }
    modifier Start(){
        require(isStart==true, "voting needs to start to vote for or see data or to stop");
        _;
    }

    event VotingStopped(VoteSession);

    function startVoting() public onlyOwner{
        isStart = true;
    }
    function stopVoting() public Start onlyOwner returns (VoteSession memory) {
        isStart = false;
        voteSessions.push(currentSession);
        emit VotingStopped(currentSession);
        return currentSession;
    }

    constructor(){
        owner = msg.sender;
    }

    function setVoteSession(string memory _question, string[] memory _options) public Stop onlyOwner {
        currentSession.question = _question;
        if (currentSession.options.length != 0) {
            for(uint i = 0; i <= currentSession.options.length; i++){
                currentSession.options.pop();
            }
        }
        for(uint i = 0; i < _options.length; i++){
            currentSession.options.push(Option({
                optionNumber: i + 1,
                voteOption: _options[i],
                voteCount:0
            }));
        }

    }

    function getCurrentSession() public view Start returns (VoteSession memory) {
        return currentSession;
    }

    function voteFor(uint optionNumber) public Start {
        require(isStart==true, "voting must be started to vote");
        Voter storage sender = voters[msg.sender]; 
        bytes memory lastVote = bytes(sender.lastVoted);
        bytes memory currentVote = bytes(currentSession.question);
        require(lastVote.length != currentVote.length, "Already voted."); 
        require(optionNumber > 0 && optionNumber <= currentSession.options.length, "Wrong number!" );
        sender.lastVoted = currentSession.question;
        sender.vote = optionNumber;
        currentSession.options[optionNumber - 1].voteCount++;
    }

    function getWinner() public Stop view returns (Option memory winnerOption){
        uint largest = 0;
        for(uint i = 0; i < currentSession.options.length; i++){
            if (currentSession.options[i].voteCount > largest){
                largest = currentSession.options[i].voteCount;
                winnerOption = currentSession.options[i];
            }
        }
        return winnerOption;
    }

    function getAllVoteSessions() public view returns (VoteSession[] memory) {
        return voteSessions;
    }

    function getVoteSession(uint index) public view returns (VoteSession memory) {
        return voteSessions[index];
    }
}