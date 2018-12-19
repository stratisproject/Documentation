***************************************************************************************
How Proven Headers provide a "headers first" solution for a Proof-of-Stake blockchain
***************************************************************************************

Standard header syncing causes vulnerability on Proof-of-Stake blockchains. The Stratis Full Node solution basically involves extending the information available with each header when it is broadcast to the network. This allows peers receiving headers to not only check the headers are valid but also that they represent a valid block. The PoS Header Validation ruleset was extended to include rules for checking proven headers.   

One check which the proven header rules carry out determines whether the coinstake kernel, which is or was a staker’s UTXO, can generate a hash that hits the target. In order for a block to have been written, one UTXO must have been able to do this and thereby become what is known as the coinstake kernel for the PoS block.

The extra information supplied allows the PoS consensus engine to check that:

1. The :ref:`coinstake transaction <coinstake-tx-definition>` (which references the coinstake kernel) is present in the block the header represents.
2. The coinstake kernel is valid, which includes checking that the UTXO is old enough. If the transaction that created the UTXO hasn’t been in the blockchain long enough, it cannot be part of a stake.  

The :ref:`formula <coinstake-hash-params-table>` for calculating a coinstake hash actually requires, in addition to a coinstake kernel, a Stake Modifier V2, which is taken from the previous block. As with the full blockchain, a received batch of proven headers must be valid in its entirety, with each header reliant on the one before when attempting to hit the target. The checks carried out on proven headers are actually more involved than just checking the coinstake kernel is valid, and we will take a look at them in greater detail in a later section in this chapter.

In addition to extending the header information available, the protocol had to be extended with messages specific to proven headers. The next section contains more information on these messages.

Proven header messages
=======================

Standard header syncing uses the `sendheaders <https://en.bitcoin.it/wiki/Protocol_documentation#sendheaders>`_, `getheaders <https://en.bitcoin.it/wiki/Protocol_documentation#getheaders>`_, and `headers <https://en.bitcoin.it/wiki/Protocol_documentation#headers>`_ messages. Two new proven header messages were implemented for the Stratis protocol:

+-------------+-----------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Message     | Description                                                                                                     | Related C# class                                                                                                                                                       |
+=============+=================================================================================================================+========================================================================================================================================================================+
| getprovhdr  | Requests proven headers.                                                                                        | `GetProvenHeadersPayload <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin/P2P/Protocol/Payloads/GetProvenHeadersPayload.cs>`_ |
+-------------+-----------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| provhdr     | Returns a payload of up to 2000 proven headers.                                                                 | `ProvenHeadersPayload <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin/P2P/Protocol/Payloads/ProvenHeadersPayload.cs>`_       |
+-------------+-----------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

A proven headers version of the `sendheaders` message was not required, and this existing Bitcoin protocol message is used to permit nodes to announce new blocks via a `provhdr` message (instead of `inv`). During a handshake with another peer, the node checks the version of the Stratis protocol the peer is running. An estimate is made as to whether the peer is able to supply proven headers, and if it is not, no `sendheaders` message is sent. 

How the headers were extended to become block headers?
=======================================================

The `ProvenBlockHeader <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/NBitcoin/ProvenBlockHeader.cs>`_ class inherits from the `PosBlockHeader <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/NBitcoin/BlockStake.cs>`_ class and ultimately from `BlockHeader <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/NBitcoin/BlockHeader.cs>`_. ``PoSBlockHeader`` doesn't extend ``BlockHeader`` with any new members. However, ``ProvenBlockHeader`` contains several additional members used to check if the block the header represents is valid. The following table describes these additional members:

+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Member          | Description                                                                                                                                                                               |
+=================+===========================================================================================================================================================================================+
| Coinstake       | The coinstake transaction, which contains, as an input, the UTXO that is the coinstake kernel for the represented block.                                                                  |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| MerkleProof     | A merkle proof that proves the coinstake transaction is in the represented block.                                                                                                         |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Signature       | Contains the signature for the represented block. A hash of the block is signed by the private key which corresponds to the public key locking the coinstake transaction's second output. |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| HeaderSize      | The total size of the proven header including the size of the ``BlockHeader`` plus the ``Coinstake``, ``MerkleProof``, and ``Signature`` members.                                         |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| StakeModifierV2 | A value linking a block to the previous block and the transaction its coinstake kernel is from. Used locally and not sent over the network.                                               |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note:: The signature for a header's represented block is actually the same as a "header's signature". In both cases, exactly the same pieces of information (the exact same bytes) are first hashed and then signed. *Neither all the bytes in the header or all the bytes in the block are used.*

.. note:: The sizes of the ``Coinstake``, ``MerkleProof``, and ``Signature`` members are also public properties of the class, but these have been omitted from the table.

Why coinstake age was adjusted?
================================= 

Coinstake Age is the minimum amount of confirmations a block must have in order that the block's UTXOs can participate in staking. A confirmation is when a block is added on top of a block, so a block with 50 confirmations is 50 blocks under the consensus tip.

.. note:: If a node is synced up to x blocks, it has the information to validate proven headers which represent blocks from x + 1 to x + Coinstake Age. For any proven header within this range, the node can check if a coinstake kernel is actually a valid UTXO from the blocks it has synced.  

