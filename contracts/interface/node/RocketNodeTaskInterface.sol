pragma solidity 0.6.6;

abstract contract RocketNodeTaskInterface {
    function name() virtual public view returns (string memory);
    function run(address _nodeAddress) virtual public returns (bool);
}
