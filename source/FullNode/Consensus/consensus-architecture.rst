****************************************************
Consensus architecture
****************************************************

	The following figure shows the components that make up the consensus architecture. The components within blue shapes are algorithm specific, which is to say they added to a Full Node build depending on the consensus algorithm or algorithms the build needs to support.  

.. image:: consensus-architecture.svg
    :width: 738px
    :alt: Consensus Architecture
    :align: center
	
The table below provides links to the sources files in which the C# classes and related interfaces (were relevant) for these components can be found:

+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Component                       |C# Class                       |C# Interface                                                                                                                                  |
+================================+===============================+==============================================================================================================================================+
|PoW Mining                      |PowMining                      |`IPowMining <https://github.com/justintopham/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/Interfaces/IPowMining.cs>`_|
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|PoS Minting                     |PosMinting                     |IPosMinting                                                                                                                                   |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|PoA Miner                       |PoAMiner                       |IPoAMiner                                                                                                                                     |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Chained Header Tree             |ChainedHeaderTree              |IChainedHeaderTree                                                                                                                            |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Consensus Manager               |ConsensusManager               |IConsensusManager                                                                                                                             |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Consensus Manager Behaviour     |ConsensusManagerBehavior       |N/A                                                                                                                                           |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Header Validator                |HeaderValidator                |IHeaderValidator                                                                                                                              |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Integrity Validator             |IntegrityValidator             |IIntegrityValidator                                                                                                                           |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Partial Validator               |PartialValidator               |IPartialValidator                                                                                                                             |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Full Validator                  |FullValidator                  |IFullValidator                                                                                                                                |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Consensus Rule Engine           |ConsensusRuleEngine            |IConsensusRuleEngine                                                                                                                          |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|PoW Consensus Rule Engine       |PoWConsensusRuleEngine         |N/A                                                                                                                                           |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|PoS Consensus Rule Engine       |PoSConsensusRuleEngine         |N/A                                                                                                                                           |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|PoA Consensus Rule Engine       |PoA Consensus Rule Engine      |N/A                                                                                                                                           |
+--------------------------------+-------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------+

+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
| PoW Mining  | `PowMining <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/PowMining.cs>`_           | `IPowMining <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/Interfaces/IPowMining.cs>`_   |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
| PoS Minting | `PosMinting <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/Staking/PosMinting.cs>`_ | `IPosMinting <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin.Features.Miner/Interfaces/IPosMinting.cs>`_ |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------+

	
The Consensus Manager, which is a ``ConsensusManager`` singleton, is the central part of the consensus architecture and implements the ``IConsensusManager`` interface. It interacts closely with the Chained Header Tree (a ``ChainedHeaderTree`` singleton). The Consensus Manager receives headers via the Consensus Behaviour Manager and these are forwarded to the Chained Header Tree. The Chained Header Tree decides which of the headers are interesting and then requests that the Consensus Manager retrieves the blocks for these headers.  

The ``ConsensusRulesEngine`` is an abstract class that the algorithm-specific ``PoWConsensusRulesEngine``, ``PoSConsensusRulesEngine``, and ``PoAConsensusRulesEngine`` classes inherit from. Each ``ConsensusRulesEngine`` object contains a list of rules for the four types of validation. The Consensus Manager does not interact directly with the instances of ``PoWConsensusRulesEngine``, ``PoSConsensusRulesEngine``, and ``PoAConsensusRulesEngine`` which are created. Instead, the Consensus Manager calls into three wrapper class singletons: ``IntegrityValidator``, ``Partial Validator``, and the ``FullValidator``. These lean objects provide, internally, a logging facility and implement the ``IIntegrityValidator``, ``IPartialValidator``, and ``IFullValidator`` interfaces respectively. Except for ``IPartialValidator``, each of these singletons implements a single method, and it is these methods the Consensus Manager calls.

The Chained Header Tree follows the same pattern and intereacts with ther required header validation rules list via a ``HeaderValidator`` wrapper singleton, which implements the ``IHeaderValidation`` interface.

When does the Consensus Manager perform validation?
====================================================

Let's look at the situations which require that the Consensus Manager performs validation:  

1. PoW Mining, PoS Minting, and PoA Miner singletons call into the Consensus Manager, via the ``ConsensusManager.BlockMinedAsync()`` method, when a new block is created. Calling ``BlockMinedAsync()`` results in the new block undergoing both partial and full validation. As older blocks mined prior to the last checkpoint do not require full validation, part of the partial validation involves checking if a block requires full validation. However, if a supposedly new block does not require full validation, something has gone wrong, and an error is raised.

2. The ``ConsensusManager.HeadersPresented()`` method is used to request that the Consensus Manager initiates block downloading for a set of block headers. The request is forwarded to the Block Puller. Each block retrieved from the network by the Block Puller is pushed into the ConsensusManager via the ``ConsensusManager.BlockDownloaded|()`` callback. In this callback, the integrity of the downloaded block is verified with a call to ``IntegrityValidator.VerifyBlockIntegrity``. All requests to the Block Puller are made via the ConsensusManager.

3. Within ``ConsensusManager.HeadersPresented()`` is a call to the private function ``ConsensusManager.DownloadBlocks()``, which takes a callback function as its second parameter. In this case, ``ConsensusManager.ProcessDownloadedBlock()`` is supplied as the callback. ``ProcessDownloadedBlock()`` matches up a downloaded block with the chained header for that block in the Chained Header Tree. This is achieved via a call to ``ChainedHeaderTree.BlockDataDownloaded()``, which returns true if the downloaded block requires partial validation and false if it does not. If partial validation is required, a call is made to ``PartialValidator.StartPartialValidation()``. If partial validation succeeds at this point, full validation may be required.

4. The decision to proceed with full validation is made by the Chained Header Tree. Specifically, this occurs when ``ChainedHeaderTree.PartialValidationSucceeded()`` is called at two points in the Consensus Manager code: within ``BlockMinedAsync()`` and within ``ConsensusManager.OnPartialValidationSucceededAsync()``, which is called from the callback passed to ``PartialValidator.StartPartialValidation()``. Importantly, ``PartialValidationSucceeded()`` has an ``out`` parameter which returns whether full validation is required. It decides this by checking if the block has more chainwork than the current consensus tip. If this is the case, the new block will become the consensus tip if it passes full validation.
      
When does the Chained Header Tree perform validation?
======================================================

The Chained Header Tree tries to create a new chained header (an instance of ``ChainedHeader``) each time it receives a header (an instance of ``BlockHeader``). Straight after the new chained header is created, it is validated with a call to ``HeaderValidator.ValidateHeader()``. The creation of the new chained header takes place in ``ChainedHeaderTree.CreateAndValidateNewChainedHeader()``, and this private function is only invoked in reponse to two public functions: ``ChainedHeaderTree.ConnectNewHeaders()`` and ``ChainedHeaderTree.ConnectNewHeaders()``.



	
Block Store calls into Consensus Manager. 




