pragma solidity 0.6.6; 


// Our API interface
abstract contract RocketDepositAPIInterface {
    function deposit(address _groupID, address _userID, string memory _durationID) virtual public payable returns(bool);
    function depositRefundQueued(address _groupID, address _userID, string memory _durationID, bytes32 _depositID) virtual public returns(uint256);
    function depositRefundMinipoolStalled(address _groupID, address _userID, bytes32 _depositID, address _minipool) virtual public returns(uint256);
    function depositWithdrawMinipoolStaking(address _groupID, address _userID, bytes32 _depositID, address _minipool, uint256 _amount) virtual public returns(uint256);
    function depositWithdrawMinipool(address _groupID, address _userID, bytes32 _depositID, address _minipool) virtual public returns(uint256);
    function setDepositBackupWithdrawalAddress(address _groupID, address _userID, bytes32 _depositID, address _backupWithdrawalAddress) virtual public returns(bool);
}
