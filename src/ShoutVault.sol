// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ShoutVault {
    uint public postCount;
    // postId => owner
    mapping(uint => address) public postOwner;
    // postId => platformId => score
    mapping(uint => mapping(uint => uint)) public boostScore;

    uint public platformCount;
    mapping(uint => address) public platformImplementations;
    mapping(uint => bool) public platformPaused;

    // Public Write
    function createPost(
        string memory ipfsHash
    ) external returns (uint256 postId) {}

    function depositBoost(
        uint256 postId,
        uint256 platformId,
        uint256 amount
    ) external returns (uint256 postId, uint256 platformId, uint256 amount) {}

    function withdrawBoost(
        uint256 postId,
        uint256 platformId,
        uint256 amount
    ) external returns (uint256 postId, uint256 platformId, uint256 amount) {}

    function createAndBoostPost(
        string memory ipfsHash,
        uint256 platformId,
        uint256 amount
    ) external returns (uint256 postId, uint256 platformId, uint256 amount) {}

    // Admin Write
    function addPlatform(
        address implementation
    ) external returns (uint256 platformId) {}

    function setPausePlatform(uint platformId, bool paused) external {}

    function claimYields(
        uint[] memory platformIds,
        uint[] memory amounts
    ) external {}

    // Read
    function getClaimableYield(
        uint platformId
    ) external view returns (uint256 amount) {}
}
