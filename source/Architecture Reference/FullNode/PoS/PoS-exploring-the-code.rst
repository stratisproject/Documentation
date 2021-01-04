********************************************************************
Exploring the Proof-of-Stake code
********************************************************************

There are two classes that implement Proof-of-Stake: `PosMinting <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/Staking/PosMinting.cs>`_ and `StakeValidator <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Consensus/StakeValidator.cs>`_. The ``PosMinting`` class implements the `IPosMinting <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/Interfaces/IPosMinting.cs>`_ interface and the ``StakeValidator`` class implements the `IStakeValidator <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Consensus/Interfaces/IStakeValidator.cs>`_ interface. `MiningFeature <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/MiningFeature.cs>`_ holds a reference to a ``PosMinting`` singleton, which references a ``StakeValidator`` singleton.

Within the ``PoSMinting`` and ``StakeValidator`` singletons, the code takes the following path when checking to see if a miner's staked coins (UTXOs) hit the target:

1. ``PosMinting.Stake()``
2. ``PosMinting.GenerateBlocksAsync()``
3. ``PosMinting.StakeAndSignBlockAsync()``
4. ``PosMinting.CreateCoinstakeAsync()``
5. ``PosMinting.CoinstakeWorker()``
6. ``StakeValidator.CheckKernel()``
7. ``StakeValidator.CheckStakeKernelHash()``

Staking begins with a call to ``MiningFeature.StartStaking()``, which in turn calls ``PosMinting.Stake()``. ``PosMinting.Stake()`` operates by running a staking loop. The loop attempts, by calling ``PosMinting.GenerateBlocksAsync()`` as an asynchronous task, to create a block by finding a coinstake kernel for the block. Three notable things that happen within GenerateBlocksAsync() are: the generation of the coinstake timestamp, the gathering of the UTXOs that make up the miner's stake, and the creation of a block template holding the transactions for the block the miner is attempting to mine.

The timestamp is one of the pieces of information which is later used to randomize each staked UTXO's attempt to hit the target. You can see how the rule which states that the timestamp has to increment 16 seconds at a time is implemented here:

.. sourcecode:: csharp

  uint coinstakeTimestamp = (uint)this.dateTimeProvider.GetAdjustedTimeAsUnixTimestamp() & ~PosTimeMaskRule.StakeTimestampMask;

The attempt to create the block progresses further via a call to ``PosMinting.StakeAndSignBlockAsync()``. Using the coinstake timestamp generated previously, a coinstake transaction is created to use if the miner turns out to be staking a valid coinstake kernel. The Full Node now checks to see if the coinstake hash can be calculated from any of the miner's staked UTXOs by making a call to ``PosMinting.CreateCoinstakeAsync()``. If the call to ``CreateCoinstakeAsync()`` is successful, three things happen:

1. The coinstake transaction (which provides a reference to the coinstake kernel) is added to the new block.
2. Any transactions within the block which have a date further in the future than the coinstake transaction are removed.
3. The miner signs the block.

.. _coinstake-tx-definition:

What defines a coinstake transaction?
======================================

`Transaction.IsCoinStake() <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/NBitcoin/Transaction.cs>`_ provides a useful definition of a coinstake transaction:

::

    public bool IsCoinStake
    {
        get
        {
            // ppcoin: the coin stake transaction is marked with the first output empty
            return this.Inputs.Any()
                && !this.Inputs.First().PrevOut.IsNull
                && this.Outputs.Count() >= 2
                && this.Outputs.First().IsEmpty;
        }
    }

There are four criteria that need to be met here:

1. At least one transaction input is required.
2. The previous output (a UTXO from another transaction) of the first transaction input cannot be Null. *This is a reference to the coinstake kernel.* 
3. At least two transaction outputs are required. The second of these contains a UTXO that reimburses the coinstake kernel UTXO and pays the mining reward of 1 STRAX.
4. The first transaction output must be empty. A first transaction output containing a UTXO is a characteristic of a `coinbase transaction on a PoW network <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch10.asciidoc#the-coinbase-transaction>`_.

You might be wondering why the second output needs to reimburse the coinstake kernel. This is because the unlocking script must be presented to prove miner ownership when the coinstake kernel is added to the first transaction input. Doing this spends the coinstake kernel on one side of the transaction, so the miner needs to be reinbursed. If this didn't happen, the value of the coinstake kernel would disappear from the miner's wallet. For an example, if a coinstake kernel was worth 100 STRAX, the second output UTXO would be worth 101 STRAX.   

