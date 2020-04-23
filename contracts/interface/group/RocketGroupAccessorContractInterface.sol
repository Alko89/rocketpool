pragma solidity 0.6.6;

abstract contract RocketGroupAccessorContractInterface {
    function rocketpoolEtherDeposit() virtual external payable returns (bool);
}
