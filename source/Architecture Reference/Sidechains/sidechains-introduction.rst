**********************************************
Stratis Sidechains
**********************************************

Stratis Full Nodes support sidechains. This is achieved using a:

1. Two Way Federated Peg solution
2. PoA (Proof of Authority) Consensus Algorithm

The Two Way Federated Peg allows STRAX to be passed to and from a sidechain and the gateway through which they pass is controlled by a federation. The federation consists of 3 or more members who have control of the sidechain. 

The PoA Consensus Algorithm is also dependent on a federation. The usage of PoA represents a major step forward from the alpha release of Stratis sidechains, which used a PoW (Proof of Work) algorithm. PoA algorithms are, however, not only suitable for sidechains. They are also employed by Stratis' DLT solutions and could also be considered for a standalone public mainchain using its own token. The modular nature of Stratis Full Node allows the POA consensus algorithm to be easilly incorporated as part of the sidechains package. 

This documentation covers the production release of Stratis sidechains, and to mark this release Stratis has created the Cirrus sidechain. In line with the Stratis philosophy that sidechains are the best place to run smart contracts, the Cirrus sidechain can run smart contracts in C#. The Cirrus sidechain has 7 federation members supporting it drawn from the Stratis Platform internal team. The Cirrus sidechain has its own token (CRS). Users can deposit STRAX on the sidechain and in return they receive CRS to spend on the sidechain. Stratis provides a modifed STRAX wallet and a CRS wallet to help facilitate this.

One way of understanding sidechains is to think of a sidechain as a foreign country and the Stratis mainchain as the user’s home country. The federation secures an amount of the foreign currency (in this case CRS), which it can loan to sidechain visitors in return for depositing STRAX. When a user returns home, they can relinquish their CRS and withdraw the equivalent amount in STRAX on the mainchain.

The target audience for this document include federation members, users of the Stratis mainchain who want to send funds to the sidechain, and anyone interested in how a Stratis sidechain operates.

Like the Stratis Full Node, Stratis sidechains are written in C# using the .NET Core platform. Although this material does not cover any programming tasks, a working knowledge of blockchain topics such as transactions and wallets will be very useful.

This document first details the workings of a Two-Way Federated Peg solution. It then goes on to give step-by-step instructions on how to deposit funds on and withdraw funds from the sidechain.

.. toctree::
   :maxdepth: 2
   :caption: Contents:   
   
   two-way-federated-peg-solution
   support