How workers calculate if a UTXO can be the coinstake kernel
=============================================================

Now let's take a closer look at ``CreateCoinstakeAsync()``. This function creates "workers" to check the UTXOs. The number of workers created depends on the number of UTXOs that need to be checked. Each worker checks their UTXOs via a call to ``PosMinting.CoinstakeWorker()``. A call is then made to ``StakeValidator.CheckKernel()`` to check each UTXO in turn and see if any of them can be the coinstake kernel. Some checks are made on the UTXO and then an attempt is made to calculate a hash which meets the target. This is done within ``StakeValidator.CheckStakeKernelHash()``. Exploring the code within this function gives an excellent opportunity the see exactly how the hash is calculated and how the target is reduced (made easier) according to the value of the UTXO.

.. _coinstake-hash-formula:

First, let's look at the formula which checks if a coinstake hash meets the target and can be used for the next block:

::

  Hash256("Stake Modifier V2" + "UTXO Transaction Timestamp" + "UTXO Transaction Hash" + "UTXO Output Number" + "Coinstake Transaction Time") < Target * Weight

.. _coinstake-hash-params-table:

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

The Stake Modifier V2 comes from the tip of the best chain of block headers since the genesis block (that the node is aware of), The block currently at the tip is potentially the *previous block* to the one the miner is trying to write. Stake Modifier V2 is calculated as follows:

::

  Hash256("Hash of transaction the coinstake kernel is from" + "Previous Block Stake Modifier V2")
  
So, you can see how the Stake Modifier V2 ties each block into the transaction containing the coinstake kernel *and* forms a "link" right back to the genesis block.

The main idea behind including the other parameters is to scramble the value which is hashed so no miner hashes the same value as another. If two miners hash the same value at roughly the same time, one will end up being rejected even though they both hit the target. So which parameters, in particular, prevent this? Other miners mining at this time will use the same Coinstake Transaction Timestamp, and there is also a tiny chance they will have the same UTXO Transaction Timestamp. This would be the case if they are both staking UTXOs from a single transaction (meaning they were both involved in the transaction). However, no miner will have the same combination of UTXO Transaction Hash and UTXO Output Number, so this is what significantly reduces the chance of two miners hitting the target at the same time.

.. _looking-at-the-coinstake-kernel-calculations:

Looking at the coinstake kernel calculations in code
=====================================================

We are now going to look at how this translates into code, which you can find in `StakeValidator.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Consensus/StakeValidator.cs>`_. Firstly, the unadjusted target is obtained from the header bits:

::

  BigInteger target = new Target(headerBits).ToBigInteger();

Next, the value of the UTXO is obtained in Satoshi, and the target is multiplied by the UTXO value to give a weighted target.

::

  long valueIn = stakingCoins.Outputs[prevout.N].Value.Satoshi;
  BigInteger weight = BigInteger.ValueOf(valueIn);
  BigInteger weightedTarget = target.Multiply(weight);

Hitting the target involves generating a hash that is lower than the target, and you can see in the code that the larger the value of the UTXO, the more chance you have of hitting the target. In other words, the larger the target, the more the target is weighted in your favor.

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

In the code excerpt above, the parameters which are summed and hashed are added to the ``BitcoinStream`` object in the order they are listed in the :ref:`above table <coinstake-hash-params-table>`; the UTXO Transaction Timestamp is held by ``stakingCoins.Time``, UTXO Transaction Hash is held by ``prevout.Hash``, and so on.

Finally, the coinstake hash is checked against the target:

::

  // Now check if proof-of-stake hash meets target protocol.
  var hashProofOfStakeTarget = new BigInteger(1, context.HashProofOfStake.ToBytes(false));
  if (hashProofOfStakeTarget.CompareTo(weightedTarget) > 0)
  {
      this.logger.LogTrace("(-)[TARGET_MISSED]");
      ConsensusErrors.StakeHashInvalidTarget.Throw();
  }

Failure to meet the target is handled by an exception, so the code directly after the call to ``StakeValidator.CheckKernel()`` in ``PosMinting.CoinstakeWorker()`` is executed in the event that the target was met. The worker then stops work and the new block can be prepared.











