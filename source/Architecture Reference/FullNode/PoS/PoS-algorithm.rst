******************************************************
Hitting the target with a Proof-of-Stake algorithm
******************************************************

One similarity between a Proof-of-Stake algorithm and a Proof-of-Work algorithm is that in both cases a target must be reached before the miner can create the block. In fact, the target is a large 32-byte (256 bit) number, and success is defined as producing a hash (another 32-byte number) that is less than the target. Because a lower target is more difficult to create a hash for, you can say the target and difficulty are inversely related.

Both the Bitcoin and Stratis network make adjustments to the difficulty of their algorithm. The Stratis network differs from the Bitcoin network concerning the frequency at which difficulty is adjusted. On the Stratis network, the difficulty is adjusted after every block as opposed to every 2016 blocks on the Bitcoin network. At this point, it is worth noting that the minimal increment of the block timestamp on the Stratis network is 16 seconds, so 16 seconds is the fastest time in which one block could ever be written after another.

How your stake determines your chance to hit the target
========================================================

Next, let's take a closer look at how the amount of STRAX you have staked determines your chance of being able to write the next block.

Stakes consist of Unspent Transaction Outputs (UTXOs)
-------------------------------------------------------------------

It is important to realize that whatever amount of STRAX you have staked, it is made up of one or more Unspent Transaction Outputs (UTXOs). There is no rule to this; you could be staking 1,000,000 STRAX which is just a single UTXO or 10 STRAX made up from 1000 UTXOs. While these represent somewhat extreme examples, they demonstrate that your chances to create a block are calculated from each UTXO you have staked. The target is adjusted for each UTXO depending on how much STRAX the UTXO is worth. The target is multiplied by the value of the UTXO in Satoshi to make it easier to generate a hash that is lower than it.

For example, if you have a single UTXO worth 1,000,000 STRAX, you have a single chance with a target that has been made substantially easier. Alternatively, if you have 10 UTXOs worth 100,000 STRAX, you have 10 chances, but in all cases, the target will be 10 times harder to reach than when the single UTXO was checked. **This means that whatever configuration of UTXOs you hold your STRAX stake in, your chance of being able to write a block is always the same when staking any given amount of STRAX.** The code behind this is explored in :doc:`PoS-exploring-the-code`.

.. note:: A UTXO that successfully generates a hash that is less than the adjusted target is known as the *coinstake kernel*.

.. note:: You might be wondering at this point whether it matters from a performance point of view if your stake is held in multiple UTXOs. In other words, would there be any performance advantage to combining all your UTXOs into a single UTXO. Doing the combination requires making a payment to yourself of all the STRAX you own. In the above example, checking whether the single 1,000,000 STRAX UTXO has hit the target is 10 times faster than checking if one of the 100,000 STRAX UTXOs has hit the target. However, in reality, it is highly unlikely that making 10 calculations would take a significant amount of time and affect your chances of being able to write a block.  

How an element of randomness is added to each UTXO calculation
-----------------------------------------------------------------

Adding an element of randomness to each calculation performed on a UTXO is very important; otherwise users staking larger amounts of STRAX would most likely have a permanent advantage. Without the randomness element, the result calculated for each UTXO would be the same each time. Even a user staking a small amount of STRAX could gain the advantage if the hash they produced was a freak result and very low. The randomness comes from several sources, which we will explore.

In addition to the UTXO itself, there are a couple of other random elements which are added to calculation. One of these is the timestamp for the prospective block.

Proof-of-Stake timestamps
==========================

We mentioned before that the minimal increment of the block timestamp is 16 seconds. This means that timestamps that are not divisible by 16 seconds are not valid and are rejected by the :ref:`consensus rules <consensus-rules>`. Also important is the concept of the maximum future offset, which is 16 seconds. For example, if the last timestamp was 07:00:00, it means that from 07:00:01, a timestamp of 07:00:16 is now valid.

Using Proof-of-Stake demands that the submissible timestamps are strictly spaced because the actual calculation that determines whether you can write a block is trivial on most processors. The ease of performing the check means that if the timestamp is not strictly defined, miners could begin checking their UTXOs again with a new timestamp once they have ascertained that a previous one did not reach the target for their UTXOs. The problem with a "free" timestamp when using a Proof-of-Stake approach is that processing power would again become a deciding factor in the same way as with a Proof-of-Work algorithm. So, with a Proof-of-Stake methodology, you can only check the next valid timestamp and, if you are unsuccessful, wait until that timestamp moves into the past before checking again.

Compare this with a Proof-of-Work network in which the time taken to reach the target is determined entirely by the processing power available. The difficulty of the target is adjusted to ensure the timeframe is adhered to.

An example staking timeline
-------------------------------

 .. image:: PoS-Timeline.svg
     :width: 906px
     :alt: PoS Timeline
     :align: center

The figure above shows a miner who is staking STRAX at 07:00:00. 07:00:00 is also the timestamp of the last block that was added to the blockchain. The Full Node checks the user's UTXOs to see whether they hit the target using the timestamp of 07:00:16. All of the UTXOs fail to meet the target using this timestamp. Next, timestamps of 07:00:32 and 07:00:48 are tried respectively. In both cases, the user's UTXOs fail to meet the target. Finally, a timestamp of 07:01:04 is tried, and one of the UTXOs meets the target. The miner then writes the next block.

.. note:: In the above diagram, the calculation is shown taking approximately 4 seconds. This is just a depiction, and the calculation typically takes a couple of milliseconds.   

In the above example, the most likely outcome is one of the miners writing a block with a timestamp of 07:01:04. It is unlikely that any of the miners would generate a block for the earlier timestamps: 07:00:16, 07:00:32, and 07:00:48. However, if the target had not been met for 07:01:04, then it is very likely that one miner, if not multiple miners would hit the target using a timestamp of 07:01:20. If the block is written early or late, the difficulty of the target is adjusted for the next block.  

Timing is important as it takes 10 seconds to broadcast a block to the network. The optimal time to check whether your stake can create a block with a timestamp of, for example, 07:01:04, is by 07:00:39. That would mean the new block would be propagated over the network by 07:00:49, which is the earliest time a block with a timestamp of 07:01:04 can be accepted according to the :ref:`consensus rules <consensus-rules>`. Getting a new block to the network as quickly as possible minimizes the staking orphanage rate, which is when a block is rejected because another miner created a block with the same timestamp.

 
