****************************************************
Components and Features Overview
****************************************************

The following figure shows the components and features of the Full Node:

.. image:: Full-Node-Overview.png
    :width: 738px
    :alt: Full Node Overview
    :align: center

All the components and features are described in the following sections. Several of the sections cover a task that the full node needs to carry out and explain the individual components along the way.  


Accessing the network
======================

The *P2P* and *Connection* components are responsible for getting and maintaining access to other peers on the P2P network.  

When a full node is connected to the network, *Behaviours* respond to messages received from other nodes.

P2P
---
The *P2P* component tries to make the P2P network bigger. As more peers are found, they are added to a local database. This information is kept up-to-date. The decision about which peer to connect to when a choice is available is designed to be unpredictable. This adds an extra element of security.

The mechanism used to grow the P2P network is the Peer Discovery Loop, which asks the peers it discovers about the location of other peers.

The *P2P* component also needs to represent the located peers. Once it is represented, a peer can, for example, be asked which version of the protocol it is running. Communication with other peers is achieved by sending messages. Behaviour components on the other peers process received messages depending on whether the message is relevant to them.     
The *P2P* component also takes care of message payloads. A payload is a description of a message, which describes how to take a C# object and serialize it for the network. This also works for incoming messages. Once the message has been identified by its message type, it can be changed from a byte stream to a C# object.

An example of the P2P component messaging
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. A peer is located on the network, and an object is created to represent this peer.
2. An attempt is made to connect to the peer.
3. The Peer Discovery Loop asks for a "handshake" to be initialized.
4. After the handshake has been completed a ``getaddr`` message sent.
5. The returned ``addr`` message containing information on known nodes is handled by *Peer Address Manager Behaviour*.

The Stratis network protocol is 98% similar to the Bitcoin network protocol. More information on Bitcoin network protocol is available `here <https://en.bitcoin.it/wiki/Protocol_documentation#Message_types>`_.

Connection
-----------

The *Connection* component contains a list of the comnnected peers. This component and not *P2P* is talked to by the higher-level components. This component is also responsible for banning peers and decides who to ban and why. The mechanism for banning the peers is implemented by *Peer Banning Behaviour*. The *Peer Banning Behaviour* component does not consume any message; instead, if a message identifies a banned peer, the connection to the banned peer is dropped.

Behaviour Components
---------------------

There are numerous behaviour components in the Full Node. For example: *Block Puller Behaviour*, *Chained Header Behaviour*, *Memory Pool Behaviour*, *Block Store Behaviour*. You can think of the behaviour components as plugins which are responsible for filtering out messages that are not relevant to their related component. For example, *Memory Pool Behaviour* only cares about messages related to the *Memory Pool*.

Syncing with the blockchain
============================

Once a Stratis Full Node has found other peers on the network, it needs to sync its copy of the blockchain. The components involved with this are the *Consensus Manager*, *Chained Header Tree*, *Block Puller*, *Validators*, and *Coin View*.

Consensus Manager
------------------

Once a connection has been made to other peers on the network, the peers send block headers to the *Consensus Manager*. It is the *Chained Header Behaviour* which consumes the messages sent by these peers. When new headers are received, the *Consensus Manager* contacts the *Chained Header Tree* and informs it that it has new headers. The *Chained Header Tree* analyses whether the blocks are interesting and reports back to the *Consensus Manager* if they are. The *Consensus Manager's* response is to download the full blocks for the headers. The *Block Puller* is invoked to download the blocks.

Providing the blockchain is synced, the *Consensus Manager* uses the *Validators* to perform all three validation steps (minimal, partial, and full) on the blocks that are received.

When the *Consensus Manager* fully validates a block, the consensus tip moves forward by one and *Coin View* is updated. The block is also added to the *Block Store*.  
 
Chained Header Tree
--------------------

The first thing to realize about the *Chained Header Tree* is that, as its name implies, it is a tree structure that is built out of block headers. This is distinct from the blockchain, which does not have forks (branches) in it and is made up as full blocks. The *Chained Header Tree* relates to a concept known as the consensus tip, which is the height in blocks on the blockchain at which a consensus has been reached. If the *Chained Header Tree* becomes aware of a fork which is ahead of the blockchain at the consensus tip, it requests the *Consensus Manager* obtains the blocks for this new fork. Once the blocks are obtained, the *Consensus Manager* begins validating the blocks for this potentially interesting fork.

The *Chained Header Tree* represents a potential state of flux around the consensus tip. It can potentially proceed with validation on a fork that is ahead of the consensus tip only to then switch to a second fork half way through this. 

The *Chained Header Tree* stores the headers it receives in memory and contacts the *Validators* to perform header validation on these headers.
 
Validators
^^^^^^^^^^^^^^^^^
The *Consensus Manager* and *Chained Header Tree* make use of the *Validators*. Validation is broken down into four steps:

1. Header validation
2. Minimal validation (block integrity validation)
3. Partial validation
4. Full validation

As discussed in the *Block Puller* section, in the case of an initial block download, validation requirements are significantly less when dealing with a block that proceeds a checkpoint. 

Block Puller
--------------

The *Block Puller* works in one of two modes:

1. IBD (Initial Block Download)
2. Network synced.

The mode that is selected depends on whether you have passed a checkpoint. A checkpoint is a point at which the blockchain can never be re-organised behind (if you think of the blockchain moving as forward). IBD is selected if you are not yet synced to the blockchain network, and the blocks you require are behind the checkpoint. Because these blocks can never be changed, validation is minimal. The headers are validated and minimal validation is carried out on the blocks. Part of the full validation is carried out. This is the part that involves updating the *Coinview*

