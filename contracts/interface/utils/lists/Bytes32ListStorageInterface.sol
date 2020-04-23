pragma solidity 0.6.6; 

abstract contract Bytes32ListStorageInterface {
    function getListCount(bytes32 _key) virtual external view returns (uint);
    function getListItem(bytes32 _key, uint _index) virtual external view returns (bytes32);
    function getListIndexOf(bytes32 _key, bytes32 _value) virtual external view returns (int);
    function setListItem(bytes32 _key, uint _index, bytes32 _value) virtual external;
    function pushListItem(bytes32 _key, bytes32 _value) virtual external;
    function insertListItem(bytes32 _key, uint _index, bytes32 _value) virtual external;
    function removeUnorderedListItem(bytes32 _key, uint _index) virtual external;
    function removeOrderedListItem(bytes32 _key, uint _index) virtual external;
}
