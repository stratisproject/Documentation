****************************************************
Proof-of-Stake (PoS) implementation
****************************************************

The Stratis Full Node uses a Proof-of-Stake (PoS) algorithm in its consensus protocol. This means that miners must "stake" STRAX to gain the right to create blocks. The more STRAX that a miner stakes, the greater their chance of being able to write a block. Staking STRAX is a simple process, which anyone who has a wallet and owns some STRAX can do. As you will learn, the Full Node randomizes block creator selection to ensure that the individual staking the most STRAX does not have a permanent advantage.

Proof-of-Stake algorithms are known to be more energy efficient than `Proof-of-Work <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch10.asciidoc#proof-of-work-algorithm>`_ algorithms, but why exactly is this? In fact, it is the vested interest of miners staking on a Proof-of-Stake blockchain that allows the different approach to be taken. Contrast this with a Proof-of-Work blockchain, such as Bitcoin, where a miner may hold onto comparatively small amounts of the currency; here the miner's primary interest in the blockchain is as a source of profit. The difficulty inherent in solving a Proof-of-Work algorithm reflects the need to check the miner's sincerity when they earn the right to write a block. The computing power a miner must expend effectively counteracts any selfish intent to write a block containing false information. After all, if the block gets rejected by the other nodes, the expenditure is lost.    

On a Proof-of-Stake blockchain, those staking the most coins are more likely to get a chance to create blocks and are the least likely to want to negatively affect the blockchain. The more coins a miner stakes, the greater the interest of the miner in maintaining the blockchain. A Proof-of-Stake blockchain does away with the energy inefficient check on bad intention via a methodology that encourages a concern about the blockchain from the miners themselves. Under Proof-of-Stake, miners only need to check their staked coins to see whether they can write a block rather than systematically trying to solve a puzzle using all the computing power they can muster.

Ultimately, you can, by staking, gain the same advantages when it comes to writing blocks as you would if you spent the funds on processing power. However, unlike on a Proof-of-Work blockchain, the money is not spent; instead it is held with both earning potential and the option to trade up when the value of the token increases.     

The Stratis network and the Bitcoin network differ with respect to "target spacing", which is the interval at which blocks are written. This is an effect of the difference in their consensus protocol. On the bitcoin network, blocks are written every 10 minutes, and on the Stratis blockchain, blocks are written every 64 seconds. As you will learn, the processing power a miner uses when checking if their stake will allow them to create a block is, in most cases, trivial. This contributes to a drastic reduction in the time needed to write blocks on the Stratis network.   

The purpose of this document is to detail exactly how the Proof-of-Stake algorithm is implemented on the Stratis blockchain.

The later part of this document dives into the code and here a knowledge of C# is assumed. 

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   PoS-algorithm
   PoS-exploring-the-code
