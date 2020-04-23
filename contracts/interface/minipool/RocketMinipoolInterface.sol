pragma solidity 0.6.6;


abstract contract RocketMinipoolInterface {
    // Getters
    function getNodeOwner() virtual public view returns(address);
    function getNodeContract() virtual public view returns(address);
    function getNodeDepositEther() virtual public view returns(uint256);
    function getNodeDepositRPL() virtual public view returns(uint256);
    function getNodeTrusted() virtual public view returns(bool);
    function getNodeDepositExists() virtual public view returns(bool);
    function getNodeBalance() virtual public view returns(uint256);
    function getNodeUserFee() virtual public view returns(uint256);
    function getDepositCount() virtual public view returns(uint256);
    function getDepositExists(bytes32 _depositID) virtual public view returns(bool);
    function getDepositUserID(bytes32 _depositID) virtual public view returns(address);
    function getDepositGroupID(bytes32 _depositID) virtual public view returns(address);
    function getDepositBalance(bytes32 _depositID) virtual public view returns(uint256);
    function getDepositStakingTokensWithdrawn(bytes32 _depositID) virtual public view returns(uint256);
    function getDepositFeeRP(bytes32 _depositID) virtual public view returns(uint256);
    function getDepositFeeGroup(bytes32 _depositID) virtual public view returns(uint256);
    function getDepositCreated(bytes32 _depositID) virtual public view returns(uint256);
    function getStatus() virtual public view returns(uint8);
    function getStatusChangedTime() virtual public view returns(uint256);
    function getStatusChangedBlock() virtual public view returns(uint256);
    function getStakingDurationID() virtual public view returns (string memory);
    function getStakingDuration() virtual public view returns(uint256);
    function getStakingBalanceStart() virtual public view returns(uint256);
    function getStakingBalanceEnd() virtual public view returns(uint256);
    function getValidatorPubkey() virtual public view returns (bytes memory);
    function getValidatorSignature() virtual public view returns (bytes memory);
    function getValidatorDepositDataRoot() virtual public view returns (bytes32);
    function getWithdrawalCredentials() virtual public view returns (bytes32);
    function getUserDepositCapacity() virtual public view returns(uint256);
    function getUserDepositTotal() virtual public view returns(uint256);
    function getStakingUserDepositsWithdrawn() virtual public view returns(uint256);
    // Methods
    function nodeDeposit() virtual public payable returns(bool);
    function nodeWithdraw() virtual public returns(bool);
    function deposit(bytes32 _depositID, address _userID, address _groupID) virtual public payable returns(bool);
    function refund(bytes32 _depositID, address _refundAddress) virtual public returns(bool);
    function withdrawStaking(bytes32 _depositID, uint256 _withdrawnAmount, uint256 _tokenAmount, address _withdrawnAddress) virtual public returns(bool);
    function withdraw(bytes32 _depositID, address _withdrawalAddress) virtual public returns(bool);
    function updateStatus() virtual public returns(bool);
    function stakeMinipool(bytes memory _validatorPubkey, bytes memory _validatorSignature, bytes32 _validatorDepositDataRoot) virtual public returns(bool);
    function logoutMinipool() virtual public returns (bool);
    function withdrawMinipool(uint256 _withdrawalBalance) virtual public returns (bool);
}
