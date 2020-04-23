pragma solidity 0.6.6;

abstract contract PublisherInterface {
    function publish(bytes32 _event, bytes memory _payload) virtual public;
    function addSubscriber(bytes32 _event, string memory _subscriber) virtual public;
    function removeSubscriber(bytes32 _event, string memory _subscriber) virtual public;
}
