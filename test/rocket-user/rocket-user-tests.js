import { printTitle, assertThrows } from '../utils';
import { RocketSettings, RocketPool } from '../artifacts';
import { scenarioIncrementEpoch, scenarioIncrementDynasty, scenarioCreateValidationContract } from '../casper/casper-scenarios';
import { scenarioRegisterNode, scenarioNodeCheckin } from '../rocket-node/rocket-node-scenarios';
import { scenarioDeposit, scenarioRegisterWithdrawalAddress, scenarioWithdrawDeposit } from './rocket-user-scenarios';

export default function({owner}) {

    contract('RocketUser', async (accounts) => {


        /**
         * Config
         */

        // User addresses
        const userFirst = accounts[1];
        const userSecond = accounts[2];
        const userThird = accounts[3];
        const userSecondBackupAddress = accounts[4];

        // Node addresses
        const nodeFirst = accounts[8];
        const nodeSecond = accounts[9];

        // Gas costs
        const rocketDepositGas = 4800000;
        const rocketWithdrawalGas = 1450000;

        // Minipools
        let miniPools = {};


        /**
         * User deposits
         */
        describe('Deposits', async () => {


            // Contract dependencies
            let rocketSettings;
            before(async () => {
                rocketSettings = await RocketSettings.deployed();
            });


            // Send ether to Rocket pool with just less than the min amount required to launch a minipool with no specified 3rd party user partner
            it(printTitle('userFirst', 'sends ether to RP, create first minipool, registers user with pool'), async () => {

                // Get the amount of ether to send - enough to create a minipool but not launch it
                const minEtherRequired = await rocketSettings.getMiniPoolLaunchAmount.call();
                const sendAmount = parseInt(minEtherRequired.valueOf()) - parseInt(web3.toWei('2', 'ether'));

                // Deposit ether
                let miniPool = await scenarioDeposit({
                    stakingTimeID: 'short',
                    fromAddress: userFirst,
                    depositAmount: sendAmount,
                    gas: rocketDepositGas,
                });

                // Set first minipool
                miniPools.first = miniPool;

            });


            // Have the same initial user send an deposit again, to trigger the pool to go into countdown
            it(printTitle('userFirst', 'sends ether to RP again, their balance updates, first minipool remains accepting deposits and only 1 reg user'), async () => {

                // Get the amount of ether to send - still not enough to launch the minipool
                const sendAmount = parseInt(web3.toWei('1', 'ether').valueOf());

                // Deposit ether
                await scenarioDeposit({
                    stakingTimeID: 'short',
                    fromAddress: userFirst,
                    depositAmount: sendAmount,
                    gas: rocketDepositGas,
                });

            });


            // Have a new user send an deposit, to trigger the pool to go into countdown
            it(printTitle('userSecond', 'sends ether to RP, first minipool status changes to countdown and only 2 reg users'), async () => {

                // Get the amount of ether to send - enough to launch the minipool
                let sendAmount = parseInt(web3.toWei('5', 'ether').valueOf());

                // Deposit ether
                await scenarioDeposit({
                    stakingTimeID: 'short',
                    fromAddress: userSecond,
                    depositAmount: sendAmount,
                    gas: rocketDepositGas,
                });

            });


            // Have a new user send a deposit to create a second minipool and trigger it to go into countdown
            it(printTitle('userThird', 'sends a lot of ether to RP, creates second minipool, registers user with pool and sets status of minipool to countdown'), async () => {

                // Get the amount of ether to send - enough to launch a minipool
                const minEtherRequired = await rocketSettings.getMiniPoolLaunchAmount.call();
                const sendAmount = parseInt(minEtherRequired.valueOf());

                // Deposit ether
                let miniPool = await scenarioDeposit({
                    stakingTimeID: 'short',
                    fromAddress: userThird,
                    depositAmount: sendAmount,
                    gas: rocketDepositGas,
                });

                // Set second minipool
                miniPools.second = miniPool;

            });


        });


        /**
         * User backup withdrawal addresses
         */
        describe('Withdrawal Address', async () => {


            // Second user sets a backup withdrawal address
            it(printTitle('userSecond', 'registers a backup withdrawal address on their deposit while minipool is in countdown'), async () => {
                await scenarioRegisterWithdrawalAddress({
                    withdrawalAddress: userSecondBackupAddress,
                    miniPool: miniPools.first,
                    fromAddress: userSecond,
                    gas: 550000,
                });
            });


        });


        /**
         * User withdrawals
         */
        describe('Withdrawals', async () => {


            // Contract dependencies
            let rocketSettings;
            let rocketPool;
            before(async () => {
                rocketSettings = await RocketSettings.deployed();
                rocketPool = await RocketPool.deployed();
            });


            // Initialise nodes and checkin to launch minipools
            before(async() => {

                // Register nodes
                let nodeFirstValCodeAddress = await scenarioCreateValidationContract({fromAddress: nodeFirst});
                let nodeSecondValCodeAddress = await scenarioCreateValidationContract({fromAddress: nodeSecond});
                await scenarioRegisterNode({
                    nodeAddress: nodeFirst,
                    valCodeAddress: nodeFirstValCodeAddress,
                    providerID: 'aws',
                    subnetID: 'nvirginia',
                    instanceID: 'i-1234567890abcdef5',
                    regionID: 'usa-east',
                    fromAddress: owner,
                    gas: 1600000
                });
                await scenarioRegisterNode({
                    nodeAddress: nodeSecond,
                    valCodeAddress: nodeSecondValCodeAddress,
                    providerID: 'rackspace',
                    subnetID: 'ohio',
                    instanceID: '4325',
                    regionID: 'usa-east',
                    fromAddress: owner,
                    gas: 1600000
                });

                // Set minipool countdown time
                await rocketSettings.setMiniPoolCountDownTime(0, {from: web3.eth.coinbase, gas: 500000});

                // Perform checkins
                await scenarioNodeCheckin({
                    averageLoad: web3.toWei('0.5', 'ether'),
                    fromAddress: nodeFirst,
                });
                await scenarioNodeCheckin({
                    averageLoad: web3.toWei('0.5', 'ether'),
                    fromAddress: nodeSecond,
                });

            });


            // First user with deposit staking in minipool attempts to withdraw deposit before staking has finished
            it(printTitle('userFirst', 'user fails to withdraw deposit while minipool is staking'), async () => {
                await assertThrows(scenarioWithdrawDeposit({
                    miniPool: miniPools.first,
                    withdrawalAmount: 0,
                    fromAddress: userFirst,
                    feeAccountAddress: owner,
                    gas: rocketWithdrawalGas,
                }));
            });


            // First and second minipools logged out from Casper
            it(printTitle('---------', 'first and second minipools logged out from Casper'), async () => {

                // Set minipool staking durations
                await rocketPool.setPoolStakingDuration(miniPools.first.address, 0, {from: owner, gas: 150000});
                await rocketPool.setPoolStakingDuration(miniPools.second.address, 0, {from: owner, gas: 150000});

                // Perform checkins
                await scenarioNodeCheckin({
                    averageLoad: web3.toWei('0.5', 'ether'),
                    fromAddress: nodeFirst,
                });
                await scenarioNodeCheckin({
                    averageLoad: web3.toWei('0.5', 'ether'),
                    fromAddress: nodeSecond,
                });

                // Step casper forward
                await scenarioIncrementEpoch(owner);
                await scenarioIncrementEpoch(owner);
                await scenarioIncrementDynasty(owner);
                await scenarioIncrementEpoch(owner);
                await scenarioIncrementDynasty(owner);
                await scenarioIncrementEpoch(owner);
                await scenarioIncrementDynasty(owner);
                await scenarioIncrementEpoch(owner);
                await scenarioIncrementEpoch(owner);

                // Perform checkins
                await scenarioNodeCheckin({
                    averageLoad: web3.toWei('0.5', 'ether'),
                    fromAddress: nodeFirst,
                });
                await scenarioNodeCheckin({
                    averageLoad: web3.toWei('0.5', 'ether'),
                    fromAddress: nodeSecond,
                });

            });


            // First user withdraws their deposit + rewards and pays Rocket Pools fee
            it(printTitle('userFirst', 'withdraws their deposit + Casper rewards from the minipool and pays their fee'), async () => {
                await scenarioWithdrawDeposit({
                    miniPool: miniPools.first,
                    withdrawalAmount: 0,
                    fromAddress: userFirst,
                    feeAccountAddress: owner,
                    gas: rocketWithdrawalGas,
                });
            });


            // Second user attempts to withdraw using their backup address before the time limit to do so is allowed (3 months by default)
            it(printTitle('userSecond', 'fails to withdraw using their backup address before the time limit to do so is allowed'), async () => {
                await assertThrows(scenarioWithdrawDeposit({
                    miniPool: miniPools.first,
                    withdrawalAmount: 0,
                    fromAddress: userSecondBackupAddress,
                    depositFromAddress: userSecond,
                    feeAccountAddress: owner,
                    gas: rocketWithdrawalGas,
                }));
            });


            // Update first minipool
            it(printTitle('---------', 'settings BackupCollectTime changed to 0 which will allow the user to withdraw via their backup address'), async () => {

                // Set the backup withdrawal period to 0 to allow the user to withdraw using their backup address
                let result = await rocketSettings.setMiniPoolBackupCollectTime(0, {from: owner, gas: 150000});
                // TODO: check backup withdrawal period, dummy test for now

            });


            // First user attempts to withdraw again
            it(printTitle('userFirst', "fails to withdraw again from the pool as they've already completed withdrawal"), async () => {
                await assertThrows(scenarioWithdrawDeposit({
                    miniPool: miniPools.first,
                    withdrawalAmount: 0,
                    fromAddress: userFirst,
                    feeAccountAddress: owner,
                    gas: rocketWithdrawalGas,
                }));
            });


            // Second user withdraws their deposit + rewards and pays Rocket Pools fee, minipool closes
            it(printTitle('userSecond', 'withdraws their deposit + Casper rewards using their backup address from the minipool, pays their fee and the pool closes'), async () => {
                await scenarioWithdrawDeposit({
                    miniPool: miniPools.first,
                    withdrawalAmount: 0,
                    fromAddress: userSecondBackupAddress,
                    depositFromAddress: userSecond,
                    feeAccountAddress: owner,
                    gas: rocketWithdrawalGas,
                });
            });


        });


    });

}
