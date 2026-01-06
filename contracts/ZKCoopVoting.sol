// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ZKCoopVoting {
    address public admin;

    uint256 public proposalCount;

    struct Proposal {
        string description;
        uint256 voteCount;
        bool active;
    }

    mapping(uint256 => Proposal) public proposals;

    // Nullifier hash → prevents double voting
    mapping(bytes32 => bool) public usedNullifiers;

    event ProposalCreated(uint256 proposalId, string description);
    event VoteCast(uint256 proposalId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createProposal(string calldata description) external onlyAdmin {
        proposals[proposalCount] = Proposal({
            description: description,
            voteCount: 0,
            active: true
        });

        emit ProposalCreated(proposalCount, description);
        proposalCount++;
    }

    /**
     * @notice Vote using a ZK proof
     * @param proposalId The proposal being voted on
     * @param nullifierHash Prevents double voting
     */
    function vote(
        uint256 proposalId,
        bytes32 nullifierHash
    ) external {
        require(proposals[proposalId].active, "Inactive proposal");
        require(!usedNullifiers[nullifierHash], "Already voted");

        // 🔐 ZK proof verification will be added here later

        usedNullifiers[nullifierHash] = true;
        proposals[proposalId].voteCount++;

        emit VoteCast(proposalId);
    }

    function closeProposal(uint256 proposalId) external onlyAdmin {
        proposals[proposalId].active = false;
    }
}
