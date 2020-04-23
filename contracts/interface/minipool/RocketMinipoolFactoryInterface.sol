pragma solidity 0.6.6;


abstract contract RocketMinipoolFactoryInterface {
    function createRocketMinipool(address _nodeOwner, string memory _durationID, uint256 _etherDeposited, uint256 _rplDeposited, bool _trusted) virtual public returns(address);
}