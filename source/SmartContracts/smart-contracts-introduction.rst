########################
Stratis Smart Contracts
########################

Smart contracts can now be deployed on the Stratis Full Node. Like the Full Node, Stratis smart contracts are written in C#. Smart contracts extend the functionality of a blockchain and allow it to map out complex financial interactions through the sending of funds and storage of data. However, as we shall see later in the document, the uses of smart contracts are not limited to financial interactions.

The audience for this document is anyone who wants to get started writing smart contracts on the Stratis Platform. Even if you have not written a smart contract before, this is a great place to start. This material provides some basic theory about smart contracts, briefly explores some use cases, and then helps you start creating your own smart contract. An interesting example of a smart contract, based on a real-world case, is supplied to kickstart your learning.

This document assumes that you are familiar with basic blockchain concepts. When it comes to writing smart contracts, a basic knowledge of C# is also assumed. However, if you are new to C# or even programming, we recommend you continue to explore Stratis smart contracts as part of your C# learning experience. More resources on the C# language are available `here <https://docs.microsoft.com/en-us/dotnet/csharp/>`_. A basic knowledge of `Swagger <https://swagger.io>`_ and working with the command-line interface would also be useful.


.. note::
    The Stratis Smart Contract platform is currently in an open alpha stage. Things may not be stable and aspects of the development process are subject to change. Please do not use the alpha version of Stratis Smart Contracts for production applications.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   smart-contracts-basic-theory
   uses-of-smart-contracts
   working-with-contracts
   account-abstraction-layer
   auction-smart-contract
   testing-locally-with-testchain
   testing
   support
   appendix-future-enhancements-to-smart-contracts
   appendix-gas-prices
