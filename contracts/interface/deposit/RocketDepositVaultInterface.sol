pragma solidity 0.6.6;

/// @title Rocket Pool deposit vault
abstract contract RocketDepositVaultInterface {
    function depositEther() virtual payable external returns (bool);
    function withdrawEther(address _withdrawalAddress, uint256 _amount) virtual external returns (bool);
}
