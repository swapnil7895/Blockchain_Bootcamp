//functionalities i want to include in This
//1. post dweet
//2. follow/unfollow user
//3 like/dislike dweet
//4 delete dweet
//5 report dweet
pragma solidity ^0.8.0;

contract Dwitter
{
    //state variables
    uint public dweetCounter;
    uint userCounter;
    address owner;
    string dweetContent;//for showing dweet content
    uint public userIdCounter;

    Dweet[] dweetArray;
    mapping (address => Dweet) dweetToUser;
    mapping (address => User) users; //ffor map user with address for attach dweets
    mapping ( uint => User) userById;
    mapping (uint => User ) forStoringFollowers;
    mapping (uint => Dweet) dweetById;
    
    mapping ( address => User ) alreadyFollowed;//mapping for restrict follow someone who is already followed
    
    //constructor
    constructor()
    {
        owner=msg.sender;
    }

    //structs

    struct Dweet
    {
        uint dweetId;
        string content;
        uint liked;
        uint disliked;
        uint reported;
        bool deleted; 
        //total 6
    }

    struct User
    {
        uint userId;
        string name;
        bool isRegistered;
        
        uint howManyDweets;
        uint followers;
        uint following;
        
        uint[] whoFollowMe;
        uint[] iFollowWhom;
        uint[] likedDweets;
        
        uint[] dislikedDweets;
        //total 10
    }

    //functions
    function registerUser(string memory _name) public
    {
        require ( msg.sender!=owner,"Owner cant register");
        require ( users[msg.sender].isRegistered==false,"You are already registered! ");
        userIdCounter++;
        User memory user = User(userIdCounter, _name, true,0,0,0,
                                new uint[](0),new uint[](0),
                                new uint [](0),new uint[](0));
        users[msg.sender]=user;
        userById[userIdCounter]=user;
    }

    function dweeet(string memory _content) public
    {
        //should not be owner
        require(msg.sender!=owner,"Owner cant dweeet");
        //user should exist
        require ( users[msg.sender].isRegistered==true,"User is not registered yet");
        //dweet id ++
        dweetCounter++;
        //creating dweet instance
        Dweet memory dweet = Dweet ( dweetCounter, _content ,0, 0, 0, false);
        //passing instance to mapping for attaching dweet to resp. user.
        dweetToUser[msg.sender]=dweet; //
        dweetById[dweetCounter]=dweet;
        //dweetArray.push=dweet;
        //to count how many dweets user has
        users[msg.sender].howManyDweets++;
    }

    function searchUser( uint _userId ) public view returns(User memory)
    {
        User memory u =userById[_userId];
        return u;
    }

    function followUser( uint  _userId   ) public
    {
        //shouldnt follow if already followed
        //require ( alreadyFollowed[_userId]);
        require ( userById[_userId].userId != users[msg.sender].userId ,"You cant follow yourself ");
        require(msg.sender!=owner,"Owner cant follow");
        require(users[msg.sender].isRegistered == true,"First register ! ");
        require(userById[_userId].isRegistered==true, " User doesn't exist" );
        User memory u=searchUser(_userId);
        u.followers++;
        users[msg.sender].following++;
        userById[_userId].whoFollowMe.push(users[msg.sender].userId);
        users[msg.sender].iFollowWhom.push(u.userId);
        //alreadyFollowed[msg.sender]=userById[_userId];
    }

    function unfollowUser( uint _userId) public
    {
        //shouldnt unfollow if already unfollowed
        require(msg.sender!=owner,"Owner cant unfollow");
        require(users[msg.sender].isRegistered == true," First register ! ");
        require(userById[_userId].isRegistered==true, " User doesn't exist" );
        User memory u=searchUser(_userId);
        u.followers--;
        users[msg.sender].following--;
       // u.whoFollowMe.pop(users[msg.sender]);
      //  users[msg.sender].iFollowWhom.pop(u);

    }

    function likeDweet( uint _DweetId) public
    {
        //require();
        require(dweetById[_DweetId].deleted!=true,"Dweet is deleted");
        dweetById[_DweetId].liked++;
        //Dweet memory d = dweetById[_DweetId];
        users[msg.sender].likedDweets.push(_DweetId);
    }
    function dislikeDweet( uint _DweetId) public
    {
        //require();
        require(dweetById[_DweetId].deleted!=true,"Dweet is deleted");
        dweetById[_DweetId].disliked++;
        //Dweet memory d = dweetById[_DweetId];
        users[msg.sender].dislikedDweets.push(_DweetId);
    }

    function deleteDweet(uint _dweetId) public
    {
        require(dweetById[_dweetId].deleted!=true,"Dweet is already deleted");
        dweetById[_dweetId].deleted=true;
        dweetCounter--;
        
        
    }

    function reportDweet( uint _DweetId) public
    {
        require(dweetById[_DweetId].deleted!=true,"Dweet is deleted");
        
        if(dweetById[_DweetId].reported==15)
        {
            deleteDweet(_DweetId);
        }
        dweetById[_DweetId].reported++;
    }

    function fetchDweet( uint _dweetId) public
    {
        require (dweetById[_dweetId].deleted==false,"This dweet is deleted! ");
        require ( _dweetId<=dweetCounter,"Invalid dweet Id");
        dweetContent=dweetById[_dweetId].content;

    }
    
    function showDweet() public view returns(string memory)
    {
        return dweetContent;
    }
    
    function userDweetCount(uint _userId) public view returns(uint)
    {
        uint e=userById[_userId].howManyDweets;
        return e;
    }
    function seeFollowers() public view returns( uint)
    {
        uint w=users[msg.sender].followers;
        return w;
    }
    
    function seeFollowing() public view returns( uint)
    {
        uint w=users[msg.sender].following;
        return w;
    }
    function showMyName() public view returns(string memory)
    {
        string memory a =users[msg.sender].name;
        return a;
    }
    
}
