****************************************************
Cold Staking
****************************************************
   
Introduction - what is Cold Staking?
===================================================================
Staking is essential to the Proof of Stake consensus mechanism used on the Stratis mainchain. Blocks are verified and mined by network participants who are willing to set aside a portion of their coins, effectively freezing them so they cannot be spent. In return, these participants are granted the right to verify transactions and earn bonuses paid in coins. The larger the number of coins a participant is willing to stake, the greater the chance that they will be chosen to mine the next block and earn the associated bonus.

While coins are being staked, they are frozen in a wallet. If the wallet is connected to the blockchain network it is referred to as a hot wallet and such an arrangement incurs some risk since the wallet is effectively online and therefore susceptible to attack. Conversely, if the wallet stores coins off-line (as is possible in the Stratis Core wallet, or a hardware wallet, or even a paper wallet), it is known as a cold wallet and the staking process is referred to as "Cold Staking". Cold Staking is inherently safer than staking in an online hot wallet since coins are not susceptible to online attack while they are held in an off-line wallet.

Motivation - why get involved in Cold Staking?
===================================================================
Staking (using a hot wallet, or a cold wallet) enables coin holders to earn rewards in return for freezing their staked coins so they cannot be otherwise used while they are being staked. Cold Staking has the additional benefit that staked coins are frozen, off-line, where they are not susceptible to being stolen via an on-line attack, 

The average reward you might expect for staking is around 1.5-2% of the value of coins staked, however:

1. This is only an average (miners are competing to be the validating node, so they cannot be certain of earning the reward every time; although the average time between rewards is likely to be more consistnet over long periods, it may be quite inaccurate over short periods), and
2. This assumes you are staking all the time, 24x7 (if you stake less frequently, then the rewards you can expect will be correspondingly less).

This percentage can be reduced by the incidence of orphaned blocks. An orphan occurs when two staking nodes create a new block at almost the same time. If the block information is not passed on quickly enough, then someone else’s staking wallet may receive the staking reward for that block, and you will receive nothing (in this case, your block is referred to as an orphan). Steps you can take to try to reduce the number of orphaned blocks include:

* Make sure you have 16 connections. If you have fewer than three connections your chance of receiving orphans may be increased.
* If your computer is running very slowly it can increase the number of orphans you receive. The more coins you collect the more important it is to get things running efficiently so that blocks get solved and reported on the network as soon as possible.
* Older wallets with many transactions may start to slow down. By sending your coins to a new address and importing that address into your wallet you can “start afresh” and should receive fewer orphaned blocks.

Pre-requisites for Cold Staking with Stratis
===================================================================
To produce blocks on the Stratis network, a miner has to be on-line with a node running and have their wallet open. The chances of earning a reward for staking increases linearly with the number of coins staked, which means the most successful miners are likely to have large numbers of coins frozen in their wallets. This represents a risk if the coins are held in a hot wallet which is compromised. For this reason, Stratis permits Cold Staking where the miner still needs to be on-line with a node running and their hot wallet open, but the coins used for staking can be safely stored off-line in “cold storage”. Their hot wallet need not hold any significant number of coins, or may be completely empty.

Stratis cold storage is implemented on the node, with the connected wallet only using interfaces provided by the node. The hot wallet should be a HD (Hierarchical Deterministic) wallet and, initially, this must be the Stratis Core wallet which comprises a GUI for controlling the Cold Staking process. In addition, a Cold Staking user needs to have an off-line cold wallet in which to store the staked coins.

Stepping through the Stratis Cold Staking process
===================================================================
Cold Staking is controlled via the GUI for the Stratis Core hot wallet:

* To start Cold Staking the user first needs to create a special “coinstake” transaction that moves coins to their cold wallet for the purpose of Cold Staking and also makes the hot wallet eligible for mining.
* Cold Staking can be cancelled at any time, simply by spending (i.e. transferring) the coins they have frozen for Cold Staking. Any movement of these coins from cold storage back to their hot wallet, or to any other address, will automatically cancel Cold Staking for those coins.

Once Cold Staking has been initiated, the hot wallet starts tracking the resulting UTXO (Unspent Transaction Output) from the cold wallet as if were its own. This serves two purposes:

* Having created the coinstake transaction using this UTXO it needs to track the UTXO, and
* In the event the user cancels Cold Staking by moving coins out of the cold wallet, the hot wallet must be ready to detect the UTXO that signals this movement.

.. note::  Once you have earned a reward for staking, there will be a delay around an hour before it is spenable. This is because the reward transaction needs to be included in 50 blocks before it can be sent to another address, i.e. spent. Since block times are 64 seconds on average, it will be almost an hour before a reward can be spent.

Cold wallet requirements
===================================================================
To support Cold Staking, the cold wallet needs to be able to recognize the coinstake transaction process. When such a transaction is detected on the chain, this allows the cold wallet to manipulate new coins and it informs the user about this transaction in a way that clearly distinguishes this transaction from normal payments to this wallet. The user must be fully aware that such a transaction is specifically intended to set up Cold Staking setup, so that they are not misled into thinking that the transaction was provided as a payment from another party. This distinction is necessary to prevent attackers from sending coins as payment for goods while keeping staking rights for themselves. While the wallet will be in full control of any subsequent movement of the coins, the delegation of staking rights must also be carefully managed to ensure it does not become a security risk.

The cold wallet should not mix coins for Cold Staking with other coins, since any movement of Cold Staking setup coins cancels the setup. The wallet interface should provide the only mechanism for cancelling Cold Staking and merging the cold staked coins with other coins in the wallet.

Roll-out of Cold Staking
===================================================================
Cold Staking will be implemented via a soft fork in the Stratis code. This should not cause any problems for miners who decide not to upgrade, although if someone attempts to spend a Cold Staking transaction that a non-upgraded node flags as invalid, this could result in a delay in validation. To mitigate this problem, the Cold Staking fork will modify the Stratis Full Node by inserting a signal (known as BIP9) into any blocks they produce to indicate the Full Node version they are running. The Cold Staking feature will remain disabled until 90% of the nodes in the network have been upgraded, at which point Cold Staking will be activated and become available for anyone wishing to participate.

Future plans for Cold Staking
===================================================================
Although Cold Staking will initially only be possible using Stratis Core as the hot wallet, we plan to make it possible to run Cold Staking with other hot wallet options.

It is also planned to support a second method of enabling Cold Staking in which, instead of starting with the coins you wish to stake in your hot wallet and creating a Cold Staking transaction to move them to your cold wallet, it will be possible to nominate coins already stored in a hardware wallet for Cold Staking and without the need to move them. This will be done by allowing the hardware wallet directly to sign the special transaction needed to initiate Cold Staking.
