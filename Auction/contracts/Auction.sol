//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


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
    event EndAunction(address bidder, uint amount);

    address payable owner;
    //address of the owner of the NFT declared as payable to be able to recive the highest bidding price in ether
    IERC721 nftAddr; //address of the NFT
    address public winnerAddress; 
    uint tokenID; 
    uint deadline; //Auction duration
   // uint public highestBid;//highest ether bidded
    uint public currentBiddingPrice;
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
        require(block.timestamp >= deadline, "Time has passed");
        _;
    }

    constructor(IERC721 _nftAddr, uint _tokenID, uint _startingPrice){
        owner = payable(msg.sender);
        nftAddr = _nftAddr;
        tokenID = _tokenID;
        currentBiddingPrice = _startingPrice;
    }

    //custom errors optimizes gas
    error auctionStarted();
    error auctionEnded();

    //function to start aunction, owner should start this function
    function startAuction() external onlyOwner{
        if(started == true){
           revert auctionStarted();
        }
        deadline = block.timestamp + 60 seconds;
        started = true;
    }

    //function to bid NFT, anyone can bid but owner can't bid
    function placeBid(uint _amountTobid) external payable bidDuration{
        require(msg.value > currentBiddingPrice, "Bid more");
        require(msg.sender != owner, "Owner can't bid");
        bidder storage b = biddersBalance[msg.sender];
        b.amountTobid = _amountTobid;
        if(msg.sender != address(0)){
            _amountTobid += msg.value;
           // biddersBalance[msg.sender] += msg.value;
        }
        biddersAddresses.push(msg.sender);
        
        b.bidded = true;
        emit Aunction(msg.sender, _amountTobid);

    }
    //function to withdraw, ether to be transferred to the owner 
    function withdraw() internal onlyOwner{
         
    }

    //function to end aunction, NFT should be sent to the highest bidder here
    function endAunction() external onlyOwner{
        if(ended == true){
            revert auctionEnded();
        }

        ended = true;
        if(highestBidder != address(0)){
            nftAddr.safeTransferFrom(address(this), highestBidder, tokenID);
            owner.transfer(currentBiddingPrice);
        }else{
            nftAddr.safeTransferFrom(address(this), owner, tokenID);
        }

        emit EndAunction(highestBidder, currentBiddingPrice);
    }

    //function to transfer ether to the contract
    function transferEther() external payable{
        require(msg.sender != address(0), "Input a valid address");
        payable(msg.sender).transfer(address(this).balance);
    }

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