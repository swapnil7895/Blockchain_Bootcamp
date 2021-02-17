pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Auction is Ownable
{
    //state variables

    //player details
    uint playerId;
    string player_name;
    uint player_age;
    string player_type;
    uint player_rating;
    uint base_price;
    uint max_bid_count;
    
    //extra state variables
    bool isActive;
    uint highestBid;
    uint bid_counter;
    address highestBidder;
    address team_owner;

    //mapping n arrays
    mapping(address=>uint) teamOwners;
    address[] teamOwnersArray;


    //constrctor
    constructor
    (       //passing parameters
        string memory _name,
        uint _age,
        string memory _type,
        uint _rating,
        uint _base_price,
        uint _max_bid_count
    )
    {      //assigning passed values
        player_name=_name;
        player_age=_age;
        player_type=_type;
        player_rating=_rating;
        base_price=(_base_price*2 wei);//base price will be (passed base price)*(2 wei).
        max_bid_count=_max_bid_count;
        transferOwnership(tx.origin);//ownership transferred to player.

        
    }


    //functions
    function startAuction()public onlyOwner //starting auction (Only owner can start)
    {
        isActive=true;   
    }
    function doBid() public payable //For bidding (Owner cant bid)
    {
        assert(isActive);
        require(msg.sender!=owner(),"Owner cannot participate in auction");
        require(teamOwners[msg.sender]+msg.value>base_price,"Value is less than base price!! ");
        require(teamOwners[msg.sender]+msg.value>highestBid,"Value is less than highest bid!! ");
        teamOwners[msg.sender]+=msg.value;//assigning highest bid to respective bidder's account.
        teamOwnersArray.push(msg.sender);//adding bidder to bidder's array.
        highestBid=teamOwners[msg.sender];//updating highest bid value.
        highestBidder=msg.sender;//updating highest bidder.
        bid_counter++;//incrementing bid counter.
        if(bid_counter==max_bid_count)//checking if counter is equal to maxBidCount.
        {
            _stopAuction();
        }
    }

    function _stopAuction() private //for stopping auction
    {
        isActive=false; //making accesibility of player false.
        transferToTeam(highestBidder); //assigning highest bidder as team owner.
        for(uint i; i<teamOwnersArray.length; i++)//for refunding to losers.
        {
            if(teamOwnersArray[i]!=highestBidder)
            {
                payable(teamOwnersArray[i]).transfer(teamOwners[teamOwnersArray[i]]);
            }
        }
        _endAuction();

    }

    function _endAuction()private
    {
        selfdestruct(payable(owner()));
    }

    function endAuction() public onlyOwner{
        _endAuction();
    }

    function stopAuction() public onlyOwner{
        _stopAuction();
    }

    function transferToTeam( address _teamOwner)private
    {
        team_owner = _teamOwner;//updating owner.
    }
    
   function getHighestBid() view public returns(uint,address){
        return (highestBid,highestBidder);
    }

    function getBasePrice() view public returns(uint){
        return base_price;
    }
    function getPlayerName() view public returns(string memory){
        return player_name;
    }
    function playerAvailability() public view returns(bool){
        return isActive;
    }

        receive () external payable{
        doBid();
    }
    
}