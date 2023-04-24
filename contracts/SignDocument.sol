// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SignDocument is ERC721, Ownable{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("BnbVerseNft", "BVN") {
        contractOwner=msg.sender;
    }

    address public contractOwner;
    mapping(address=>bool) public isOwner;
    address[] public signers;

    struct Proposal{
        string name;
        string desc;
        uint timestamp;
        mapping(address=>bool) signer;
        uint signersCount;
    }

    mapping(string => Proposal) public proposals;

    modifier onlyContractOwner(){
        require(msg.sender==contractOwner,"not a contract owner!");
        _;
    }

    modifier onlyOwners(){
        require(isOwner[msg.sender] ,"not an owners!");
        _;
    }

    function addOwners(address _owner) public onlyContractOwner{
        require(_owner !=address(0) || isOwner[_owner],"error!");
        signers.push(_owner);
        isOwner[_owner]=true;
    }

    function makeProposal(string memory _name, string memory _desc) public onlyContractOwner{
        require(proposals[_name].timestamp==0, "this proposal has already been created");
        Proposal storage thisProposal = proposals[_name];
        thisProposal.name=_name;
        thisProposal.desc=_desc;
        thisProposal.timestamp=block.timestamp;
    }

    function signProposal(string memory _name) public onlyOwners{
        Proposal storage thisProposal = proposals[_name];
        require(!thisProposal.signer[msg.sender], "already signed!");
        thisProposal.signer[msg.sender]=true;
        thisProposal.signersCount++;

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }
}