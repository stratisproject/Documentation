**************************************************
A breakdown of the Two-Way Federated Peg solution
**************************************************

This chapter details the specific mechanics of a Two-Way Federated Peg sidechain solution from initial creation of the sidechain to mining the transactions made on it. Before these steps are covered, it is useful to define the four different types of sidechain user.

+-------------------+-----------------------------------------------------------------------------------------------------------------------------------+
| User              | Description                                                                                                                       |
+===================+===================================================================================================================================+
| Sidechain creator | Sets up and configures the sidechain. Not necessarily a federation member.                                                        |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------+
| Federation member | Authorizes cross-chain transactions in conjunction with other federation members.                                                 |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------+
| Sidechain funder  | Deposits funds on the sidechain and withdraws funds from sidechain.                                                               |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------+
| Sidechain user    | Makes transaction on the sidechain but does not deposit or withdraw funds. In other words, they make no cross-chain transactions. |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------+

.. note::
    Depending on the business case, there may be one sidechain funder or many. For example, a single deposit might be made at the start of a sidechain's life followed by a single withdrawal at the end of its life. Alternatively, cross-chain transactions from several users might be a common occurrence.
	
The creation of the Cirrus sidechain
======================================

The creation of an Cirrus sidechain involves mining the genesis block and premine block, which are the first and second blocks on the sidechain respectively. The premine block contains the "premine" of 100 million APEX coins.  

The following figure shows the creation of the CRS sidechain:

 .. _image1:
 .. image:: Sidechain_Creation.svg
     :width: 793px
     :alt: Sidechains Creation
     :align: center

The UTXO for the premine is shown inside the premine block. The "locked padlock" symbol indicates that at this point the UTXO is unspent, but it is ready to be spent by the federation when they honour STRAX deposits made on the mainchain. A sidechain funder who owns 100 STRAX is also shown in the figure, and their single UTXO of 100 STRAX is shown inside one of the mainchain blocks.

The previous figure is the first of 3 figures. In the subsequent figures, the sidechain funder deposits 100 STRAX on the sidechain and, finally, they withdraw 50 STRAX back.

.. note::
    When the term "locked" is used in relation to individual UTXOs, it refers to the fact they are spendable (when unlocked using the correct signature/s) and contribute to a balance in a wallet. Unlocked UTXOs are spent and no longer contribute to anyone's balance. You may have encountered references to STRAX being locked on the sidechain. In this case, the text is describing in general terms the deposits made by sidechain funders which remain held by the federation until they are withdrawn. 

The next section discusses the role played by the federation and the significance of the P2SH addresses.

The role of the federation
===========================

The role of a federation is to sign-off the deposits from the mainchain to the sidechain and sign-off withdrawals from the sidechain to the mainchain. To achieve this, Stratis Sidechains take advantage of an existing technology already built into the Stratis nodes: `Pay-To-Script-Hash addresses <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch07.asciidoc#p2sh-addresses>`_. P2SH addresses are a convenient way to make payments to an organization that requires `UTXOs with multisignature locking scripts <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch07.asciidoc#multisignature>`_, and they are adaptable to federation requirements. Although spending payments sent to P2SH addresses requires multiple signatories, not all the possible signatories are usually required. For example, only 4 of 5 signatories may be required to spend a payment. When a predefined minimum number of signatories is required from a group for an operation to proceed, this is also known as a quorum. The deposits and withdrawals that the federation controls also require the approval of a quorum.

When a STRAX deposit is made, the federation signs for the release of CRS on the sidechain. When a STRAX withdrawal is made, the federation signs for the release of STRAX on the mainchain.

To achieve this, the Stratis Sidechains solution employs two P2SH addresses:
    
1. The federation members supply private keys from their mainchain wallets and a mainchain P2SH address is created. STRAX sidechain deposits are sent to this P2SH address and remain there until they are withdrawn from the sidechain. Withdrawal of STRAX from this P2SH address requires multisignature unlocking.

2. The federation members supply private keys from their sidechain wallets, and a sidechain P2SH address is created. The premine of the 100 million TAPEX coins is sent to this P2SH address, which is shown in the previous figure. CRS are the issued from this P2SH address, subject to multisignature unlocking, when STRAX are deposited. When STRAX are withdrawn, CRS are returned to this address.  

Creation of each P2SH address requires a public key from each federation member, which is shown in the :ref:`previous figure <image1>`. All supplied keys are hashed before they are used in the locking script. More information on this is available `here <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch07.asciidoc#pay-to-script-hash-p2sh>`_.

More on sidechain deposits and withdrawals
===========================================

This section follows on from the previous section by describing a sidechain deposit and withdrawal in more detail. This includes examining these transactions at the level of the UTXOs involved. A case study which follows on from the :ref:`previous figure <image1>` is used to describe these two processes. Before looking at the case study, two more topics are covered. The first is federated gateways. These are special nodes, which keep the connection between the mainchain and the sidechain, and make withdrawals and deposits possible. Next, the process by which the signatures are collected for the quorum is examined.

Federated gateways
-------------------

Sidechain deposits and withdrawals are different from standard transactions because they require something to be done on the other chain. Only certain nodes on both the mainchain or sidechain, which are known as federated gateways, react to deposits or withdrawals in a special way; other nodes just treat them as normal transactions. Deposits and withdrawals include an address for the transaction on the target chain. Federated gateways monitor transactions to see if there are any which require the other chain to be contacted. Each federation member runs two federated gateway nodes: one on the mainchain and one on the sidechain.

