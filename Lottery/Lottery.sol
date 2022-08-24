//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Lottery{
    address public owner; //address of lottery owner
    
    address[] public participants; //array of lottery participants addresses
    uint deadline = block.timestamp + 600 seconds;

    address payable lotteryWinner; //winner's address
    event Participants(address participant, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier access() {
        require(owner == msg.sender, "Not owner");
        _;
    }

    //function to participate in the lottery
    function participate(address participant) public payable{
        require(block.timestamp <= deadline, "Time not reached");
        require(msg.value > 0, "You need ether to participate");
        require(msg.value >= 4, "No sufficient fund");
        //require to play only once
        participants.push(participant);
        emit Participants(participant, msg.value);
    }

    //function to get a participant randomly to win the lottery
    function random() private view returns(uint rand) {
        rand = (uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants))) % participants.length) + 1;
    }

    //function to pick winner among the participants
    function pickWinner() public view access returns(address win){
        require(block.timestamp <= deadline, "Time gone");
        require(participants.length >= 4, "Participants not complete");
        uint randNum = random() ; //to the random number
        win = participants[randNum];
    }

    //function to calculate owner's profit
    function calcProfit() private view returns(uint percentage){
        percentage = (address(this).balance * 10) /100;
    }

    //function to transfer ether to winner 
    // function transferEther(address participant) public payable{
    function transferEther() public payable{
        uint amt = showLotteryBalance() - calcProfit();
        //uint amt = (address(this).balance * 90) / 100;
        address winner = pickWinner();
        payable(winner).transfer(amt);
        // for(uint i; i<participants.length; i++){
        //     if(participant == participants[i]){
                  
        //     }else{
        //         revert("Not a winner");
        //     }
        // }
    }

    //function to show the contract balance
    function showLotteryBalance() public view returns(uint bal){
        bal = address(this).balance;
    }

    //function for lottery owner to withdraw profit
    function withdrawProfit() external access {
        require(block.timestamp <= deadline, "Time gone");
        uint profit = calcProfit();
        payable(owner).transfer(profit);
    }

    //function to get the number of participant in the lottery
    function getLotteryParticipantsNo() public view returns(uint len){
        len = participants.length;
    }

    //function to get all partcipant addresses
    function getParticipantAddrs() public view returns(address[] memory){
        return participants;
    }

    receive() external payable{}

    fallback() external payable{}
}