The network synced mode is used when the network is synced, and all blocks behind the checkpoint are already on the node's blockchain.  

Download Strategy
^^^^^^^^^^^^^^^^^^
A node is aware of the connection speed of the peers and gives smaller tasks to slower peers.

In IBD mode, task distribution is important. Tasks are distributed between peers based on two factors:

1. The current bandwidth the peer has.
2. Historical data available on the peer. Nodes are assigned a value between 0 and 150 based on how fast they have proved to be.

Imagine 1000 blocks need to be downloaded. A fast peer with a score of 75 will be asked to download 500 blocks providing they currently have the required bandwidth. Some “fast nodes” can become maxed out, and their ratings will drop as a result of this. Other nodes are configured to only allow a maximum of 10 connection, and thereby maintain a constant high rating.

Block Store
-------------

The *Block Store* uses a NoSQL database (DBreeze) to store the blockchain on disk. The *Block Store* is an optional feature that enables a node to supply blocks to other nodes. It is possible to run a lightweight node without this feature. In this case, the node just works with the latest blocks, which are held in a cache.

Coin View
-----------
The *Coin View* represents the UTXO set. Each time the consensus tip moves forward, it needs to be recalculated. It can be thought of as the amount of STRAT which is spendable at any given block height. As the consensus tip moves forward one block, the number of UTXOs changes, which reflects UTXOs being spent and new UTXOs being created as payments and change.

The *Coin View* makes use of a database and cache. It can be rewound although rewinding is expensive.

Updating the *Coin View* is the last step of full validation.

Mining new blocks
==================

If the Mining feature is enabled on the full node, it is able to mine new blocks on the network using the proof-of-stake methodology. The following components are involved with this: *Memory Pool*, *Miner*, and *Wallet*.

Memory Pool
------------
The *Memory Pool* keeps a record of transactions that are not in blocks. The *Miner* component uses the  
The *Memory Pool's* record of pending transactions when it is preparing a block. The *Memory Pool* also has an internal coinview, seperate from the *Coinview* component, which describes what would happen if all the pending TXs were added to the blockchain. When a transaction is validated and added to the mempool, the node can now relay the transaction to other peers which the node is connected to.

The *Memory Pool* is limitted by default to 300MB. This means that when the *Memory Pool* is full, transactions that do not pay a big enough fee must be removed from the *Memory Pool* to create more space. Around 10% of the low paying transactions are removed in response to a full *Memory Pool*.

When blocks arrive via the *Block Puller*, the transactions within them are removed from the *Memory Pool*. This is because these blocks have, after passing validation, the potential to be added to the blockchain; therefore, the transactions they contain should not be included in any new blocks.

The concept of an orphan block is relevant to the *Memory Pool*. It relates to the state of flux around the consensus tip as the node analyses the forks in the blockchain and decides which to follow. Orphan blocks are created when the node abandons a chain and switches to another chain. The blocks from the tip of the abandonned chain back where the fork occurred with the new chain are now considered to be orphans. The question now is are all the transactions in the orphaned blocks present in the blocks in the new chain? If any transactions are not found in the blocks in the new chain, they are returned to the *Memory Pool*. This gives them a chance to be added to future blocks mined by the node.

Miner
=====

The *Miner* component fills block templates up with transactions from the *Memory Pool* (sorted by fees). When the block is full, the miner attempts to mine it using either the proof-of-stake function (for STRAT) or thre proof-of-work function (for BTC). When a block is succesfully mined, it is presented to the peers on the network who will then attempt to validate it.

The Stratis proof-of-stake algorithm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The Stratis proof-of-stake algorithm is designed to mine a block every minute. Broadly speaking, it works by having a target, which can be hit by running a mathematical algorithm; if the target is hit by a miner, the miner can mine the block. The Stratis proof-of-stake algorithm is designed so that it takes about one minute for one miner to hit the target. The more STRAT the miner has staked, the more likely they are to be the miner who hits the target. For example, if a miner is in possession of 40% of the STRAT currently being staked, they have a 40% chance of being able to mine a block during each block cycle.

Because the algorithm is dependent on the STRAT that a miner is staking, the *Wallet* is contacted to check the miner's staking power. UTXOs are retrieved from the wallet and checked that they are valid for staking.

Wallet
=======

The wallet component is interested in transactions from three sources:

1. Historical transactions stored in the block store.
2. Transactions in blocks that are arriving from other peers on the network.
3. Transactions in the memory pool. 

In all cases the wallet iterates through all the transactions in the block to see if any of the UTXOs matches the addresses contained within it.


Node-wide libraries
=====================

The full node contains some internal libraries to supply functionality to all components. It also makes use of one external library.

Core
-----

This library contains code related to the state of the blockchain. It enables components to share their state between each other so they can get an overall view on the full node. For example, the consensus tip and the block store tip are shared between all components, and this library enables the sharing to be done without creating a dependency on the consensus and block store features.

Interfaces are employed to pass information around. For example, the initial block download state is implemented in the consensus feature; other components just pass around an interface to it.

NBitcoin
---------
`NBitcoin <https://github.com/MetacoSA/NBitcoin/tree/master/NBitcoin>`_ is a external Bitcoin library for the .NET platform written in C#. It implements many Bitcoin Improvement Proposals (BIPs). The Stratis Full Node uses NBitcoin for multiple functionalities including running scripts and crytographic hashing and signing.

Interfacing with the Full Node
===============================

It is possible to connect to a full node using Remote Procedural Calls (RPCs) and a RESTful API. The API exposes the same API as Bitcoin and includes some extra features.
