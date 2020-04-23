pragma solidity 0.6.6;


// Our deposit and withdrawals interface
abstract contract RocketDepositSettingsInterface {
    // Getters
    function getDepositAllowed() virtual public view returns (bool);
    function getProcessDepositQueueAllowed() virtual public view returns (bool);
    function getDepositChunkSize() virtual public view returns (uint256);
    function getDepositMin() virtual public view returns (uint256);
    function getDepositMax() virtual public view returns (uint256);
    function getChunkAssignMax() virtual public view returns (uint256);
    function getDepositQueueSizeMax() virtual public view returns (uint256);
    function getRefundDepositAllowed() virtual public view returns (bool);
    function getCurrentDepositMax(string memory _durationID) virtual public returns (uint256);
    function getStakingWithdrawalAllowed() virtual public view returns (bool);
    function getWithdrawalAllowed() virtual public view returns (bool);
    function getStakingWithdrawalFeePerc() virtual public view returns (uint256);
}
