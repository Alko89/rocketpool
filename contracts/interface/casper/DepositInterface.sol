pragma solidity 0.6.6;

abstract contract DepositInterface {
    function deposit(bytes memory _pubkey, bytes memory _withdrawalCredentials, bytes memory _signature, bytes32 _depositDataRoot) virtual public payable;
}
