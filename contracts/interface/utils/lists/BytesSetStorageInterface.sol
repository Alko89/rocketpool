pragma solidity 0.6.6; 

abstract contract BytesSetStorageInterface {
    function getCount(bytes32 _key) virtual external view returns (uint);
    function getItem(bytes32 _key, uint _index) virtual external view returns (bytes memory);
    function getIndexOf(bytes32 _key, bytes memory _value) virtual public view returns (int);
    function addItem(bytes32 _key, bytes memory _value) virtual public;
    function removeItem(bytes32 _key, bytes memory _value) virtual public;
}
