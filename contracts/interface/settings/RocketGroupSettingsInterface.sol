pragma solidity 0.6.6;


// Our group interface
abstract contract RocketGroupSettingsInterface {
    // Getters
    function getDefaultFee() virtual public view returns (uint256);
    function getMaxFee() virtual public view returns (uint256);
    function getNewAllowed() virtual public view returns (bool);
    function getNewFee() virtual public view returns (uint256);
    function getNewFeeAddress() virtual public view returns (address payable);
}
