pragma solidity 0.6.6;

abstract contract RocketMinipoolSetInterface {
    function getNextActiveMinipool(string memory _durationID, uint256 _seed) virtual public returns (address);
    function updateActiveMinipools(string memory _durationID) virtual public;
}
