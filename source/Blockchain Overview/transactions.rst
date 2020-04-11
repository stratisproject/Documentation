************************
Transactions
************************

Transaction
=============
A blockchain transaction is a broadcast to the network that the owner of a number of coins has authorized the transfer of portion of those coins to another owner. The receiver can now spend these coins by creating another transaction that authorizes transfer to another owner, and so on, in a chain of ownership.Instead of storing balances in traditional double-entry bookkeeping, blockchains maintain a complete lineage of transactions, which can be used to work out each the balances at any point in time, as well as the state of the blockchain as a whole. 

Unspent Transaction Output (UTXO)
===================================
Each cryptocurrency coin is represented by an unspent transaction output (UTXO) which is just a pair of transaction ID (TxID) and order number together with the associated coin value. And when the coin is used, for example the coin is sent to someone else or in parts, it becomes a spent transaction output (STXO). Only UTXOs are valid coins, not STXOs, which represent past transacted coins that are no longer valid. The system state is of UTXOs with each output locked requiring the user to provide proof of ownership using their private keys to spend their UTXOs.
