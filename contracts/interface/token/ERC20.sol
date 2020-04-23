pragma solidity 0.6.6;


/**
 * @title ERC20 interface
 *
 * Contract source taken from Open Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/ERC20.sol
 */
abstract contract ERC20 {
    uint256 public totalSupply;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    function balanceOf(address who) virtual public view returns (uint256);
    function transfer(address to, uint256 value) virtual public returns (bool);
    function allowance(address owner, address spender) virtual public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) virtual public returns (bool);
    function approve(address spender, uint256 value) virtual public returns (bool);
}