********************************************************************
Exploring the code which implements Proof-of-Stake on the Full Node
********************************************************************

There are two classes that implement Proof-of-Stake: ``PosMinting`` and ``StakeValidator``. The ``PosMinting`` class implements the ``IPosMinting`` interface and the ``StakeValidator`` class implements the ``IStakeValidator`` interface. The classes and interfaces are documented, and you can find both the code and documentation in the following files: `PosMinting.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/Staking/PosMinting.cs>`_, `IPosMinting.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/Interfaces/IPosMinting.cs>`_, `StakeValidator.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Consensus/StakeValidator.cs>`_, and `IStakeValidator.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Consensus/Interfaces/IStakeValidator.cs>`_. An instance of the ``PosMinting`` class is held by the ``MiningFeature`` object (`MiningFeature.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/MiningFeature.cs>`_). This ``PosMinting`` object holds an instance of the ``StakeValidator`` class.

Within the PoSMinting and StakeValidator instances, the code takes the following path when checking to see if a miner's staked coins (UTXOs) hit the target:

1. ``PosMinting.Stake()``
2. ``PosMinting.GenerateBlocksAsync()``
3. ``PosMinting.StakeAndSignBlockAsync()``
4. ``PosMinting.CreateCoinstakeAsync()``
5. ``PosMinting.CoinstakeWorker()``
6. ``StakeValidator.CheckKernal()``
7. ``StakeValidator.CheckStakeKernelHash()``

Staking begins with a call to ``MiningFeature.StartStaking()``, which in turn calls ``PosMinting.Stake()``. ``PosMinting.Stake()`` operates by running a staking loop. The loop attempts, by calling ``PosMinting.GenerateBlocksAsync()`` as an asynchronous task, to generate blocks by finding the kernal for them. Three notable things that happen within GenerateBlocksAsync() are: the generation of the coinstake timestamp, the gathering of the UTXOs that make up the miner's stake, and the creation of the block template holding the transactions for the next block the miner will attempt to mine.

The timestamp is one of the pieces of information which is later used to randomize each staking UTXO's attempt to hit the target. You can see how the rule which states that the timestamp has to increment 16 seconds at a time is implemented here:

.. sourcecode:: csharp

  uint coinstakeTimestamp = (uint)this.dateTimeProvider.GetAdjustedTimeAsUnixTimestamp() & ~PosTimeMaskRule.StakeTimestampMask;

The attempt to create the block progresses further via a call to ``PosMinting.StakeAndSignBlockAsync()``. Using the coinstake timestamp generated previously, the coinstake transaction is created to use in the event the miner is able to write the block. The Full Node now checks to see if the coinstake hash can be calculated from the miner's staked UTXOs by making a call to ``PosMinting.CreateCoinstakeAsync()``. If the call to ``CreateCoinstakeAsync()`` is sucessful, three things happen:

1. The coinstake transaction is added to the new block.
2. Any transactions within the block which have a date further in the future than the coinstake transaction are removed.
3. The miner signs the block.

How workers calculate a kernal for each UTXO
============================================

Now let's take a closer look at ``CreateCoinstakeAsync()``. This function creates "workers" to check the UTXOs. The number of workers created depends on the number of UTXOs that need to be checked. Each worker checks their UTXOs via a call to ``PosMinting.CoinstakeWorker()``. A call is then made to ``StakeValidator.CheckKernal()`` to check each UTXO in turn and see if any of them can be the coinstake kernal. Some checks are made on the UTXO and then an attempt is made to calculate a hash which meets the target. This is done within ``CheckStakeKernelHash()``. Exploring the code within this function gives an excellent opportunity the see exactly how the hash is calculated and how the target is reduced (made easier) according to value of the UTXO.

First, let's look at the formulae which checks if a coinstake hash meets the target and can be used for the next block:

::

  Hash256("Stake Modifier V2" + "UTXO Transaction Timestamp" + "UTXO Transaction Hash" + "UTXO Output Number" + "Coinstake Transaction Time") < Target * Weight
  

