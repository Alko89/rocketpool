pragma solidity 0.6.6; 

abstract contract StringQueueStorageInterface {
	function capacity() virtual public view returns (uint);
    function getQueueLength(bytes32 _key) virtual public view returns (uint);
    function getQueueItem(bytes32 _key, uint _index) virtual external view returns (string memory);
    function getQueueIndexOf(bytes32 _key, string memory _value) virtual public view returns (int);
    function enqueueItem(bytes32 _key, string memory _value) virtual public;
    function dequeueItem(bytes32 _key) virtual external;
    function removeItem(bytes32 _key, string memory _value) virtual public;
    function setCapacity(uint256 _value) virtual external;
}