The Maximum Reorganization Length defines the maximum length of any reorganization the node will except. In other words, if the Maximum Reorganization Length is set to 500, then blocks which are more than 500 blocks under the consensus tip cannot be altered; they are "set in stone" so to speak. The Stratis Mainnet has a Maximum Reorganization Length of 500. 

Introducing the proven header feature meant that Coinstake Age had to be set to 500 as well; otherwise UTXOs from blocks with the potential to undergo reorganization can become coinstake kernels. Coinstake kernels that can potentially undergo reorganization cannot be validated with a small proof. The complexities introduced by adding a more complex proof would make the solution inferior to just syncing with ``inv`` messages; therefore, the decision was made to increase Coinstake Age.

In the code, Coinstake Age is retrieved by calling ``PosConsensusOptions.GetStakeMinConfirmations()``. :ref:`consensus-options` goes into more depth about the `PosConsensusOptions <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/NBitcoin/ConsensusOptions.cs>`_ class.

Maximum Reorganization Length is held in the ``MaxReorgLength`` property of the `Consensus <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/NBitcoin/Consensus.cs>`_ class. The value is assigned to the property when an instance of the ``Consensus`` class is created in `StratisMain <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Networks/StratisMain.cs>`_.

.. _exploring-the-proven-header-rules-in-detail:

Exploring the proven header rules in detail
============================================

Before reading this section, it is recommended that you familiarize yourself with the material in :doc:`../Consensus/customising-consensus-rule-engines` and the other “consensus” chapters.

There are two proven header rules: `ProvenHeaderSizeRule <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Consensus/Rules/ProvenHeaderRules/ProvenHeaderSizeRule.cs>`_ and `ProvenHeaderCoinstakeRule <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Consensus/Rules/ProvenHeaderRules/ProvenHeaderCoinstakeRule.cs>`_. There is also a base class, `ProvenHeaderRuleBase <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Consensus/Rules/ProvenHeaderRules/ProvenHeaderRuleBase.cs>`_, which contains functionality for checking whether proven headers are activated on the network and whether a header is a proven header.

The following subsections detail the checks that are made by the derived rule classes:

Checking the sizes of proven header members
---------------------------------------------

``ProvenHeaderSizeRule`` checks that the serialized sizes of the three proven header members (``Coinstake``, ``MerkleProof``, and ``Signature``) do not exceed the maximum sizes permitted for each member. You can find the maximum sizes in `PosConsensusOptions <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/NBitcoin/ConsensusOptions.cs>`_.

Checking if the proven header has a valid coinstake transaction
-----------------------------------------------------------------

``ProvenHeaderCoinstakeRule`` first checks if the supplied coinstake transaction meets the requirements to be a coinstake transaction.


Checking if the proven header has valid timestamps
-------------------------------------------------------

``ProvenHeaderCoinstakeRule.CheckHeaderAndCoinstakeTimes()`` checks that the timestamp for the header matches the timestamp for the coinstake transaction. It also checks that the timestamp is divisible by 16 seconds, which is a requirement on the Stratis Mainchain network. You can find the stake timestamp mask in `PosConsensusOptions <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/NBitcoin/ConsensusOptions.cs>`_.

Checking if the coinstake kernel is old enough
----------------------------------------------------

``ProvenHeaderCoinstakeRule.GetAndValidatePreviousUtxo()`` retrieves the coinstake kernel from coinstake transaction and ``ProvenHeaderCoinstakeRule.CheckCoinstakeAgeRequirement()`` checks to see if the kernel is of the required age.

Checking the coinstake kernel was spent correctly
---------------------------------------------------

``ProvenHeaderCoinstakeRule.CheckSignature()`` verifies the coinstake kernel was spent correctly in the coinstake transaction. This proves that the creator of the block also owned the coinstake kernel UTXO. 

Checking the hash generated by the coinstake kernel hits the target
---------------------------------------------------------------------

``ProvenHeaderCoinstakeRule.CheckStakeKernelHash()`` checks the hash generated by the coinstake kernel is *lower* than the target, which means the target was hit and the right to mine a block granted. The target is weighted by multiplying it by the value of the coinstake kernel. A more valuable coinstake kernel means a higher (easier) target. :ref:`looking-at-the-coinstake-kernel-calculations` takes a detailed look at these calculations.

Checking that the coinstake transaction is in the block represented by the proven header
---------------------------------------------------------------------------------------------
 
``ProvenHeaderCoinstakeRule.CheckCoinstakeMerkleProof()`` uses the merkle proof to check that the coinstake transaction is in the `merkle tree <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch09.asciidoc#merkle-trees>`_ and therefore included in the block.

Checking the proven header's signature was made by the miner who owns the coinstake transaction output.
--------------------------------------------------------------------------------------------------------------

``ProvenHeaderCoinstakeRule.CheckHeaderSignatureWithCoinstakeKernel()`` checks that `the signature of the represented block's hash matches the public key used in the coinstake transaction's second output locking script <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch06.asciidoc#pay-to-public-key-hash-p2pkh>`_. A match means the same private key was behind both.





 


