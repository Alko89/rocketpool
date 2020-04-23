pragma solidity 0.6.6; 


// Our node interface
abstract contract RocketNodeFactoryInterface {
    // Methods
    function createRocketNodeContract(address _nodeOwnerAddress) virtual public returns(address);
}