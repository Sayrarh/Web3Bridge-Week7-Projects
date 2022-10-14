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
    //My auction project's concept is to put an NFT up for Auction, 
    //with the winning bidder being the one who offers the highest price

    //events
    event Aunction(address caller, uint amountBidded);
    event Transfer(address highestBidder, uint bidAmount);

    address public owner; //owner of the NFT
    IERC721 immutable nftAddr; //address of the NFT contract
    uint tokenID;
    address[] biddersAddresses; //array of bidders Address
    uint public highestBid;
    address public highestBidder; //address of the current highest Bidder
    uint deadline; //Auction duration
    bool started;
    bool ended;

    struct bidder{
        uint amountTobid;
        bool bidded;
        bool  paid;
    }

    mapping(address => bidder) biddersPrice;

    modifier onlyOwner() {
        require(owner == msg.sender, "Not owner");
        _;
    }

    modifier timer() {
       require(deadline <= block.timestamp, "Time has passed");
        _;
    }

    constructor (IERC721 _nftAddr, uint ID, uint _startingPrice) {
        owner = msg.sender;
        nftAddr = _nftAddr;
        tokenID = ID;
        highestBid = _startingPrice;
    }

    error startedAuction();

    ///@dev A function that allows owner to start the Auction
    function startAuction(uint _setTime) external onlyOwner{
        if(started == true){
           revert ("Auction is in progress");
         }else{
             deadline = block.timestamp + _setTime;
             require(deadline >= block.timestamp, "Auction has ended");
         }
         nftAddr.transferFrom(owner, address(this), tokenID);
        started = true;
    }

    /// @dev A function that allows bidders to place their bid
    function placeBid(uint _amountTobid) external {
        require(started == true, "Auction has not started");
        require(block.timestamp <= deadline, "Time has passed");
        require(msg.sender != owner, "NFT owner can't bid");
        require(_amountTobid > highestBid, "Bid higher");
        bidder storage bd = biddersPrice[msg.sender];
        bd.amountTobid = _amountTobid;
        highestBid = _amountTobid;
       // biddersAddresses.push(msg.sender);
        // for(uint i = 0; i < biddersAddresses.length; i++){
        //     if(msg.sender != biddersAddresses[i]){
        //         biddersAddresses.push(msg.sender);
        //         continue ;
        //     }
        //}
        biddersAddresses.push(msg.sender);

        highestBidder = msg.sender;
        bd.bidded = true;
        emit Aunction(msg.sender, _amountTobid);
    }

    /// @dev function that allows highest bidder to deposit his bid
    function deposit() external payable{
        require(biddersPrice[msg.sender].amountTobid > 0, "You didn't bid");
        require(highestBidder == msg.sender, "You are not the winner");
        require(msg.value == highestBid, "Input the exact higest bid");
        bidder storage bd = biddersPrice[msg.sender];
        highestBid = msg.value;
        bd.paid = true;
        ended = true;
        emit Transfer(highestBidder, msg.value);
    }

    ///@dev function to transfer the NFT to the highest bidder and transfer the higest bid to the owner
    function transfer() external payable{
            require(started == true, "Auction has not started");
            require(ended == true, "Auction is still in progress");
            require(deadline <= block.timestamp, "Not time for withdrawal");
            require(highestBidder == msg.sender || msg.sender == owner , "Only winner or NFT owner");
            bidder memory bd = biddersPrice[msg.sender];
            if(bd.paid == true){
            nftAddr.safeTransferFrom(address(this), highestBidder, tokenID);
            payable(owner).transfer(address(this).balance); //Work on the bal
           }
           else{
           nftAddr.safeTransferFrom(address(this), owner, tokenID);
        }
       
    }
    
     /// @dev function to show current reading time
     function currentTime() public view returns(uint){
         if(deadline == 0){
             return 0;
         }else{
             return deadline - block.timestamp; 
         }
        
     }
    
    /// @dev A function to display bidders bidding price
    function showBidderPrice() external view returns(uint amountBidded){
       bidder memory bd = biddersPrice[msg.sender]; 
       amountBidded = bd.amountTobid ;
    }

     
    /// @dev function to get contract balance
    function getContractBalance() public view returns(uint bal){
        bal = address(this).balance;
    }

    /// @dev Function to display all bidders addresses
    function showAllBidders() external view returns(address[] memory){
        return biddersAddresses;
    }

    receive() external payable{}

    
}