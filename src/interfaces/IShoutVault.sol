// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface IShoutVault {
    event PostCreated(
        uint indexed postId,
        address indexed owner,
        string ipfsHash
    );
    event BoostAdjusted(
        uint indexed postId,
        uint indexed yieldVaultId,
        uint oldAmount,
        uint newAmount
    );
    event YieldVaultAdded(
        uint indexed yieldVaultId,
        address indexed yieldVault
    );
    event YieldVaultPaused(uint indexed yieldVaultId, bool paused);
    event YieldClaimed(
        uint indexed yieldVaultId,
        address indexed yieldVault,
        uint amount
    );

    // Write function
    function createPost(
        string memory _ipfsHash
    ) external returns (uint256 postId);

    function depositBoost(
        uint256 _postId,
        uint256 _yieldVaultId,
        uint256 _amount
    ) external returns (uint256 postId, uint256 yieldVaultId, uint256 amount);

    function withdrawBoost(
        uint256 _postId,
        uint256 _yieldVaultId,
        uint256 _amount
    ) external returns (uint256 postId, uint256 yieldVaultId, uint256 amount);

    function createAndBoostPost(
        string memory _ipfsHash,
        uint256 _yieldVaultId,
        uint256 _amount
    ) external returns (uint256 postId, uint256 yieldVaultId, uint256 amount);

    function addYieldVault(
        address _yieldVault
    ) external returns (uint256 yieldVaultId);

    function setPausePlatform(uint _yieldVaultId, bool _paused) external;

    function claimYields(
        uint[] memory _yieldVaultIds,
        uint[] memory _amounts
    ) external;

    // Read function
    function getClaimableYield(
        uint _yieldVaultId
    ) external view returns (uint256 amount);
}
