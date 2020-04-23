pragma solidity 0.6.6;

/// @title Rocket Pool deposits
abstract contract RocketDepositInterface {
    function create(address _userID, address _groupID, string memory _durationID) virtual payable public returns (bytes32);
    function refund(address _userID, address _groupID, string memory _durationID, bytes32 _depositID, address _depositorAddress) virtual public returns (uint256);
    function refundFromStalledMinipool(address _userID, address _groupID, bytes32 _depositID, address _minipool, address _withdrawerAddress) virtual public returns (uint256);
    function withdrawFromStakingMinipool(address _userID, address _groupID, bytes32 _depositID, address _minipool, uint256 _amount, address _withdrawerAddress) virtual public returns (uint256);
    function withdrawFromWithdrawnMinipool(address _userID, address _groupID, bytes32 _depositID, address _minipool, address _withdrawerAddress) virtual public returns (uint256);
    function setDepositBackupWithdrawalAddress(address _userID, address _groupID, bytes32 _depositID, address _backupWithdrawalAddress) virtual public returns (bool);
}
