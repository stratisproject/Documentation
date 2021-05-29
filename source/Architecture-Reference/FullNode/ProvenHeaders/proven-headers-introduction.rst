****************************************************************
Proven Headers
****************************************************************

The Bitcoin protocol uses a "headers first" Initial Block Download (IBD) methodology. This involves downloading the headers for the best chain, performing :doc:`header validation <../Consensus/consensus-architecture>`, and then making a request to download the corresponding blocks. This has the effect of speeding up the downloading of blocks on the network. Compared to using `inv messages <https://en.bitcoin.it/wiki/Protocol_documentation#inv>`_ containing a list of blocks, the "headers first" way of receiving blocks has advantages in terms of resource usage. A `getheaders message request <https://en.bitcoin.it/wiki/Protocol_documentation#getheaders>`_ can be made to a peer to send up to 2000 headers at a time.

As it stands, this aspect of the Bitcoin protocol is well suited to a `Proof-of-Work (PoW) <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch10.asciidoc#proof-of-work-algorithm>`_ blockchain like Bitcoin. However, :doc:`Proof-of-Stake (PoS) <../PoS/PoS-introduction>` blockchains implementing the standard header syncing taken directly from Bitcoin are vulnerable to attack. Why is this? First, let's explore how an attack could theoretically work on blockchains using either type of algorithm. The attack would involve sending a chain of headers in response to a request, but in this chain, the referenced blocks would not exist. A node receiving  this fake chain of headers would then become "stuck" trying to download blocks that do not exist. This would continue until an alternative, genuine chain becomes available that is longer than the fake chain. At this point, a node that has been knocked out by the attack could switch to the genuine chain and continue as normal. A long fake chain has the potential to knock a node out for a long period of time.

The reason that Proof-of-Work blockchains are, for practical purposes, immune from these attacks is that constructing fake headers using a Proof-of-Work algorithm is expensive in terms of computing power. For each fake header, a valid nonce would need to be calculated, and a brute force approach, taking both time and money, is the only option here. A valid nonce hits the target at the required difficulty level (which is also supplied with each header). Because the nonce and difficulty level are supplied with each header, it is easy for a PoW node to check if the nonce is valid for any header in a chain.

On a Proof-of-Stake blockchain, the nonce is not used to attempt to hit the target, and, in fact, the nonce field remains empty in block headers on a Proof-of-Stake blockchain. Instead, when an attempt is made to hit the target, the UTXOs from a staker's wallet are used rather than simply using an integer (the nonce). A UTXO that successfully hits the target is known as the coinstake kernel. However, because no reference to the coinstake kernel is included in the header, there is no way, when using the standard header syncing, to check if a header is valid. Therefore, fake chains of headers, which contain no proof at all, can be created at almost any length.

The purpose of this document is to give an overview of how the Stratis Full Node implements a solution to this vulnerability using "proven headers", which extend the information available in each header.

The document takes an architectural view of the Proven Headers solution. However, a knowledge of C# is beneficial, particularly if you decide to explore the implementation in code. 

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   how-proven-headers-provide-a-solution