+--------------------------------+-----------------------------------------------------------------------------------------------------------+
|Parameter                       |Description                                                                                                |
+================================+===========================================================================================================+
|Stake Modifier V2               |Taken from the best chain tip. Effectively links the new block to the block at the tip of the best chain.  |
+--------------------------------+-----------------------------------------------------------------------------------------------------------+
|UTXO Transaction Timestamp      |The timestamp of the transaction that the UTXO is from.                                                    |
+--------------------------------+-----------------------------------------------------------------------------------------------------------+
|UTXO Transaction Hash           |A hash of the transaction that the UTXO is from.                                                           |
+--------------------------------+-----------------------------------------------------------------------------------------------------------+
|UTXO Output Number              |The index of the UTXO in the transaction it is from.                                                       |
+--------------------------------+-----------------------------------------------------------------------------------------------------------+
|Coinstake Transaction Timestamp |The timestamp for the coinstake transaction of the block the miner is trying to mine.                      |
+--------------------------------+-----------------------------------------------------------------------------------------------------------+

The Stake Modifier V2 comes from the tip of best chain of block headers since the genesis block (that the node is aware of), This block currently at the tip is potentially the *previous block* to the one the miner is trying to write. Stake Modifier V2 is calculated as follows:

::

  Hash256("Hash of transaction the coinstake kernel is from" + "Previous Block Stake Modifier V2")
  
So, you can see how the Stake Modifier V2 ties each block into the transaction containing the coinstake kernal and forms a "link" right back to the genesis block.

The main idea behind including the other parameters is to scramble the value which is going to be hashed so no miner tries to hash the same value. If they hash the same value at roughly the same time, one will end up being rejected even though they both hit the target. So which parameters, in particluar, prevent this? Other miners mining at this time will use the same Coinstake Transaction Timestamp, and there is also a small chance they will have the same UTXO Transaction Timestamp. This would be the case if they are staking a UTXO from a transaction and another miner also has a UTXO from that transaction, which they are staking. However, no miner will have the same combination of UTXO Transaction Hash and UTXO Output Number so this is what signicantly reduces the chance of two miners hitting the target at the same time.       


Looking at the kernal calculation in code
=========================================

We are now going to look at how this translates into code, which you can find in `StakeValidator.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Consensus/StakeValidator.cs>`_. Firstly, the unadjusted target is obtained from the header bits:

::

  BigInteger target = new Target(headerBits).ToBigInteger();

Next, the value of UTXO is obtained in Satoshi, and the target is multiplied by the UTXO value to give a weighted target.

::

  long valueIn = stakingCoins.Outputs[prevout.N].Value.Satoshi;
  BigInteger weight = BigInteger.ValueOf(valueIn);
  BigInteger weightedTarget = target.Multiply(weight);

Hitting the target involves generating a hash that is lower than the target, and you can see in the code that the larger the value of the UTXO, the more chance you have of hitting the target. In other words, the larger the target, the more the target is weighted in your favour.

Stake Modifier V2 is then retrieved for the previous block:
 
::

  uint256 stakeModifierV2 = prevBlockStake.StakeModifierV2;

The hash for the UTXO being checked is calculated:

::

  using (var ms = new MemoryStream()
  {
      var serializer = new BitcoinStream(ms, true);
      serializer.ReadWrite(stakeModifierV2);
      serializer.ReadWrite(stakingCoins.Time);
      serializer.ReadWrite(prevout.Hash);
      serializer.ReadWrite(prevout.N);
      serializer.ReadWrite(transactionTime);

      context.HashProofOfStake = Hashes.Hash256(ms.ToArray());
  }

In the code excerpt above, the parameters which are summed and hashed are added to the ``BitcoinStream`` object in the order they are listed in the table; the UTXO Transaction Timestamp is held by ``stakingCoins.Time``, UTXO Transaction Hash is held by ``prevout.Hash``, and so on.

Finally, the coinstake hash is checked against the target:

::

  // Now check if proof-of-stake hash meets target protocol.
  var hashProofOfStakeTarget = new BigInteger(1, context.HashProofOfStake.ToBytes(false));
  if (hashProofOfStakeTarget.CompareTo(weightedTarget) > 0)
  {
      this.logger.LogTrace("(-)[TARGET_MISSED]");
      ConsensusErrors.StakeHashInvalidTarget.Throw();
  }

Failure to meet the target is handled by an exception, so the code directly after the call to ``StakeValidator.CheckKernal()`` in ``PosMinting.CoinstakeWorker()`` is executed in the event that the target was met. The worker then stops work and the new block can be prepared.











