pragma solidity 0.6.6;

abstract contract RocketNodeKeysInterface {
    function validatePubkey(bytes memory _validatorPubkey) virtual public view;
    function reservePubkey(address _nodeOwner, bytes memory _validatorPubkey, bool _reserve) virtual public;
}
