pragma solidity 0.6.6; 

abstract contract IntSetStorageInterface {
    function getCount(bytes32 _key) virtual external view returns (uint);
    function getItem(bytes32 _key, uint _index) virtual external view returns (int);
    function getIndexOf(bytes32 _key, int _value) virtual external view returns (int);
    function addItem(bytes32 _key, int _value) virtual external;
    function removeItem(bytes32 _key, int _value) virtual external;
}
