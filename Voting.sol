pragma solidity ^0.8.0; 

contract Voting
{

    //state variables
    bool votingStarted;                                                     //for start/end voting.
    address owner;                                                          //for storing organzizer's address.
    uint public candidateCounter;                                           //for getting how many candidates are there
    uint i;                                                                 //for iteration of seeing total votes of candidates
    uint maxVotersId;                                                       //for storing winner's id.
    uint public maxVotes;                                                   // winnner votes
    uint prevMaxVotes;                                                      //used in loop
    bool isResultCalculated;                                                //for restricting voting to only once.
    bool votingCanBeStartOnlyOnce;                                          //for restricting voting to only once.
    uint public howManyVoted;                                               //total voters
    
    
    constructor()
    {
        owner=msg.sender;                                                   //assigning deployer as owner.
    }
    
    struct Candidate
    {
        string name;
        uint id;
        uint TotalVotes;
        bool canFight;
    }


    // modifiers
    //1. isOwner
    
    modifier isOwner()
    {
        require(msg.sender==owner,"only owner can call this");
        _;
    } 


    //mappings
    //1
    mapping ( uint => Candidate) candidates;                                        //mapping for access candidate with ID.
    
    //2 for voted or not  
    mapping ( address => bool ) votedOrNot;                                         //mapping for change voter's state-non voted to voted.


    function startVoting () public isOwner
    {
        require (votingCanBeStartOnlyOnce==false,"Voting can be done only once");   //To restrict voting start more than once.
        require (isResultCalculated==false,"Voting can be started only once");      //To restrict voting start more than once.
        require ( votingStarted==false,"Voting is already in progress");            //if treid to start when it's already started
        votingStarted=true;
    }   

    function applyForCandidature (string memory _name, uint _age) public 
    {   
        require(msg.sender!=owner, "Owner cant participate in election");           //owner cant participate.
        require(votingStarted==true,"Voting is not started yet, Please wait for it, Then apply");  //voting must be started for applying.
        Candidate memory candidate = Candidate (_name, _age, 0, false );            //creating instance of candidate.
        candidateCounter++;                                                         //how many candidates are here till now.
        candidates [ candidateCounter ] = candidate;                                //passing newly created Candidate instance to mapping.
    }
    
    function giveAccessForCandidature (uint _id) public isOwner
    {
        require ( votingCanBeStartOnlyOnce==false,"Voting is over, no use of giving access.");
        require( votingStarted == true ,"Voting is not started yet, Please wait for it, Then apply");
        candidates[_id].canFight = true;                                            //giving access to candidate for fight election.
    }

    function vote ( uint _id ) public
    {
        require (votingCanBeStartOnlyOnce==false,"Cant vote now, Voting is over");
        require ( votedOrNot[msg.sender] == false, "You are already voted" );       //checking if voter  voded or not
        require ( candidates[_id].canFight == true, "This candidate is not approved yet to fight election" );   //checking if candidate can fight or not.
        candidates[_id].TotalVotes++;                                               //incrementing votes of candidate.
        votedOrNot[msg.sender]=true;                                                //marking voter as voted.
        howMnayVoted++;                                                             //counting total votes.
    }
    
    function calculateResult ( ) public isOwner
    {
        if(candidateCounter>1)                                                      //if there is only one candidate in election then he is automatically elected, whether anybody voted or not.
        {
            require ( howManyVoted!=0,"Nobody voted, can't calculate result.");     //if there is more than one candidate then there will be checking of votes.
        }
        
        require (isResultCalculated==false,"Voting calculation is done only once"); 
        require ( votingStarted == false ,"Voting is still on,first end it.");
        require ( candidateCounter!=0,"There is no candidate fighting election, Please add them first.");  //if there is no candidate.
        for ( i=1; i<=candidateCounter;i++)                                          //for finding winner. 
            {
              if(maxVotes>prevMaxVotes || maxVotes==0 )                             
              {
                maxVotes=candidates[i].TotalVotes;
                maxVotersId=i;
              }
             prevMaxVotes=maxVotes;
            }
        isResultCalculated=true;                                                     //flag for calculating result only once.
    }

    function seeWinner ( ) public view returns (string memory) 
    {   
        require( isResultCalculated ==true, "Result is not calculated yet.");
        require ( votingStarted==false,"Voting is not done yet");
        string memory winnerName=candidates[maxVotersId].name;                       //assigning max voter as winner.
        if(candidateCounter==1)                                                      //if there is only one candidate and no voter-so that to select that candiidate as winner.
        {
            winnerName=candidates[1].name;
            return winnerName;
        }else
        {return winnerName;}                                                        //return winner name.
    }
  
    function endVoting()public isOwner
    {
       
        require ( votingStarted==true, "Voting is not started or already ended");
        votingStarted=false;                                                        //to end voting
        votingCanBeStartOnlyOnce=true;                                              //to ensure voting can only be done once.
    }

    function isVotingIsOn () public view returns (bool)                             // to see whether voting is on or not
    {
        return votingStarted;
    }

}
