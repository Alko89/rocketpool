pragma solidity 0.6.6; 

abstract contract UintListStorageInterface {
    function getListCount(bytes32 _key) virtual external view returns (uint);
    function getListItem(bytes32 _key, uint _index) virtual external view returns (uint);
    function getListIndexOf(bytes32 _key, uint _value) virtual external view returns (int);
    function setListItem(bytes32 _key, uint _index, uint _value) virtual external;
    function pushListItem(bytes32 _key, uint _value) virtual external;
    function insertListItem(bytes32 _key, uint _index, uint _value) virtual external;
    function removeUnorderedListItem(bytes32 _key, uint _index) virtual external;
    function removeOrderedListItem(bytes32 _key, uint _index) virtual external;
}
