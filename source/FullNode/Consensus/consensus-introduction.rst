****************************************************
Consensus
****************************************************

The Stratis Full Node supports Proof-of-Stake (PoS), Proof-of-Work (PoW), and Proof-of-Authority (PoA) algorithms. Each algorithm uses a different model of consensus, which is to say it uses a different set of validation rules to authenticate blocks. Because of the modular nature of the Full Node, it is possible to create a new algorithm from one of the existing algorithms and then modify the existing rules, removes rules entirely, or add completely new rules. Ultimately, a completely new algorithm can be designed if that is required.

Before getting into specifics, this document covers how the main components involved in consensus interact with each other, including the Consensus Manager, the Chained Header Tree, and the Validators. 

There are four groups of rules which can be defined for an algorithm:


PoS, PoW, and PoA algorithms all have their own distinct set for each group.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

	consensus-architecture