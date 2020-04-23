pragma solidity 0.6.6;

abstract contract RocketDepositIndexInterface {
    // Getters
    function getUserDepositCount(address _groupID, address _userID, string memory _durationID) virtual public returns (uint256);
    function getUserDepositAt(address _groupID, address _userID, string memory _durationID, uint256 _index) virtual public returns (bytes32);
    function getUserQueuedDepositCount(address _groupID, address _userID, string memory _durationID) virtual public returns (uint256);
    function getUserQueuedDepositAt(address _groupID, address _userID, string memory _durationID, uint256 _index) virtual public returns (bytes32);
    function getUserDepositTotalAmount(bytes32 _depositID) virtual public view returns (uint256);
    function getUserDepositQueuedAmount(bytes32 _depositID) virtual public view returns (uint256);
    function getUserDepositStakingAmount(bytes32 _depositID) virtual public view returns (uint256);
    function getUserDepositRefundedAmount(bytes32 _depositID) virtual public view returns (uint256);
    function getUserDepositWithdrawnAmount(bytes32 _depositID) virtual public view returns (uint256);
    function getUserDepositStakingPoolCount(bytes32 _depositID) virtual public returns (uint256);
    function getUserDepositStakingPoolAt(bytes32 _depositID, uint256 _index) virtual public returns (address);
    function getUserDepositStakingPoolAmount(bytes32 _depositID, address _minipool) virtual public view returns (uint256);
    function getUserDepositBackupAddress(bytes32 _depositID) virtual public view returns (address);
    // Methods
    function add(address _userID, address _groupID, string memory _durationID, uint256 _amount) virtual public returns (bytes32);
    function assign(bytes32 _depositID, address _minipool, uint256 _assignAmount) virtual public;
    function refund(bytes32 _depositID, uint256 _refundAmount) virtual public;
    function refundFromStalledMinipool(bytes32 _depositID, address _minipool, uint256 _refundAmount) virtual public;
    function withdrawFromMinipool(bytes32 _depositID, address _minipool, uint256 _withdrawalAmount) virtual public;
}
