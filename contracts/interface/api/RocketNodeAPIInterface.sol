pragma solidity 0.6.6; 


// Our node interface
abstract contract RocketNodeAPIInterface {
    // Getters
    function getContract(address _nodeAddress) virtual public view returns (address);
    function getTrusted(address _nodeAddress) virtual public view returns (bool);
    function checkDepositReservationIsValid(address _nodeOwner, string memory _durationID, uint256 _lastDepositReservedTime) virtual public;
    function getRPLRatio(string memory _durationID) virtual public returns(uint256);
    function getRPLRequired(uint256 _weiAmount, string memory _durationID) virtual public returns(uint256, uint256);
    // Methods
    function add(string memory _timezoneLocation) virtual public returns (bool);
    function deposit(address _nodeOwner) virtual public returns(address);
    function checkin(address _nodeOwner, uint256 _averageLoad, uint256 _nodeFeeVote) virtual public returns(bool);
}