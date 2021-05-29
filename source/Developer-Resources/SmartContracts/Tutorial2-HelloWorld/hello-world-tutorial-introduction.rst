.. _hello-world-tutorial-introduction-dev:

**********************************************************
A "Hello World" smart contract
**********************************************************

This next tutorial in the series looks at a classic "Hello World" program.

Commonly, "Hello World" programs are very simple and consist of just one function, which outputs a string. However, because of the nature of smart contracts, this example is slightly more complicated, and we will take an opportunity to see how smart contracts are built from C# classes. Every interaction with a smart contract is made via a method call to the smart contract including its deployment. There is a limit of one call in any transaction.

If you are unfamiliar with any of the following C# topics, the following links will help you as you progress through the tutorial:

* `C# Classes <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/classes>`_
* `C# Inheritance <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/inheritance>`_
* `Class Constructors <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/constructors>`_
* `Property Getters and Setters <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/using-properties>`_

You can find the source code for the "Hello World" smart contract examples in the `Stratis.SmartContracts.Examples.HelloWord <https://github.com/stratisproject/StratisBitcoinFullNode/tree/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld>`_ project, which is included in the ``LSC-tutorial`` branch of the Stratis Full Node. For this tutorial, you will study, build, and deploy `HelloWorld.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld/HelloWorld.cs>`_. 

.. toctree::
   :maxdepth: 2
   :caption: Contents:   
   
   deploying-hello-world-contract