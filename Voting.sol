
pragma solidity ^0.8.0; 

contract Voting
{

    //state variables
    bool votingStarted; //for start/end voting.
    address owner; //for storing organzizer's address.
    uint maxID;
    uint public candidateCounter;//for knowing how many candidates are there
    uint i;//for iteration of seeing total votes of candidates
    uint maxVotersId;// winnner
    uint public maxVotes;
    uint prevMaxVotes;
    bool isResultCalculated;

    //arrays
    //Candidate candidatesArray[]; // for storing candidates.
    address [] voted;

    constructor()
    {
        owner=msg.sender;
    }
    
    struct Candidate
    {
        string name;
        uint id;
        uint TotalVotes;
        bool canFight;
    }


    // modifiers
    //1 isOwner
    modifier isOwner()
    {
        require(msg.sender==owner,"only owner can call this");
        _;
    } 


    //mappings
    //1
    mapping ( uint => Candidate) candidates;
    //2 for voted or not  
    mapping ( address => bool ) votedOrNot;


    function startVoting()public isOwner
    {
        require ( votingStarted==false,"Voting is already in progress");
        votingStarted=true;
    }   

    function applyForCandidature(string memory _name, uint _age)public 
    {   
        //organizer cant be candidate
        require(msg.sender!=owner, "Owner cant participate in election");
        require(votingStarted==true,"Voting is not started yet, Please wait for it, Then apply");
        Candidate memory candidate = Candidate (_name, _age, 0, false );
        candidateCounter++;
        candidates [ candidateCounter ] = candidate; //passing newly created Candidate instance to mapping
        //candidatesArray[CandidateCounter]=candidate;// no need i'll remove this later.
        

    }
    function giveAccessForCandidature(uint _id) public isOwner
    {
        //only organizer can call
        require( votingStarted == true ,"Voting is not started yet, Please wait for it, Then apply");
        candidates[_id].canFight = true;
    }

    function vote( uint _id )public
    {
        //anyone can vote   //but one person can vote only once
        require ( votedOrNot[msg.sender] == false, "You are already voted" );
        require ( candidates[_id].canFight == true, "This candidate is not approved yet to fight election" );
        candidates[_id].TotalVotes++;
        votedOrNot[msg.sender]=true;
    }

    //array for total votes of voters
    
    function calculateResult( ) public isOwner
    {
        //only owner can call this function
        require ( votingStarted == false ,"Voting is still on,first end it.");
        require ( candidateCounter!=0,"Voting did not happened, Start voting and then check results.");
        for ( i=1; i<=candidateCounter;i++)
            {
              if(maxVotes>prevMaxVotes || maxVotes==0 )
              {
                maxVotes=candidates[i].TotalVotes;
                maxVotersId=i;
              }
             prevMaxVotes=maxVotes;
            }
        isResultCalculated=true;
    }

    function seeWinner( )public view returns(string memory) 
    {
        //anyone can call
        require( isResultCalculated ==true, "Result is not calculated yet.");
        require ( votingStarted==false,"Voting is not done yet");
        //require ( maxVoterId !=0 ," Result is not calculated yet " );
        string memory winnerName=candidates[maxVotersId].name;
        return winnerName;
    }
  
    function endVoting()public isOwner
    {
        require ( votingStarted==true,"Voting is not started or already ended");
        //only organizer can call
        votingStarted=false;
    }

    function isVotingIsOn()public view returns(bool)// to see whether voting is on or not
    {
        return votingStarted;
    }

}
