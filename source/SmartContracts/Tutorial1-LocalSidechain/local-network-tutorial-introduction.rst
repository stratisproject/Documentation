************************************************************************
Smart Contract Tutorial 1 - Running a local network with its own token 
************************************************************************

Welcome to the first in this series of smart contract tutorials. Although you will not be running any smart contracts, this tutorial showing you how to set up a local network can be thought of as a primer. The local network you will set up:

1. Consists of nodes that run entirely on your local machine.
2. Has its own token to use for experimenting with smart contracts.
3. Runs even if you are not connected to the internet. This gives you the opportunity to try out "real world" smart contract deployment and method calling in an entirely local setting.

Along the way, we will look at some of the settings available to you when setting up a network and shed light on the creation of the genesis and premine blocks.

This small local network uses a :doc:`Proof-of-Authority (PoA) consensus algorithm </../../FullNode/PoA/PoA-introduction>`. In fact, the network consists of three nodes, and only one of these is a federation member who participates in mining. This network is not a sidechain. The mining node does not run a sidechain gateway node, which means the token created is not pegged to the STRAT and carries no value at all in the real world.

To complete this tutorial, you need:

1. A knowledge of Git and GitHub so you can clone the Stratis Full Node repository on your machine and access the branch containing the local smart contracts code. If you don't already have it, `GitHub desktop <https://desktop.github.com>`_ is a useful tool for performing Git-related tasks.
2. A little knowledge of working with the command line so you can run either a bat file (on a Windows PC) or a bash script (on a Mac or Linux PC).
3. An editor, which you are familiar with, to make a couple of very small code changes to C# files.

If you want to take an opportunity to further modify the local smart contract network code, you will need to put your knowledge of C# into practice. Changing the network settings is not too complicated and mainly involves altering strings and some class names. However, if you are new to C# or even programming, you can set up the network without worrying about the code and then begin learning C# as you embark on the second tutorial: a "Hello World" smart contract. Later, you can revisit creating a modified local network if you are interested.

.. toctree::
   :maxdepth: 2
   :caption: Contents:   
   
   running-the-local-smart-contracts-miner
   creating-the-genesis-block
   creating-the-premine-block
   distributing-funds