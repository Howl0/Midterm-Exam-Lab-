// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

contract GradeContract {
address public owner;

enum GradeStatus { Pending, Pass, Fail }

struct Student {
string name;
uint256 prelimGrade;
uint256 midtermGrade;
uint256 finalGrade;
uint256 overallGrade;
GradeStatus status;
}

mapping(address => Student) public students;

event GradeComputed(string studentName, uint256 overallGrade, GradeStatus gradeStatus);

modifier onlyOwner() {
require(msg.sender == owner, "Only the owner can call this function");
_;
}

modifier validGrade(uint256 grade) {
require(grade >= 0 && grade <= 100, "Invalid grade. Must be between 0 and 100");
_;
}

constructor() {
owner = msg.sender;
}

function setPrelimGrade(uint256 grade) external onlyOwner validGrade(grade) {
students[msg.sender].prelimGrade = grade;
}

function setMidtermGrade(uint256 grade) external onlyOwner validGrade(grade) {
students[msg.sender].midtermGrade = grade;
}

function setFinalGrade(uint256 grade) external onlyOwner validGrade(grade) {
students[msg.sender].finalGrade = grade;
}

function setName(string memory studentName) external {
students[msg.sender].name = studentName;
}

function calculateGrade() external onlyOwner {
Student storage student = students[msg.sender];
require(student.prelimGrade != 0 && student.midtermGrade != 0 && student.finalGrade != 0, "Grades not set");

student.overallGrade = (student.prelimGrade + student.midtermGrade + student.finalGrade) / 3;

if (student.overallGrade >= 50) {
student.status = GradeStatus.Pass;
} else {
student.status = GradeStatus.Fail;
}

emit GradeComputed(student.name, student.overallGrade, student.status);
}

function prelimGrade() external view onlyOwner returns (uint256) {
return students[msg.sender].prelimGrade;
}

function midtermGrade() external view onlyOwner returns (uint256) {
return students[msg.sender].midtermGrade;
}

function finalGrade() external view onlyOwner returns (uint256) {
return students[msg.sender].finalGrade;
}

function gradeStatus() external view onlyOwner returns (uint256) {
return students[msg.sender].overallGrade;
}

function name() external view onlyOwner returns (string memory) {
return students[msg.sender].name;
}
}