********************************************
Proof-of-Work (PoW) and Proof-of-Stake (PoS)
********************************************

Proof-of-Work (PoW)
====================
At the core of every blockchain consensus protocol is a cryptographic algorithmic computation that decides the proof required to computationally find the next block to be added on the chain. Answers to the cryptographic puzzle are super hard to find but very easy to prove.

Proof-of-Work (PoW) was the first of these algorithm to be proposed under the bitcoin protocol. This is essentially a piece of output from a cryptographic puzzle that requires significant computation to solve. In PoW, the miners are looking for a special value called nonce that is inserted inside the block in order for that hash of its header to have some specific properties. Bitcoin miners race to find a numeric solution to the cryptographic algorithm that meets a network-wide difficulty target. The first miner to find such a solution wins the round of competition and earns the right to publish that block into the blockchain. Every new block creates a number of new coins that is rewarded to the winning miner.

Proof-of-Stake (PoS)
=====================
As PoW requires tremendous computational power, Proof-of-Stake (PoS) is an energy-efficient alternative to achieve consensus between nodes. Instead of miners fighting to mine the next block onto the chain, PoS encourages holders of the coin to stake their holdings. The creator of the next block is determined randomly and in return, the more coins that are at stake, the greater chances there are to mine the next block. Staking is further secured by making holders lock their holdings for a period of time to realise their rewards.

The consensus protocol specifies that the difficulty target should be readjusted after every number of blocks have been mined to achieve a target spacing. The difficulty will increase or decrease based on the hash power of all devices on the blockchain network.
