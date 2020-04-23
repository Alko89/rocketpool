pragma solidity 0.6.6; 


// Our group interface
abstract contract RocketGroupAPIInterface {
    // Getters
    function getGroupName(address _ID) virtual public view returns (string memory);
    function getGroupAccessAddress(address _ID) virtual public view returns(address);
}