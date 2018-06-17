****************************************************
Introduction to the components of the blockchain
****************************************************


Peer to peer network
======================

A peer-to-peer (P2P) network is a series of interconnected computers, referred to as **nodes**, that communicate and share resources in order to achieve a common goal. Peers are equally privileged participants in the network and make a portion of their resources, such as processing power, disk storage or network bandwidth, directly available to other network participants.

Node functionality
-------------------- 
The nodes together verify the information presented to the blockchain, run checks against other 'blocks' of connected information and, upon **consensus**, distribute the updated information to all other nodes on the network. The nodes complete their task by giving information a timestamp that indicates changes from the last update. The node also shows the update is approved through use of a connecting hash that links their approved updates to prior approved updates; This process develops the chain of blocks known as the blockchain. 

Every full node in the network has a copy of all the data in the blockchain and is updated in real time, this is known as a distributed ledger. 

Distributed Ledger
===================

The distributed ledger is an append-only system of record copied to every node of the peer to peer network. The distributed ledger records the transactions, such as the exchange of assets or data, among participants. Transferring and storing information this way mitigates the risk of data hacks or losses because it is not held in only one centralized and vulnerable point.

Nodes in the network agree on the updates to the data in the ledger through **consensus**, and **cryptography** and **digital signatures** to ensure the integrity of transactions; eliminating the need for a trusted third party or middle man.

Every record in the distributed ledger has a timestamp and a unique cryptographic signature linking it to a series of previous transactions, similar to a hashed linked list. These features make the ledger an auditable, immutable history of all transactions in the network that gets more difficult to manipulate with each additional entry. 

Consensus
===================

Consensus protocols are used by nodes to agree on ledger content. All nodes must agree to the network verified transaction being permanently incorporated into the blockchain. The goal of consensus rules is to ensure a single chain is used and followed by every user in the network. There are four main methods of finding consensus in a blockchain:

* Practical byzantine fault tolerance algorithm (PBFT), Hyperledger, Stellar, and Ripple.
* Proof-of-work algorithm(PoW) Bitcoin 
* Proof-of-stake algorithm (PoS) Stratis, Bitshares 
* Delegated proof-of-stake algorithm (DPoS).

Consensus protocols provide nodes on the network who are maintaining a blockchain with rewards and incentives via tokens to continue doing so.

Cryptography
===============

*Ensuring secure, authenticated & verifiable transactions*

Cryptography is a method of using advanced mathematical principles in storing and transmitting data in a particular form so that only those, for whom it is intended, can read and process it.

Cryptography gives us a solution by means of **digital signatures** in combination with **private and public keys**, and **hashing and encryption**. 

Digital Signatures
--------------------

Digital signatures ensure that transactions come from the original sender. Transactions are signed via asymmetric cryptography with unique private keys and are validated by recipients with corresponding public keys to prove the identity of the individual sending it.

Hashes and encryption
-----------------------

Hashes ensure data is not altered. **Hashing** is a method of cryptography that converts any form of data into a unique string of text. Any piece of data can be hashed, no matter its size or type. In traditional hashing, regardless of the data’s size, type, or length, the hash that any data produces is always the same length. A hash is designed to act as a one-way function, there by obscuring the source — you can put data into a hashing algorithm and get a unique string, but if you come upon a new hash, you cannot decipher the input data it represents. A unique piece of data will always produce the same hash.

Cryptographic **hashes**, such as the SHA256 computational algorithm, ensure that even the smallest change to a transaction will result in a different hash value being computed, this indicates a clear change to the transactional history. 

**Encryption** is one of the most critical tools used in cryptography. It is a means by which a message can be made unreadable for an unintended reader and can be read only by the sender and the recipient.

Smart Contracts
===============

Also referred to as Business logic/Shared Contracts, are business terms embedded in the transaction database & executed with transactions. 
Smart contracts use the blockchain layer; the ledger is used by smart contracts that trigger transactions automatically when certain pre-defined conditions are met. Smart contracts can be invoked when a transaction is added to a blockchain and, according to how they are programmed, smart contracts can redistribute the funds sent in the transaction.

Smart contracts are also capable of storing (persisting) data. If they could not do this, it would be impossible for them to achieve the required level of sophistication. You might be asking a question at this point: if a smart contract is stored on every node in the blockchain but gets run on random nodes, what happens to any data it stores when running? The answer is that any data stored by a smart contract is broadcast across all nodes on the network. A smart contract on any node has up-to-date copies of its “database”.

