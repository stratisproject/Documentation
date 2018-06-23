.. Stratis Sidechains documentation master file, created by
   sphinx-quickstart on Mon Jun 11 01:12:07 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

**********************************************
Stratis Sidechains
**********************************************

The Stratis Full Node now supports sidechains. This is achieved using a Two-Way Federated Peg solution. This means that STRAT can be passed to and from the sidechain and the gateway through which they pass is controlled by a federation. The federation consists of 3 or more members who have control of the sidechain.

The target audience for this document include federation members, users of the Stratis mainchain who want to send funds to the sidechain, and anyone interested in how a Two-Way Federated Peg operates.

Like the Stratis Full Node, Stratis sidechains are written in C# using the .NET Core platform. Although this material does not cover any programming tasks, a working knowledge of blockchain topics such as transactions and wallets will be very useful.

This documentation covers the Alpha release of Stratis sidechains. To enable users to get started, Stratis has created a sidechain running on the Stratis testnet. It has 5 federation members supporting it drawn from the Stratis Platform internal team. The sidechain has its own token called the APEX. Users can deposit STRAT on the sidechain and in return they receive APEX to spend on the sidechain. Stratis provides a modifed STRAT wallet and an APEX wallet to help facilitate this.

One way of understanding sidechains is to think of a sidechain as a foreign country and the Stratis mainchain as the user’s home country. The federation secures an amount of the foreign currency (in this case APEX), which it can loan to sidechain visitors in return for depositing STRAT. When a user returns home, they can relinquish their APEX and withdraw the equivalent amount in STRAT on the mainchain.

This document first details the workings of a Two-Way Federated Peg solution. It then goes on to give step-by-step instructions on how to deposit funds on and withdraw funds from the sidechain.

.. toctree::
   :maxdepth: 2
   :caption: Contents:   
   
   two-way-federated-peg-solution
   support-and-community
