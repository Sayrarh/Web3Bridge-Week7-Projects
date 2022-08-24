//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Voting{
    address admin; 
    uint voteDeadline = block.timestamp + 240 seconds;
    uint candidateCount;
    uint votersCount;

    struct VoteDetails{
        uint voterID;
        string voterName;
        bool voted;
    }
   mapping(address => VoteDetails) _voteDetails;// mapping of voter's ID to their details
   mapping(address => bool) voterAdded; //to return if voter has been added or not
   mapping(address => uint) votes;  //number of votes

    struct CandidatesDetails{
        uint candidateID;
        string candidateName;
        string position;
    }

    address[] candidatesAddresses;

    event Candidate(
        uint indexed candidateID,
        string indexed candidateName,
        string indexed position,
        address candidAddr
    );

    event Result();

    mapping(address => CandidatesDetails) public _candidatesDetails; //mapping of candidate's ID to their details
    CandidatesDetails[] _candidDetails; //array of candidates details
    mapping(address => bool) candidateAdded;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin(){
        require(admin == msg.sender, "Only admin can add candidates and voters");
        _;
    }
    
    function addCandidate(string memory name, uint _candidateID, address addr, string memory _position) public onlyAdmin returns(string memory){
        require(candidateAdded[addr]== false, "Candidate already exist");
        CandidatesDetails storage CD = _candidatesDetails[addr];
        CD.candidateID = _candidateID;
        CD.candidateName = name;
        CD.position = _position;
        candidateCount++;
        candidatesAddresses.push(addr); //push the addr to the array of addresses
        candidateAdded[addr] = true;
        emit Candidate(_candidateID, name, _position, addr);
        return "Candidate Added";
    }

    function addVoters(address addr, uint _voterID, string memory name) public onlyAdmin{
        require(voterAdded[addr] == false, "Voter already exists");
        VoteDetails storage VD = _voteDetails[addr];
        VD.voterID = _voterID;
        VD.voterName = name;
        VD.voted = false;
        votersCount++;
        voterAdded[addr] = true;
    }
    //function to vote
    function vote(address _candidateAddress) external  {
        require(block.timestamp >= voteDeadline, "Time not reached");
        require(voterAdded[msg.sender] == true, "You are not among the voters");
        require(candidateAdded[_candidateAddress] == true, "This address is not a candidate");
        VoteDetails storage VD = _voteDetails[msg.sender];
        require(VD.voted == false, "Already voted");
        votes[_candidateAddress] += 1;

        VD.voted = true; 
    }

    function showResult(address candidAddr) public view returns(uint result){
       result =  votes[candidAddr];
    }

    //function to get all candidates addresses
    function getCandidatesAddr() public view returns(address[] memory){
        return candidatesAddresses;
    }

    //function to get a single candidate details
    function getCandidate(address addr) public view returns(CandidatesDetails memory){
        return (_candidatesDetails[addr]);
    }
 
    //function to return all candidatesdetails
    function getCandidatesDetails() public view returns(CandidatesDetails[] memory CD){
        address[] memory allCandid = candidatesAddresses;
        CD = new CandidatesDetails[](allCandid.length);
        for(uint i = 0; i<allCandid.length; i++){
            CD[i] = _candidatesDetails[allCandid[i]];
        }
    }
    
    

}