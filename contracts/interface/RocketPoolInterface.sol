pragma solidity 0.6.6;


abstract contract RocketPoolInterface {
    function getRandomAvailableMinipool(bool _trusted, string memory _durationID, uint256 _seed, uint256 _offset) virtual public returns (address);
    function getNetworkUtilisation(string memory _durationID) virtual public view returns (uint256);
    function getPoolsCount() virtual public returns(uint256);
    function getAvailableNodePoolsCount(address _nodeAddress, bool _trusted, string memory _durationID) virtual public returns(uint256);
    function getTotalEther(string memory _type, string memory _durationID) virtual public view returns (uint256);
    function minipoolCreate(address _nodeOwner, string memory _durationID, uint256 _etherAmount, uint256 _rplAmount, bool _isTrustedNode) virtual public returns (address);
    function minipoolRemove() virtual public returns (bool);
}
