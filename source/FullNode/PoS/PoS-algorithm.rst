****************************************************
Test Title
****************************************************

One similarity between the proof of stake algorithm and the proof of work algorithm is that in both cases a target must be reached before the miner can write the block. In fact, the target is a large 32 byte (256 bit) number and success is defined as producing a hash (another 32 byte number) that is less than the target. Because a lower target is more difficult to create a hash for, you can say the target and difficulty are inversely related.

Both the Bitcoin and Stratis network make adjustments to the difficulty of their algorithm. The Stratis network differs from the Bitcoin network converning the frequency at which difficulty is adjusted. On the Stratis network the difficulty is adjusted after every block as opposed to every 2016 blocks on the Bitcoin network. At this point it is worth noting that the minimal increment of the block timestamp on the Stratis network is 16 seconds, so 16 seconds is the fastest time in which one block could ever be written after another.

Next, let's take a closer look at how having more Strat staked increases your chance of being able to write the next block.

Firstly, it's important to realise that whatever amount of Strat you have staked, it is made up of one or more Unspent Transaction Outputs (UTXOs). There is no rule to this; you could be staking 1,000,000 Strat which is just a single UTXO or 10 Strat made up from 1000 UTXOs. While these represent somewhat extreme examples, they demonstrate that your chances to create a block are calculated from each UTXO you have staked.

Secondly, adding an element of randomness to each calculation performed on a UTXO is very important; otherwise user's staking larger amounts of Strat would most likely have a permanent advantage. Without the randomness element, the result calculated for each UTXO would be the same each time. Even a user staking a small amount of Strat could gain the advantage if the hash they produced was a freak result and very low. The randomness comes from several sources, which we will explore.

We mentioned before that the minimal increment of the block timestamp is 16 seconds. This means that timestamps that are not divisable by 16 seconds are not valid and are rejected by the consensus rules. Also important is the concept of the maximum future offset, which is 16 seconds. For example, it the last timestamp was 07:00:00, it means that from 07:00:01, a timestamp of 07:00:16 is now valid.

Using proof of stake demands that the submissable timestamps are strictly spaced because the actual calculation that determines whether you can write a block is trivial on most processors. The ease of performing the check means that if the timestamp is not strictly defined, miners could begin checking their UTXOs again with a new timestamp once they have ascertained that a previous one did not reach the target for their UTXOs. The problem with a "free" timestamp when using a proof of stake approach is that processing power again becomes a deciding factor in the same way as with a proof of work algorithm. So with proof of stake, you can only check the next valid timestamp and, if you are unsuccesful, wait until that timestamp moves into the past before checking again.

The length of time to reach a target on a proof of work network is determined entirely by the processing power available with the variable difficulty used to ensure a timeframe is adhered to.

 .. image:: Sidechain_Withdrawal.svg
     :width: 906px
     :alt: Sidechains Withdrawal
     :align: center

The diagram above 
