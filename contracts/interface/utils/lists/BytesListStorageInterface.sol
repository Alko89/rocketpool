pragma solidity 0.6.6; 

abstract contract BytesListStorageInterface {
    function getListCount(bytes32 _key) virtual external view returns (uint);
    function getListItem(bytes32 _key, uint _index) virtual external view returns (bytes memory);
    function getListIndexOf(bytes32 _key, bytes memory _value) virtual public view returns (int);
    function setListItem(bytes32 _key, uint _index, bytes memory _value) virtual public;
    function pushListItem(bytes32 _key, bytes memory _value) virtual public;
    function insertListItem(bytes32 _key, uint _index, bytes memory _value) virtual public;
    function removeUnorderedListItem(bytes32 _key, uint _index) virtual external;
    function removeOrderedListItem(bytes32 _key, uint _index) virtual external;
}
