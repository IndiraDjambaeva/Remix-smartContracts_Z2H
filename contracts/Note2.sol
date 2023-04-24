// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Note2 {
    
    string note;
    //mappig 
    mapping (address => string) notes;


    event NoteAdded(address noteSender, string addedNote);

    
    function setNote(string memory _note) public {
        notes[msg.sender] = _note;
        //msg => transaction
    
        emit NoteAdded(msg.sender, _note);
        
    }

    function getNote() public view returns (string memory){
        return notes[msg.sender];
    }

    receive() external payable {
        
    }

}