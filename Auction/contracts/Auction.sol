//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/// @title Auction contract 
/// @author Oluwatosin Serah Ajao

interface IERC721 {
    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function transferFrom(
        address,
        address,
        uint
    ) external;
}

contract Auction {
    //My auction project's concept is to put an NFT up for bid, 
    //with the winning bidder being the one who offers the highest price

    //events
    event Aunction(address caller, uint amountBidded);
    event EndAunction(address indexed bidder, uint amount);
    event withdrawBid(address bidder, uint bidAmount);

    address payable owner;
    //address of the owner of the NFT declared as payable to be able to recive the highest bidding price in ether
    IERC721 immutable nftAddr; //address of the NFT
    uint immutable tokenID; 
    uint deadline = block.timestamp + 4 minutes; //Auction duration
    uint public highestBid;//highest ether bidded
    address public highestBidder; //address of the highest bidder
    bool started;
    bool ended;

    struct bidder{
        uint amountTobid;
        bool bidded;
    }

    address[] biddersAddresses;
    mapping(address => bidder) public biddersBalance;
   
    //2000000000000000000

     modifier onlyOwner(){
        require(owner == msg.sender, "Not owner");
        _;
    }

    modifier bidDuration() {
        require(block.timestamp <= deadline, "Time has passed");
        _;
    }

    constructor(IERC721 _nftAddr, uint _tokenID, uint _startingPrice){
        owner = payable(msg.sender);
        nftAddr = _nftAddr;
        tokenID = _tokenID;
        highestBid = _startingPrice;
    }

    //custom errors optimizes gas
    error auctionStarted();
    error auctionEnded();

    //function to start aunction, owner should start this function
    function startAuction() external onlyOwner{
        if(started == true){
           revert auctionStarted();
        }
     
        started = true;
    }

    //function to bid NFT, anyone can bid but owner can't bid
    function placeBid() external payable bidDuration {
        bidder storage b = biddersBalance[msg.sender];
        require(!b.bidded, "You have already bidded" );
        require(msg.value > highestBid, "Bid more");
        require(msg.sender != owner, "Owner can't bid");

        if(msg.sender != address(0)){
            b.amountTobid += msg.value;
        }
        biddersAddresses.push(msg.sender);

        highestBid = b.amountTobid;
        highestBidder = msg.sender;
        
        b.bidded = true;
        emit Aunction(msg.sender, msg.value);

    }
    //function to withdraw, ether to be transferred to the bidder that didn't win
    function withdraw() external{
        require(ended, "We never ready!");
        require(msg.sender != address(0), "Input a valid address");
        require(biddersBalance[msg.sender].amountTobid > 0, "You didn't place a bid");
         uint amount = biddersBalance[msg.sender].amountTobid;
        //require (amount > 0, "You don't have any money to withdraw");
         biddersBalance[msg.sender].amountTobid = 0; //to avoid reentrancy

         payable(msg.sender).transfer(amount);
         /*for(uint i = 0; i < biddersAddresses.length; i++){
            if(msg.sender == biddersAddresses[i]){
                 payable(msg.sender).transfer(amount);
            }else{
                revert("Not among the bidders");
            }
         }**/

         emit withdrawBid(msg.sender, amount);

    }

    //function to end aunction, NFT should be sent to the highest bidder here
    function endAunction() external onlyOwner{

           if(ended == true){
            revert auctionEnded();
        }

       // require(ended == false, "Auction already ended!");

        if(highestBidder != address(0)){
            nftAddr.safeTransferFrom(address(this), highestBidder, tokenID);
            payable(owner).transfer(highestBid);
        }else{
            nftAddr.safeTransferFrom(address(this), owner, tokenID);
        }
        ended = true;

        emit EndAunction(highestBidder, highestBid);
    }

    //function to transfer ether 
    /*function transferEther() external payable{
        require(msg.sender != address(0), "Input a valid address");
        payable(msg.sender).transfer(address(this).balance);
    }*/

    //function to get contract balance
    function getContractBalance() public view returns(uint bal){
        bal = address(this).balance;
    }

    //function to return bidders addresses
    function showBiddersAddr() public view returns(address[] memory){
        return biddersAddresses;
    }

    receive() external payable{}
}