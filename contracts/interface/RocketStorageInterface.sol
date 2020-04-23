pragma solidity 0.6.6; 


// Our eternal storage interface
abstract contract RocketStorageInterface {
    // Getters
    function getAddress(bytes32 _key) virtual external view returns (address);
    function getUint(bytes32 _key) virtual external view returns (uint);
    function getString(bytes32 _key) virtual external view returns (string memory);
    function getBytes(bytes32 _key) virtual external view returns (bytes memory);
    function getBool(bytes32 _key) virtual external view returns (bool);
    function getInt(bytes32 _key) virtual external view returns (int);
    function getBytes32(bytes32 _key) virtual external view returns (bytes32);
    // Setters
    function setAddress(bytes32 _key, address _value) virtual external;
    function setUint(bytes32 _key, uint _value) virtual external;
    function setString(bytes32 _key, string memory _value) virtual public;
    function setBytes(bytes32 _key, bytes memory _value) virtual public;
    function setBool(bytes32 _key, bool _value) virtual external;
    function setInt(bytes32 _key, int _value) virtual external;
    function setBytes32(bytes32 _key, bytes32 _value) virtual external;
    // Deleters
    function deleteAddress(bytes32 _key) virtual external;
    function deleteUint(bytes32 _key) virtual external;
    function deleteString(bytes32 _key) virtual external;
    function deleteBytes(bytes32 _key) virtual external;
    function deleteBool(bytes32 _key) virtual external;
    function deleteInt(bytes32 _key) virtual external;
    function deleteBytes32(bytes32 _key) virtual external;
}