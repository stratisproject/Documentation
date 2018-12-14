****************************************************
Consensus
****************************************************

The Stratis Full Node supports :doc:`Proof-of-Stake (PoS) <../PoS/PoS-introduction>`, `Proof-of-Work (PoW) <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch10.asciidoc#proof-of-work-algorithm>`_, and :doc:`Proof-of-Authority (PoA) <../PoA/PoA-introduction>` algorithms. Each algorithm uses a different model of consensus, which is to say each algorithm uses a different set of validation rules to authenticate blocks which are written to the blockchain. All nodes check every block they are sent using at least one group of consensus rules (see below). If a block violates any of the rules, any node can ban the block and attempt to have the peer that sent the block banned.

Because of the modular nature of the Full Node, it is possible to create a new algorithm from one of the existing algorithms and then modify the existing rules, removes rules entirely, or add completely new rules. Ultimately, a completely new algorithm can be designed if that is required.

This document covers how the main components involved in consensus interact with each other, including the Consensus Manager, the Chained Header Tree, and the Validators. The main code paths involved are explored, and broadly speaking, you will be able to see where your own code will go if you choose to modify consensus on the Full Node.

There are four groups of rules which can be defined for an algorithm, and these rule groupings are classified according to the depth and focus of the validation they perform. The components call one or more of the four groupings depending on the situation.


+--------------------------------+-----------------------------------------------------------------------------------------------------------------------+
|Validation                      |Description                                                                                                            |
+================================+=======================================================================================================================+
|Header                          |Checks if the header is valid. The information in the header varies depending on the algorithm.                        |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------+
|Minimal (Block Integrity)       |Performs a mimimal check on a block just to check its basic integrity.                                                 |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------+
|Partial                         |Performs a partial validation on a block.                                                                              |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------+
|Full                            |Performs a full validation on a block. This is an extension to the partial validation rules and does not include them. | 
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------+

As you might expect, the PoS, PoW, and PoA algorithms all have their own distinct set of rules for each group although there is some crossover. Later in the document, you will explore what the individual rules themselves check for and how this ties in with the algorithms themselves.

The purpose of this document is to give you ideas on how you can adjust the way the nodes reach a consensus to make a custom blockchain.

A knowledge of C# is assumed. In particular, you should have a good grasp of `inheritance <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/inheritance>`_, `interfaces <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/interfaces/index>`_, `virtual functions <https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/virtual>`_, and `abstract classes and functions <https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/abstract>`_. If any of these topics are new to you, you might want to read up on them before you begin.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   consensus-architecture
   customising-consensus-rule-engines
   custom-consensus-algorithm-steps