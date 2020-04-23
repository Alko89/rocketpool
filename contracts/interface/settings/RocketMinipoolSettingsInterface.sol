pragma solidity 0.6.6;


// Our minipool interface
abstract contract RocketMinipoolSettingsInterface {
    // Getters
    function getMinipoolLaunchAmount() virtual public view returns (uint256);
    function getMinipoolCanBeCreated() virtual public returns (bool);
    function getMinipoolNewEnabled() virtual public view returns (bool);
    function getMinipoolClosingEnabled() virtual public view returns (bool);
    function getMinipoolMax() virtual public view returns (uint256);
    function getMinipoolNewGas() virtual public view returns (uint256);
    function getMinipoolDepositGas() virtual public view returns (uint256);
    function getMinipoolStakingDurationCount() virtual public view returns (uint256);
    function getMinipoolStakingDurationAt(uint256 _index) virtual public view returns (string memory);
    function getMinipoolStakingDurationExists(string memory _duration) virtual public view returns (bool);
    function getMinipoolStakingDurationEpochs(string memory _duration) virtual public view returns (uint256);
    function getMinipoolStakingDurationEnabled(string memory _duration) virtual public view returns (bool);
    function getMinipoolCheckInterval() virtual public view returns (uint256);
    function getMinipoolWithdrawalFeeDepositAddress() virtual public view returns (address);
    function getMinipoolBackupCollectEnabled() virtual public view returns (bool);
    function getMinipoolBackupCollectDuration() virtual public view returns (uint256);
    function getMinipoolTimeout() virtual public view returns (uint256);
    function getMinipoolActiveSetSize() virtual public view returns (uint256);
}
