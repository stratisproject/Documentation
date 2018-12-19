##########################
Account Abstraction Layer
##########################

Introduction
-------------------
The Stratis blockchain is based on a `UTXO <https://en.wikipedia.org/wiki/Unspent_transaction_output>`_ transaction model. This lends itself well to financial transactions but adds a degree of complexity for smart contracts.

To make developing and interacting with contracts easier, Stratis' smart contracts implementation adds the concept of an account abstraction layer (AAL). The AAL provides a wrapper around the underlying UTXO-based transaction model and allows contracts to be interacted with as though they were accounts in an accounts-based transaction model.

This approach is desirable for several reasons:

* Contract developers do not need to manage UTXOs.
* Code and state are stored against a single address.
* Interactions with a contract are done at a single address.

From the outside, interacting with a contract is still done by the same mechanism as before - by creating and sending transactions.

Contract Accounts
------------------
A contract account in the AAL has these properties:

* Address - A unique address for interacting with the contract that does not change.
* Balance - The sum of all funds sent from and received by the contract.
* Code - The contract's bytecode.
* State - A key-value store of data.

Transactions
------------------

In the AAL, each contract's balance is maintained in a single UTXO. Transactions that change a contract's balance produce a new UTXO that holds the contract's latest balance. The contract state database is updated with a reference to the new UTXO.

Funds Transfers
~~~~~~~~~~~~~~~~~~~~
Internal (to another contract) and external funds transfers generated during contract execution are condensed into a single transaction, known as the "condensing transaction".

Consider a single contract execution which performs two functions: transfer of funds to a standard (non-contract) P2PKH address, and transfer of funds to another contract. After successful execution, these two transfers are condensed into a single transaction which is added to the block. For the non-contract P2PKH transfer, a standard P2PKH UTXO is produced and added to the transaction. For the contract-to-contract transfer, new UTXOs reflecting each contract's final balance are produced using the special ``OP_INTERNALCONTRACTTRANSFER`` opcode. This opcode ensures a UTXO can only be spent by the recipient contract.


Limitations
------------------

There are a few limitations of using an AAL.

The UTXO spent to create a contract create/call transaction must use a P2PK or P2PKH script. This ensures that the sender's address is always obtainable. The sender address is used to provide the gas refund and as context during contract execution.

There is a reduction of privacy as a degree of address reuse is required. For example, if your ownership of a token is recorded in a contract, you must always interact with that contract using the same address.