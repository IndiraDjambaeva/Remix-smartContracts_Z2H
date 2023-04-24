// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Note3 {
    
    string note;
    //mappig 
    mapping (address => string) notesMapping;

    //alternative with array

    struct notesStruct{
        address userAddress;
        string userNote;
    }

    notesStruct[] notesArray;
    event NoteAdded(address noteSender, string addedNote);

    //связано с notesArray
    function setNoteWithArray(string memory _note) public {
        notesArray.push(notesStruct(msg.sender, _note));
    }

    function getNoteWithArray() public view returns (string memory){
        
        for (uint256 i = 0; i<notesArray.length; i++) {
            if(notesArray[i].userAddress == msg.sender){
                return notesArray[i].userNote;
            } 
         }   
            return "";
    }            
    

    //связано с notesMapping
    //function setNote(string memory _note) public {
        //notes[msg.sender] = _note;
        //msg => transaction
    
        //emit NoteAdded(msg.sender, _note);
        
    //}

    //function getNote() public view returns (string memory){
     //   return notes[msg.sender];
    //}

   // receive() external payable {
        
    //}

}