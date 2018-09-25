****************************************************
The Stratis Full Node Proof of Stake Implementation
****************************************************

The Stratis Full Node uses a proof of stake algorithm in its consensus protocol. The means that miners must "stake" Strat to gain the right to create blocks. The more Strat that a miner stakes, the greater their chance of being able to create a block. Staking Strat is a simple process, which anyone who has a wallet and owns some Strat can do. As you will learn, the Full Node randomizes block creator selection to an extent. This ensures that the individual staking the most Strat does not have a permanent advantage.

Proof of stake algorithms are known to be more energy efficient than proof of stake algorithms but why exactly is this? In fact, it is the vested interest of miners staking on a proof of stake blockchain that allows a different approach to be taken to consensus. Contrast this with a proof of work blockchain, such as Bitcoin, where it is possible that the miner owns none of the currency and is only seeking to maximize their own profit. Here, the difficulty inherant in solving proof of work algorithm reflects the need to check the miner's sincerity when they are able to write a block. The computing power a miner must expend works to counteract the selfish intent to write a block containing false information. After all, if the block gets rejected by the other nodes, the expenditure is lost.    

On a proof of stake blockchain, those staking the most coins are more likely to get a chance to create blocks and are the least likely to want negatively affect the blockchain. It is a case of the more coins staked, the greater the vested interest of the miner. This allows a proof of stake blockcahin to do away with the energy ineffecient check on bad intention via a methodology that encourages a concern about the blockchain from the miners themselves. Under proof of stake, miners only need to check their staked coins to see whether they can write a block rather than systematically trying to solve a puzzle using all the computing power they can muster.

Ultimately, you can, by staking, gain the same advantages when it comes to writing blocks as you would if you spent on processing power. However, unlike on a proof of work blockchain, the money is not spent; instead it is held with both earning potential and the option to trade up when the value of the token increases.     

The Stratis network and the Bitcoin network differ with respect to "target spacing", which is the interval at which blocks are written. This is an effect of the difference in their consensus protocol. On the bitcoin network, blocks are written every 10 minutes, and on the Stratis blockchain, blocks are written every 64 seconds. As you will learn, the processign power a miner uses when checking if their  stake will allow them to create a block is, in most cases, trivial. This contributes to a drastic reduction in the time needed to write blocks on the Stratis network.   

The purpose of this document is to detail exactly how the proof of stake algorithm is implemented on the Stratis blockchain.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   PoS-algorithm
