pragma solidity 0.6.6; 

abstract contract BoolQueueStorageInterface {
	function capacity() virtual public view returns (uint);
    function getQueueLength(bytes32 _key) virtual public view returns (uint);
    function getQueueItem(bytes32 _key, uint _index) virtual external view returns (bool);
    function getQueueIndexOf(bytes32 _key, bool _value) virtual external view returns (int);
    function enqueueItem(bytes32 _key, bool _value) virtual external;
    function dequeueItem(bytes32 _key) virtual external;
    function removeItem(bytes32 _key, bool _value) virtual external;
    function setCapacity(uint256 _value) virtual external;
}
