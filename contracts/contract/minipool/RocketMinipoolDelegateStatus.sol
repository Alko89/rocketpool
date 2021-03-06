pragma solidity 0.5.8;


// Interfaces
import "./RocketMinipoolBase.sol";
import "../../interface/RocketPoolInterface.sol";
import "../../interface/settings/RocketNodeSettingsInterface.sol";
import "../../interface/settings/RocketMinipoolSettingsInterface.sol";
import "../../interface/utils/pubsub/PublisherInterface.sol";
// Libraries
import "../../lib/SafeMath.sol";


/// @title The minipool delegate for status methods, should contain all primary logic for methods that minipools use, is entirely upgradable so that currently deployed pools can get any bug fixes or additions - storage here MUST match the minipool contract
/// @author David Rugendyke

contract RocketMinipoolDelegateStatus is RocketMinipoolBase {

    /*** Libs  *****************/

    using SafeMath for uint;


    /*** Events ****************/


    event PoolDestroyed (
        address indexed _user,                                  // User that triggered the close
        address indexed _address,                               // Address of the pool
        uint256 created                                         // Creation timestamp
    );

    event StatusChange (
        uint256 indexed _statusCodeNew,                         // Pools status code - new
        uint256 indexed _statusCodeOld,                         // Pools status code - old
        uint256 time,                                           // The last time the status changed
        uint256 block                                           // The last block number the status changed
    );


    /*** Methods *************/


    /// @dev minipool constructor
    /// @param _rocketStorageAddress Address of Rocket Pools storage.
    constructor(address _rocketStorageAddress) RocketMinipoolBase(_rocketStorageAddress) public {}


    /// @dev Returns the deposit count for this pool
    function getDepositCount() public view returns(uint256) {
        return depositIDs.length;
    }


    /// @dev Change the status
    /// @param _newStatus status id to apply to the minipool
    function setStatus(uint8 _newStatus) private {
        // Fire the event if the status has changed
        if (_newStatus != status.current) {
            status.previous = status.current;
            status.current = _newStatus;
            status.time = now;
            status.block = block.number;
            emit StatusChange(status.current, status.previous, status.time, status.block);
            // Publish status change event
            publisher = PublisherInterface(getContractAddress("utilPublisher"));
            publisher.publish(keccak256("minipool.status.change"), abi.encodeWithSignature("onMinipoolStatusChange(address,uint8)", address(this), _newStatus));
        }
    }


    /// @dev Sets the status of the pool based on its current parameters 
    function updateStatus() public returns(bool) {
        // Load contracts
        rocketMinipoolSettings = RocketMinipoolSettingsInterface(getContractAddress("rocketMinipoolSettings"));
        // Get minipool settings
        uint256 launchAmount = rocketMinipoolSettings.getMinipoolLaunchAmount();
        // Check to see if we can close the pool - stops execution if closed
        closePool();
        // Set to DepositAssigned - Minipool has been assigned user(s) ether but not enough to begin staking yet. Node owners cannot withdraw their ether/rpl.
        if (getDepositCount() > 0 && status.current == 0) {
            // DepositAssigned
            setStatus(1);
            // Done
            return true;
        }
        // Set to PreLaunch - Minipool is ready to begin staking
        if (getDepositCount() > 0 && status.current == 1 && address(this).balance >= launchAmount) {
            // PreLaunch
            setStatus(2);
            // Done
            return true;
        }
        // Set to TimedOut - If a minipool is widowed or stuck for a long time, it is classed as timed out (it has users, not enough to begin staking, but the node owner cannot close it)
        if (status.current == 1 && status.time <= (now - rocketMinipoolSettings.getMinipoolTimeout())) {
            // TimedOut
            setStatus(7);
            // Done
            return true;
        }
        // Done
        return true; 
    }


    /// @dev Sets the minipool status to staking and sends the deposit to casper
    /// @param _validatorPubkey The validator's pubkey to be submitted to the casper deposit contract for the deposit
    /// @param _validatorSignature The validator's signature to be submitted to the casper deposit contract for the deposit
    /// @param _validatorDepositDataRoot The validator's deposit data SSZ hash tree root to be submitted to the casper deposit contract for the deposit
    function stakeMinipool(bytes memory _validatorPubkey, bytes memory _validatorSignature, bytes32 _validatorDepositDataRoot) public isNodeContract(msg.sender) returns(bool) {
        // Load contracts
        rocketMinipoolSettings = RocketMinipoolSettingsInterface(getContractAddress("rocketMinipoolSettings"));
        rocketNodeSettings = RocketNodeSettingsInterface(getContractAddress("rocketNodeSettings"));
        // Get minipool settings
        uint256 launchAmount = rocketMinipoolSettings.getMinipoolLaunchAmount();
        // Check minipool is ready for staking
        require(status.current == 2, "Minipool may only be staked while in prelaunch");
        // Check node RPL balance
        if (!node.trusted) require(rplContract.balanceOf(address(this)) >= node.depositRPL, "Nodes RPL balance does not match its intended staking balance.");
        // Get and check current Rocket Pool withdrawal credentials
        bytes32 withdrawalCredentials = rocketStorage.getBytes32(keccak256(abi.encodePacked("withdrawalCredentials")));
        require(withdrawalCredentials != 0x0, "Rocket Pool withdrawal pubkey has not been initialized.");
        // Set staking properties
        staking.balanceStart = launchAmount;
        staking.validatorPubkey = _validatorPubkey;
        staking.validatorSignature = _validatorSignature;
        staking.validatorDepositDataRoot = _validatorDepositDataRoot;
        staking.withdrawalCredentials = withdrawalCredentials;
        // Set node user fee
        node.userFee = rocketNodeSettings.getFeePerc();
        // Send deposit to casper deposit contract
        casperDeposit.deposit.value(launchAmount)(_validatorPubkey, abi.encodePacked(withdrawalCredentials), _validatorSignature, _validatorDepositDataRoot);
        // Set Staking status
        setStatus(3);
        // Success
        return true;
    }


    /// @dev Sets the minipool to logged out
    function logoutMinipool() public onlyLatestContract("rocketNodeWatchtower") returns (bool) {
        // Check current status
        require(status.current == 3, "Minipool may only be logged out while staking");
        // Set LoggedOut status
        setStatus(4);
        // Success
        return true;
    }


    /// @dev Sets the minipool to withdrawn and sets its balance at withdrawal
    /// @param _withdrawalBalance The minipool's balance at withdrawal
    function withdrawMinipool(uint256 _withdrawalBalance) public onlyLatestContract("rocketNodeWatchtower") returns (bool) {
        // Check current status
        require(status.current == 4, "Minipool may only be withdrawn while logged out");
        // Set Withdrawn status
        setStatus(5);
        // Set staking end balance
        staking.balanceEnd = _withdrawalBalance;
        // Success
        return true;
    }


    /// @dev All kids outta the pool - will close and self destruct this pool if the conditions are correct
    function closePool() private {
        // Get the RP interface
        rocketPool = RocketPoolInterface(getContractAddress("rocketPool"));
        // Remove the minipool if possible
        if(rocketPool.minipoolRemove()) {
            // Send any unclaimed RPL back to the node contract
            uint256 rplBalance = rplContract.balanceOf(address(this));
            if (rplBalance > 0) { require(rplContract.transfer(node.contractAddress, rplBalance), "RPL balance transfer error."); }
            // Process fees for forfeited rewards if staking completed
            if (staking.balanceStart > 0 && staking.balanceEnd > 0) {
                // Total node fees
                uint256 nodeFeeTotal = 0;
                // Process staking withdrawals
                for (uint256 i = 0; i < stakingWithdrawalIDs.length; ++i) {
                    StakingWithdrawal memory withdrawal = stakingWithdrawals[stakingWithdrawalIDs[i]];
                    // Calculate rewards forfeited by user
                    int256 rewardsForfeited = int256(withdrawal.amount.mul(staking.balanceEnd).div(staking.balanceStart)) - int256(withdrawal.amount);
                    if (rewardsForfeited > 0) {
                        // Calculate and subtract RP and node fees from rewards
                        uint256 rpFeeAmount = uint256(rewardsForfeited).mul(withdrawal.feeRP).div(calcBase);
                        uint256 nodeFeeAmount = uint256(rewardsForfeited).mul(node.userFee).div(calcBase);
                        nodeFeeTotal = nodeFeeTotal.add(nodeFeeAmount);
                        rewardsForfeited -= int256(rpFeeAmount + nodeFeeAmount);
                        // Calculate group fee from remaining rewards and transfer
                        uint256 groupFeeAmount = uint256(rewardsForfeited).mul(withdrawal.feeGroup).div(calcBase);
                        if (groupFeeAmount > 0) { require(rethContract.transfer(withdrawal.groupFeeAddress, groupFeeAmount), "Group fee could not be transferred to group contract address"); }
                    }
                }
                // Transfer total node fees
                if (nodeFeeTotal > 0) { require(rethContract.transfer(rocketNodeContract.getRewardsAddress(), nodeFeeTotal), "Node operator fee could not be transferred to node contract address"); }
            }
            // Get Rocket Pool fee address
            rocketMinipoolSettings = RocketMinipoolSettingsInterface(getContractAddress("rocketMinipoolSettings"));
            address payable rocketPoolFeeAddress = address(uint160(rocketMinipoolSettings.getMinipoolWithdrawalFeeDepositAddress()));
            // Transfer remaining rETH balance to Rocket Pool
            uint256 rethBalance = rethContract.balanceOf(address(this));
            if (rethBalance > 0) { require(rethContract.transfer(rocketPoolFeeAddress, rethBalance), "rETH balance transfer error."); }
            // Log it
            emit PoolDestroyed(msg.sender, address(this), now);
            // Close now and send any unclaimed ether back to Rocket Pool
            selfdestruct(rocketPoolFeeAddress);
        }
    }


}
