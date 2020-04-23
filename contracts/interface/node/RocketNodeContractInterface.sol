pragma solidity 0.6.6;


abstract contract RocketNodeContractInterface {
    function getOwner() virtual public view returns(address);
    function getRewardsAddress() virtual public view returns(address);
    function getHasDepositReservation() virtual public view returns(bool);
    function getDepositReservedTime() virtual public view returns(uint256);
    function getDepositReserveEtherRequired() virtual public returns(uint256);
    function getDepositReserveRPLRequired() virtual public returns(uint256);
    function getDepositReserveDurationID() virtual public returns (string memory);
    function getDepositReserveValidatorPubkey() virtual public returns (bytes memory);
    function getDepositReserveValidatorSignature() virtual public returns (bytes memory);
    function getDepositReserveValidatorDepositDataRoot() virtual public returns (bytes32);
}