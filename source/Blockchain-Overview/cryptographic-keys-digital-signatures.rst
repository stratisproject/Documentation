******************************************
Cryptographic Keys and Digital Signatures
******************************************

Cryptographic Keys
=====================
As information on the blockchain is transferred over a P2P network across the globe, blockchain uses cryptography to send data throughout the network without compromising the safety and integrity. This allows the blockchain to respect the privacy of users, prove the ownership of assets and secure the information on the network. 

Cryptography is applied throughout the entire protocol onto all of the information that is stored and transacted on the blockchain. This provides users with cryptographic proof which forms the basis for trusting the legitimacy of a user's claim to an asset on the blockchain.

Encryption
=====================
Cryptographic hashes, such as the SHA256 computational algorithm, ensure that even the smallest change to a transaction will result in a different hash value being computed, this indicates a clear change to the transactional history.
Encryption is one of the most critical tools used in cryptography. It is a means by which a message can be made unreadable for an unintended reader and can be read only by the sender and the recipient.

Hashes
=====================
Hashes ensure data is not altered. Hashing is a method of cryptography that converts any form of data into a unique string of text. Any piece of data can be hashed, no matter its size or type. In traditional hashing, regardless of the data’s size, type, or length, the hash that any data produces is always the same length. A hash is designed to act as a one-way function, there by obscuring the source — you can put data into a hashing algorithm and get a unique string, but if you come upon a new hash, you cannot decipher the input data it represents. A unique piece of data will always produce the same hash.

Digital Signature
=====================
Specifically, public-key cryptography (aka asymmetric cryptography) is used to create a key pair which consists of a private key and a public key. The public key is used to create an address to receive a transaction, and the private key is used to sign transactions. Digital signatures provide verification and authentication of ownership on the blockchain. Using cryptographic digital signatures, a user can sign a transaction proving the ownership of that asset and anyone on the blockchain can digitally verify this to be true.
