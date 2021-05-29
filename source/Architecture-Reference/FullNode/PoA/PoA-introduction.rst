****************************************************
Proof-of-Authority (PoA) implementation
****************************************************

The Stratis Full Node supports a Proof-of-Authority (PoA) consensus algorithm in its protocol that can be used instead of its `Proof-of-Work <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch10.asciidoc#proof-of-work-algorithm>`_, or its :doc:`Proof-of-Stake <../PoS/PoS-introduction>` algorithm.

Instead of having to hit a target, by plugging either an integer or UTXO into a formula, to earn the right to create new blocks, a PoA blockchain grants authority to create new blocks to a set of nodes on the network. Providing the integrity of the nodes who have this authority is maintained, using PoA makes it easier to secure smaller blockchains, which are typically but not necessarily private. So what attacks are small PoW and PoS blockchains vulnerable to? Small PoW blockchains are vulnerable from attacks where large amounts of computing power are hired out in an attempt to overwhelm the network. Small PoS blockchains, which typically have a relatively small number of tokens being staked, are vulnerable from an attack where a bad actor, without arousing suspicion, accumulates over 50% of the staking power.

Using a PoA algorithm has two other advantages:

1. Block creators can be kept accountable as they are identifiable.
2. The network is more predictable as blocks are issued at steady time intervals. In other words, they follow a strict "target spacing".

The nodes which are capable of creating blocks are known as a federation. Federations are also further discussed in :doc:`../../Sidechains/sidechains-introduction`, which use PoA for their consensus algorithm.

The purpose of this document is to detail exactly how the PoA algorithm is implemented on the Stratis blockchain.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   the-role-of-the-federation