pragma solidity 0.6.6;

abstract contract RocketNodeTasksInterface {
    function run(address _nodeAddress) virtual external;
    function runOne(address _nodeAddress, address _taskAddress) virtual external;
}
