// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract VotingSystem is ERC20, Ownable{


    struct Voting {
        string name;
        string[] options;
        mapping(string => bool) isOption;
        mapping(address => bool) voted;
        mapping(string=>uint) votesCount;
        address owner;
        uint timestamp;
        uint limitVotes;
        uint countLimit;
        bool ended;
    }


    string[] internal allVotings;
    mapping(string=>Voting) public votings;


    event Result(string[] _result);

    constructor() ERC20("VotingToken", "VT") {}


    function sendTokenForVoting(address _to) public onlyOwner {
         _mint(_to, 1);
    }


    function makeVoting(string memory _name, string[] memory _options) public {
       
        require(votings[_name].timestamp==0, "this voting has already been created");
        allVotings.push(_name);
        Voting storage newVoting = votings[_name];
        newVoting.name=_name;
        newVoting.owner=msg.sender;
        newVoting.timestamp=block.timestamp;
        for(uint i=0;i<_options.length;i++){
            newVoting.options.push(_options[i]);
            newVoting.isOption[_options[i]]=true;
        }
       
    }


    function stopVoting(string memory _name) public onlyOwner{
        Voting storage newVoting = votings[_name];
        require(newVoting.owner==msg.sender, "not your voting");
        newVoting.ended=true;
    }


    function makeLimit(string memory _name, uint _limit) public{
        Voting storage thisVoting = votings[_name];
        require(thisVoting.owner==msg.sender,"not your voting");
        require(!thisVoting.ended, "voting ended");
        thisVoting.limitVotes=_limit;
    }


    function makeChoice(string memory _name, string memory _option) public{
        require(balanceOf(msg.sender) > 0, "you have not Voting token");
        Voting storage thisVoting = votings[_name];
       
        require(thisVoting.timestamp!=0, "voting does not exist");
        require(thisVoting.isOption[_option],"option does not exist");
        require(!thisVoting.voted[msg.sender],"have you already voted");
        require(!thisVoting.ended, "voting ended") ;
        thisVoting.countLimit++;
        thisVoting.voted[msg.sender] = true;
        thisVoting.votesCount[_option]++;
    }


    function deleteToken(address _to) public onlyOwner{
        _burn(_to,1);
    }


    function allSessions() public view returns(string[] memory){
        return allVotings;
    }


    function allOption(string memory _name) public view returns(string[] memory){
        return votings[_name]. options;
    }


    function votingsResult(string memory _name) public returns(string[] memory){
        Voting storage thisVoting = votings[_name];
        require(thisVoting.countLimit>=thisVoting.limitVotes,"sorry this voting invalid");


        uint optionsCount = thisVoting.options.length;
        uint winnersCount;
        uint maximumVotes;
        string[] memory localResult = new string[](optionsCount);


        for(uint i = 0; i < optionsCount; i++) {
            string memory nextOption = thisVoting.options[i];
            if(thisVoting.votesCount[nextOption] == maximumVotes){
                winnersCount += 1;
                localResult[winnersCount - 1] = nextOption;
            }
            if(thisVoting.votesCount[nextOption] > maximumVotes) {
                maximumVotes = thisVoting.votesCount[nextOption];
                winnersCount = 1;
                localResult[0] = nextOption;
            }
        }


        string[] memory _result = new string[](winnersCount);


        for(uint i = 0; i < winnersCount; i++) {
            _result[i] = localResult[i];
        }
        emit Result(_result);
        return _result;
    }
}