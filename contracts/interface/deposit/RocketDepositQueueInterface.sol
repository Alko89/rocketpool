pragma solidity 0.6.6;

/// @title Rocket Pool deposit queue
abstract contract RocketDepositQueueInterface {
    function getBalance(string memory _durationID) virtual public view returns (uint256);
    function enqueueDeposit(address _userID, address _groupID, string memory _durationID, bytes32 _depositID, uint256 _amount) virtual public;
    function removeDeposit(address _userID, address _groupID, string memory _durationID, bytes32 _depositID, uint256 _amount) virtual public;
    function assignChunks(string memory _durationID) virtual public;
}
