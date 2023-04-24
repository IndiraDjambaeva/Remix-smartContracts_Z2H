// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Note {
    //Note -> user can read note and read
    string note;
    //Access modifier
    //private, internal, external, public
    //Переменная состояния с public => создается getter
    event NoteAdded(address noteSender, string addedNote);

    // Для всех непримитивных типов локальных переменных -> нужен memory
    // Для примитивных типов integer, boolean, address -> memory не нужен
    function setNote(string memory _note) public {
        note = _note;
        emit NoteAdded(msg.sender, _note);
        // msg.sender => юзер или смарт-контракт, который вызызвает данную функцию
    }

    //state mutability in function => pure, view (,Бесплатные), non payable (default), payable

    function getNote() public view returns (string memory){
        return note;
    }

}
