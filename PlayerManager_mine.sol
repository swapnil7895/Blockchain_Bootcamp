pragma solidity ^0.8.0;
import "./Auction.sol";
contract PlayerManager
{
    mapping (uint=>Auction) players;
    uint playerCounter;
    function registerPlayer
    (
        string memory _name,
        uint player_age,
        string memory _type,
        uint _rating        //out of 5 (1 is lowest/5 is highest)
    )
    public
    {
        uint _playerId=(playerCounter+1);
        uint _basePrice=(_rating*10);
        uint max_bid_count=(_rating*5);
        Auction player=new Auction( _name, _playerId, player_age, _type, _rating, _basePrice, max_bid_count );
        players[playerCounter] = player;
        playerCounter++;
        
    }
}