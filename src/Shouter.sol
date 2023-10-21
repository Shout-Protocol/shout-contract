// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IShouter.sol";
import "./interfaces/IYieldVault.sol";

contract Shouter is IShouter, Ownable {
    uint public postCount;
    // postId => owner
    mapping(uint => address) public postOwner;
    // postId => yieldVaultId => score
    mapping(uint => mapping(uint => uint)) public boostScore;

    uint public vaultCount;
    mapping(uint => IYieldVault) public yieldVaults;
    mapping(uint => bool) public yieldVaultPaused;

    // === Modifiers ===
    modifier onlyPostOwner(uint postId) {
        require(msg.sender == postOwner[postId], "Shouter: Only post owner");
        _;
    }

    modifier isNotPaused(uint yieldVaultId) {
        require(
            !yieldVaultPaused[yieldVaultId],
            "Shouter: Yield vault is paused"
        );
        _;
    }

    constructor() Ownable(msg.sender) {}

    // === Public Functions ===

    // Public Write
    function createPost(
        string memory ipfsHash
    ) external override returns (uint256 postId) {
        return _createPost(msg.sender, ipfsHash);
    }

    function depositBoost(
        uint256 _postId,
        uint256 _yieldVaultId,
        uint256 _amount
    )
        external
        override
        onlyPostOwner(_postId)
        isNotPaused(yieldVaultId)
        returns (uint256 postId, uint256 yieldVaultId, uint256 amount)
    {
        return _depositBoost(_postId, _yieldVaultId, _amount);
    }

    function withdrawBoost(
        uint256 _postId,
        uint256 _yieldVaultId,
        uint256 _amount
    )
        external
        override
        onlyPostOwner(_postId)
        returns (uint256 postId, uint256 yieldVaultId, uint256 amount)
    {
        return _withdrawBoost(_postId, _yieldVaultId, _amount);
    }

    function createAndBoostPost(
        string memory _ipfsHash,
        uint256 _yieldVaultId,
        uint256 _amount
    )
        external
        override
        isNotPaused(_yieldVaultId)
        returns (uint256 postId, uint256 yieldVaultId, uint256 amount)
    {
        uint256 pId = _createPost(msg.sender, _ipfsHash);
        return _depositBoost(pId, _yieldVaultId, _amount);
    }

    // Public Write (Admin)
    function addYieldVault(
        address _yieldVault
    ) external override onlyOwner returns (uint256 yieldVaultId) {
        return _addYieldVault(_yieldVault);
    }

    function setPausePlatform(
        uint _yieldVaultId,
        bool _paused
    ) external override {
        _setPausePlatform(_yieldVaultId, _paused);
    }

    function claimYields(
        uint[] memory _yieldVaultIds,
        uint[] memory _amounts
    ) external override onlyOwner {
        _claimYields(_yieldVaultIds, _amounts);
    }

    // Public Read
    function getClaimableYield(
        uint _yieldVaultId
    ) external view override onlyOwner returns (uint256 amount) {
        IYieldVault yieldVault = yieldVaults[_yieldVaultId];
        return yieldVault.getYieldAmount();
    }

    // === Private Functions ===

    // Private Write
    function _createPost(
        address owner,
        string memory ipfsHash
    ) private returns (uint256 postId) {
        postCount++;
        postOwner[postCount] = owner;
        emit PostCreated(postCount, owner, ipfsHash);
        return postCount;
    }

    function _depositBoost(
        uint256 _postId,
        uint256 _yieldVaultId,
        uint256 _amount
    ) private returns (uint256 postId, uint256 yieldVaultId, uint256 amount) {
        uint prevAmount = boostScore[_postId][_yieldVaultId];
        uint newBoost = boostScore[_postId][_yieldVaultId] + _amount;
        boostScore[_postId][_yieldVaultId] = newBoost;

        IYieldVault yieldVault = yieldVaults[_yieldVaultId];
        IERC20 token = IERC20(yieldVault.token());
        token.transferFrom(msg.sender, address(this), _amount);
        token.approve(address(yieldVault), _amount);
        yieldVault.deposit(_amount);

        emit BoostAdjusted(_postId, _yieldVaultId, prevAmount, newBoost);
        return (_postId, _yieldVaultId, _amount);
    }

    function _withdrawBoost(
        uint256 _postId,
        uint256 _yieldVaultId,
        uint256 _amount
    ) private returns (uint256 postId, uint256 yieldVaultId, uint256 amount) {
        uint prevAMount = boostScore[_postId][_yieldVaultId];
        uint newBoost = boostScore[_postId][_yieldVaultId] - _amount;
        boostScore[_postId][_yieldVaultId] = newBoost;

        IYieldVault yieldVault = yieldVaults[_yieldVaultId];
        yieldVault.withdraw(_amount);
        IERC20 token = IERC20(yieldVault.token());
        token.transfer(msg.sender, _amount);

        emit BoostAdjusted(_postId, _yieldVaultId, prevAMount, newBoost);
        return (_postId, _yieldVaultId, _amount);
    }

    function _addYieldVault(
        address _yieldVault
    ) private returns (uint256 yieldVaultId) {
        vaultCount++;
        yieldVaults[vaultCount] = IYieldVault(_yieldVault);
        emit YieldVaultAdded(vaultCount, _yieldVault);
        return vaultCount;
    }

    function _setPausePlatform(uint _yieldVaultId, bool _paused) private {
        yieldVaultPaused[_yieldVaultId] = _paused;
        emit YieldVaultPaused(_yieldVaultId, _paused);
    }

    function _claimYields(
        uint[] memory _yieldVaultIds,
        uint[] memory _amounts
    ) private {
        for (uint i = 0; i < _yieldVaultIds.length; i++) {
            uint yieldVaultId = _yieldVaultIds[i];
            uint amount = _amounts[i];
            _claimYield(yieldVaultId, amount);
        }
    }

    function _claimYield(uint _yieldVaultId, uint _amount) private {
        IYieldVault yieldVault = yieldVaults[_yieldVaultId];
        yieldVault.withdrawYield(_amount);
        IERC20 token = IERC20(yieldVault.token());
        token.transfer(msg.sender, _amount);
        emit YieldClaimed(_yieldVaultId, msg.sender, _amount);
    }
}
