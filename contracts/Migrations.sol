// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }

    address public admin;
    string public electionName;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint public totalVotes;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor(string memory _name) {
        admin = msg.sender;
        electionName = _name;
    }

    function addCandidate(string memory _name) public onlyAdmin {
        candidates.push(Candidate(candidates.length, _name, 0));
    }

    function authorizeVoter(address _voter) public onlyAdmin {
        voters[_voter].authorized = true;
    }

    function vote(uint _candidateId) public {
        require(!voters[msg.sender].voted, "You have already voted");
        require(voters[msg.sender].authorized, "You are not authorized to vote");

        voters[msg.sender].vote = _candidateId;
        voters[msg.sender].voted = true;
        candidates[_candidateId].voteCount += 1;
        totalVotes += 1;
    }

    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }

    function endElection() public view onlyAdmin returns (string memory winnerName, uint winnerVoteCount) {
        uint maxVotes = 0;
        uint winnerId;
        
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }
        winnerName = candidates[winnerId]
