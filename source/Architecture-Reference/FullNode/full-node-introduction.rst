****************************************************
Stratis Full Node
****************************************************

The Stratis Full Node is the backbone of the Stratis Platform. It implements the STRAX protocol and maintains an up-to-date copy of the STRAX and sidechain blockchains. Because of this, Full Nodes can:

1.	Autonomously and authoritatively validate blocks and transactions.
2.	Serve blocks and transactions to other peers on the STRAX or sidechain blockchain networks. 

The Full Node is open source software and is built in C# using the .NET Core platform.
The design of the Full Node is modular and several of its features can be included or excluded from a build depending on requirements.

The audience for this document is anyone who wants to get involved with further developing the capabilities of the Full Node. Here are two reasons for getting involved:

1.	You want to contribute to ongoing development work on the Full Node project.
2.	You want to fork the source code and adapt it for your own project. For example, you might want to add a new feature or modify the block size.

A knowledge of C# is also assumed. However, if you are new to C# or even programming, you can continue to explore the Full Node as part of your C# learning experience. However, exploring Stratis Smart Contracts will give you “easier wins” and still enable you to have experience with blockchain-related code. More resources on the C# language are available `here <https://docs.microsoft.com/en-us/dotnet/csharp/>`_.

A background knowledge of `peer-to-peer (P2P) <https://en.wikipedia.org/wiki/Peer-to-peer>`_ computing including its uses prior to the invention of cryptocurrency will also be helpful.

The purpose of this document is to provide a high-level overview of the Full Node, so you can gain an idea of how the components work together. It does not touch on individual C# classes.

The Full Node is open source, and you can find the source here on GitHub: https://github.com/stratisproject/StratisBitcoinFullNode.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   ComponentsOverview/full-node-components-and-features-overview
   ConsoleOutput/ConsoleOutput
   Features/features
   PoS/PoS-introduction
   PoA/PoA-introduction
   Consensus/consensus-introduction
   ProvenHeaders/proven-headers-introduction
   ColdStaking/ColdStaking