####################
Stratis Cold-Staking
####################

Staking is essential to the Proof of Stake consensus mechanism used on
the STRAX Blockchain. Blocks are verified and mined by network
participants who are willing to set aside a portion of their tokens,
effectively freezing them so they cannot be spent. In return, these
participants are granted the right to verify transactions and earn
bonuses paid in tokens. The larger the number of tokens a participant is
willing to stake, the greater the chance they will be selected to mine
the next block and earn the associated reward.

While tokens are being staked, they are frozen in a wallet. If the
wallet is connected to the blockchain network, it is referred to as a
hot wallet. Such an arrangement incurs a level of risk as the wallet is
effectively exposed to the internet and therefore susceptible to attack.
Conversely, if the wallet stores tokens offline (as is possible in the
Stratis wallet, a hardware wallet, or even a paper wallet), it is known
as a cold wallet and the staking process is referred to as "Cold
Staking". Cold Staking is inherently safer than staking in a hot wallet
since tokens are not susceptible to online attacks while held in an
offline wallet.

**Pre-Requisites**

To produce blocks on the Stratis network, a miner must be online with a
node running and have their wallet open. The chances of earning a reward
for staking increases linearly with the number of tokens staked, which
means the most successful miners are likely to have large numbers of
tokens frozen in their wallets. This represents a risk if the tokens are
held in a hot wallet which is compromised. For this reason, Stratis
permits Cold Staking where the miner still needs to be online with a
node running and their hot wallet open, but the tokens used for staking
can be safely stored offline in cold storage. Their hot wallet need not
hold any significant number of tokens or may be empty.

Stratis cold storage is implemented on the node, with the connected
wallet only using the node's interfaces. The hot wallet should be an HD
(Hierarchical Deterministic) Wallet and, initially, this must be the
Stratis wallet which comprises a GUI for controlling the Cold Staking
process. Also, a Cold Staking user needs to have an offline cold wallet
to store the staked tokens.

Guides contained within this section will relate to how Cold-Staking can be configured within Stratis Wallets and also in a headless manner.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   STRAX Wallet Cold-Staking <STRAX Wallet/Cold-Staking-Guide>
   Headless Cold-Staking <Headless/cold-staking-headless-setup>
   Docker Example <Headless - Docker/cold-staking-headless-setup>