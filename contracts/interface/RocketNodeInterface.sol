pragma solidity 0.6.6;

abstract contract RocketNodeInterface {
    function getAvailableNodeCount(string memory _durationID) virtual public returns (uint256);
    function getAvailableNodeCount(bool _trusted, string memory _durationID) virtual public returns (uint256);
    function getRandomAvailableNode(bool _trusted, string memory _durationID, uint256 _seed, uint256 _offset) virtual public returns (address);
}
