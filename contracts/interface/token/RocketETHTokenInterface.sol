pragma solidity 0.6.6;

import "./ERC20.sol";

abstract contract RocketETHTokenInterface is ERC20 {
    function mint(address _to, uint256 _amount) virtual public returns (bool);
}
