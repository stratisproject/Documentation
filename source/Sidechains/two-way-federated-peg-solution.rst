**************************************************
A breakdown of the two-way federated peg solution
**************************************************

This chapter details specific mechanics of a Two-Way Peg sidechain solution from initial creation of the sidechain to mining the transactions made on it. It also details the roles of the users involved.

The creation of the APEX sidechain
===================================

The creation of APEX sidechain involved mining the genesis block and premine block, which are the first and second blocks on the sidechain repectively. The premine block contains the "premine" of 20 million APEX coins, which are issued by the federation when STRAT are deposited in the mainchain.  

.. note::
    As this is the Alpha version of sidechains, you will use test STRAT and test APEX. In this document, they are referred to as TSTRAT and TAPEX. TAPEX are issued at the following rate: 1 TSTRAT = 1 TAPEX.
	
The following figure shows the creation of the TAPEX sidechain:

 .. image:: Sidechains1-Creation.png
     :width: 793px
     :alt: Sidechains Creation
     :align: center

The role played by the federation and the signifcance of the P2SH addresses is discussed in the next section.

The role of a Federation
========================

The role of a federation is to sign-off the deposits from the mainchain to the sidechain and withdrawals from the sidechain to the mainchain. To achieve this, Stratis Sidechains take advantage of an existing technology in the Stratis nodes: `Pay-To-Script-Hash addresses <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch07.asciidoc#p2sh-addresses>`_. P2SH addresses are a convenient way for a user to make payments to an organization that requires `UTXOs with multisignature locking scripts <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch07.asciidoc#multisignature>`_, and they are adaptable to federation requirements. Although spending payments sent to P2SH addresses requires multiple signaturies, not all the possible signaturies are usually required. For example, only 4 of 5 signaturies may be required to spend a payment. The deposits and withdrawals that the federation controls also require a predefined number of signatures from federation members.

When a TSTRAT deposit is made, the federation signs for the release of APEX on the sidechain. When a TSTRAT withdrawal is made, the federation signs for the release of TSTAT on the mainchain

To achieve this, the Stratis Sidechains solution employs two P2SH addresses:
    
1. The federation members supply private keys from their mainchain wallets and a mainchain P2SH address is created. TSTRAT deposits are sent to this P2SH  address and remain there until they are withdrawn. Withdrawal of STRAT from this P2SH address requires multisignature unlocking.

2. The federation members supply private keys from their sidechain wallets, and a sidechain P2SH address is created. The premine of the 20 million TAPEX coins is sent to this P2SH address, which is shown in the previous figure. TAPEX are the issued from this P2SH address, subject to multisignature unlocking, when Strat are deposited. When TSTRAT are withdrawn, TAPEX are returned to this address.  

Creation of the each P2SH address requires a public key from each federation member, which is shown in the previous figure. All supplied keys are hashed before they are used in the locking script. More information on this is available `here <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch07.asciidoc#pay-to-script-hash-p2sh>`_.

.. note::
    As this is the Alpha version of sidechains, the federation controlling the APEX sidechain is made up of Stratis Platform team members. Future versions will enable users to become federation members themselves and create their own sidechains. 

Federation leaders
==================

More on sidechain deposits and withdrawals
==========================================


Federated Gateways
------------------
Deposits and withdrawals are different from standard transactions because they require something to be done on the the other chain. Only certain nodes on both the mainchain or sidechain, which are known as federated gateways, react to deposits or withdrawals in a special way; other nodes just treat them as normal transactions. Deposits and withdrawals include an address for the transaction on the other chain. It kis this extra piece of information that these   


