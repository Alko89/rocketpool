pragma solidity 0.6.6;


// Our smart node interface
abstract contract RocketNodeSettingsInterface {
    // Getters
    function getNewAllowed() virtual public view returns (bool);
    function getEtherMin() virtual public view returns (uint256);
    function getCheckinInterval() virtual public view returns (uint256);
    function getInactiveAutomatic() virtual public view returns (bool);
    function getInactiveDuration() virtual public view returns (uint256);
    function getMaxInactiveNodeChecks() virtual public view returns (uint256);
    function getFeePerc() virtual public view returns (uint256);
    function getMaxFeePerc() virtual public view returns (uint256);
    function getFeeVoteCycleDuration() virtual public view returns (uint256);
    function getFeeVoteCyclePercChange() virtual public view returns (uint256);
    function getDepositAllowed() virtual public view returns (bool);
    function getDepositReservationTime() virtual public view returns (uint256);
    function getWithdrawalAllowed() virtual public view returns (bool);
}
