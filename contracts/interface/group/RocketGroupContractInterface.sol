pragma solidity 0.6.6; 


// Our group contract interface
abstract contract RocketGroupContractInterface {
    // Getters
    function getOwner() virtual public view returns(address);
    function getFeePerc() virtual public view returns(uint256);
    function getFeePercRocketPool() virtual public view returns(uint256);
    function getFeeAddress() virtual public view returns(address);
    function hasDepositor(address _depositorAddress) virtual public view returns (bool);
    function hasWithdrawer(address _withdrawerAddress) virtual public view returns (bool);
    function setFeePercRocketPool(uint256 _stakingFeePerc) virtual public returns(bool);
}
