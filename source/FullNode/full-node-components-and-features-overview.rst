****************************************************
Components and Features Overview
****************************************************

The following figure shows the components and features of the Full Node:

.. image:: Full-Node-Overview.png
    :width: 738px
    :alt: Full Node Overview
    :align: center

All the components and features are described in the following sections, each of which covers a task that the full node needs to carry out.  


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

The first thing to realize about the *Chained Header Tree* is that, as its name implies, it is a tree structure that is built out of block headers. This is distinct from the blockchain, which does not have branches in it and is made up as full blocks. The *Chained Header Tree* relates to a concept known as the consensus tip, which is the height in blocks on the blockchain at which a consensus has been reached. If the *Chained Header Tree* becomes aware of a branch which is ahead of the blockchain at the consensus tip, it requests the *Consensus Manager* obtains the blocks for this new branch. Once the blocks are obtained, the *Consensus Manager* begins validating the blocks for this potentially interesting branch.

The *Chained Header Tree* represents a potential state of flux around the consensus tip. It can potentially proceed with validation on a branch that is ahead of the consensus tip only to then switch to a second branch half way through this. 

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

Useful libraries
=================

The full node contains some libraries that supply functionality to all components.

NBitcoin 
---------
NBitcoin is a Bitcoin library for the .NET platform. It implements many Bitcoin Improvement Proposals (BIPs). The Stratis Full Node uses NBitcoin for multiple functionalities including running scripts and crytographic hashing and signing.   