.. note::
     In any transaction federated gateways receive as part of a validated block, they scan for an individual UTXO that is being sent to the federation's P2SH address (for that chain). This flags the transaction up as something special. Deposit and withdrawal transactions must include a second UTXO containing a `RETURN output <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch07.asciidoc#data-recording-output-return>`_.  This second UTXO is used to "transmit" the address (on the targeted chain) to which the deposit or withdrawal will be transferred. After identifying a special transaction, the federated gateway also scans the transaction for the RETURN output UTXO.   

Signature collection
---------------------

Each time a transaction occurs, one federation member has the task of co-ordinating the signature collection. The member chosen changes for each block, and this member is responsible for co-ordinating all the transactions in the given block. If a member is not available, an attempt is made to assign the co-ordination task to the next member and so on. Not giving any particular node the responsibility of co-ordinating the signature collection increases the robustness of the solution.

From now on in this document, the term "boss" is used for the federation member who takes on the co-ordination task for a given block.  

Sidechain deposits
-------------------

For an example of a sidechain deposit, the following figure shows a sidechain funder, :ref:`who has been introduced previously <image1>`, making a deposit of 100 STRAX on the sidechain:
  
 .. _image2:
 .. image:: Sidechain_Deposit.svg
     :width: 906px
     :alt: Sidechains Creation
     :align: center


The sequence of events is as follows:

1. The sidechain funder obtains a sidechains wallet. 
2. The sidechain funder makes a payment of 100 STRAX to the federation's mainchain P2SH address. They supply a CRS address from their sidechain wallet with this transaction. The journey of this address, via a RETURN output UTXO, is shown in red. In this case, the sidechain funder's 100 STRAX were held in a single UTXO (shown in purple), which is spent (unlocked) in this transaction. 
3. One of the mainchain federated gateways detects the transaction containing the deposit. The gateway must now wait for 10 blocks to be mined on top of the block containing the 100 STRAX deposit. The number of blocks to wait is defined by ``MAX_REORG``. In other words, the federation waits until it is impossible to undo the deposit on the mainchain before proceeding to honour the deposit on the sidechain.  
4. A federation boss is assigned to co-ordinate this sidechain deposit and all subsequent deposits that are made on this block.
5. The federation boss contacts one other federation member for their signature after providing their own. The size of the quorum in this federation is 2. The signatures are required to spend (unlock) the UTXO of 100 million CRS that was premined.
6. A transaction is created that pays 100 CRS to the sidechain funder's wallet. The two UTXOs that make up the transaction are shown in the latest sidechain block. The red UTXO is sent (locked) to the sidechain address supplied by the sidechain funder. The green UTXO pays the change (99,999,900 CRS) back to the federation's sidechain P2SH address.

.. note::
    At the end of this deposit, the federation has 100 STRAX locked in the mainchain P2SH address and 99,999,900 CRS locked in the sidechain P2SH address.

Sidechain withdrawals
----------------------
For an example of a sidechain withdrawal, the following figure shows the sidechain funder (who made the deposit of 100 TSRAT) making a withdrawal of 50 CRS from the sidechain:

 .. _image3:
 .. image:: Sidechain_Withdrawal.svg
     :width: 906px
     :alt: Sidechains Withdrawal
     :align: center

The sequence of events is as follows:

1. The sidechain funder makes a payment of 50 CRS to the federation's sidechain P2SH address. They supply a STRAX address from their mainchain wallet with this transaction. The journey of this address, via a RETURN output UTXO, is shown in purple. In this case, the sidechain funder's 50 CRS were held in the single 100 CRS UTXO generated previously, which is spent (unlocked) in this transaction. Another UTXO is also created in the transaction that pays 50 CRS change back to the sidechain funder.
2. One of the sidechain federated gateways detects the transaction containing the withdrawal. The gateway must now wait for 10 blocks to be mined on top of the block containing the 50 CRS withdrawal. The number of blocks to wait is defined by ``MAX_REORG``. In other words, the federation waits until it is impossible to undo the withdrawal on the sidechain before proceeding to honour the withdrawal on the mainchain.
3. A federation boss is assigned to co-ordinate the withdrawal to the mainchain.
4. The federation boss contacts one other federation member for their signature after providing their own. The size of the quorum in this federation is 2. The signatures are required to spend (unlock) the UTXO of 100 STRAX that was previously deposited.
5. A transaction is created that pays 50 STRAX to the sidechain funder's mainchain wallet. The two UTXOs that make up the transaction are shown in the block. The purple UTXO is sent (locked) to the mainchain address supplied by the sidechain funder. The blue UTXO pays the change (50 STRAX) back to the federation's mainchain P2SH address.

.. note::
    At the end of this withdrawal, the federation has 50 STRAX locked in the mainchain P2SH address and 99,999,950 CRS locked in the sidechain P2SH address.

	
Mining on the sidechain
========================

The sidechain uses Proof-of-Authority mining exclusively. Mining is performed by the sidechain federated gateway nodes as well as standard full nodes running on the sidechain. There is no reward CRS for mining a block on the sidechain. 



