************************************************************************
Running a local network with its own token 
************************************************************************

Welcome to the first in this series of smart contract tutorials. Although you will not be running any smart contracts, this tutorial showing you how to set up a local network can be thought of as a primer. The local network you will set up:

1. Consists of nodes that run entirely on your local machine.
2. Has its own token to use for experimenting with smart contracts.
3. Runs even if you are not connected to the internet. This gives you the opportunity to try out "real world" smart contract deployment and method calling in an entirely local setting.

This small local network uses a :doc:`Proof-of-Authority (PoA) consensus algorithm </../../../Architecture Reference/FullNode/PoA/PoA-introduction>`. In fact, the network can run completely standalone, however, more nodes can join the network by simply opening another instance of Cirrus Core (Developer Edition). This network is not a sidechain, the node(s) do not run a sidechain gateway, which means the token created is not pegged to the STRAX and carries no value at all in the real world.

A significant amount of focus has been put into simplifying the 'setup' process and ensure a consistent development environment for those looking to embark on Smart Contract Development in C# on the Stratis Platform.

.. toctree::
   :maxdepth: 2
   :caption: Contents:   
   
   creating-a-local-chain
   