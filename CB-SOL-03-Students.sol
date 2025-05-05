// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract ConquerStudents {

    struct Students
    {
        string name;    //name
        string surname; //surname
        uint8 age;      //age
        bool exist;     //check
    }

    uint32 numStudents;                     //total number of students enrolled
    mapping (address => Students) students; //list in which students are registered
    address [] studentAddress;              //student address
    Students [] allStudents;                //array that contain the registered students

    function register_student (string memory _name, string memory _surname, uint8 _age) public
    {
        if(!students[msg.sender].exist){

            studentAddress.push(msg.sender);
            students[msg.sender] = Students (_name, _surname, _age, true);
            allStudents.push(students[msg.sender]) ;
            numStudents++;
        }
    }


    function getStudentByAddress (address _dir) public view returns (Students memory) 
    {
        return students[_dir];
    }

    function getStudentById (uint8 _id) public view returns (Students memory) 
    {
        return (students[studentAddress[_id]]);
    }

    function getAllStudents() public view returns (Students[] memory)
    {
        return allStudents;
    }

}