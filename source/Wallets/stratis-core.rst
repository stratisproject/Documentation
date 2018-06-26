**********************************************
Stratis Core
**********************************************

The Stratis Core wallet is a `Hierarchical Deterministic (HD) wallet <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch05.asciidoc#hd-wallets-bip-32bip-44>`_, which allows you to send and receive STRAT. The Stratis Core also allows you to stake the STRAT you have in your wallet. Staking enables you to mine on the Stratis network using its proof-of-stake methodology.

You can download the source for the Stratis Core from `here <https://github.com/stratisproject/FullNodeUI>`_ and then build it. However, the Stratis Core must be run with a `Stratis Full Node daemon <https://github.com/stratisproject/StratisBitcoinFullNode>`_. The Stratis Full Node daemon holds a copy of the Stratis blockchain and provides the backend REST service on which the wallet relies. To connect to the Stratis network using the daemon, build and run the Stratis.StratisD project in the Full Node solution. Full instructions on running the Full Node daemon `are also available <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/Documentation/getting-started.md>`_.

When the Stratis Core connects to the daemon, it checks the transactions found in the blocks that have been downloaded by the Full Node. The Stratis Core tries to match UTXOs in the transactions with the addresses that it holds. 

The Stratis Core is built using Electron and Angular technologies.
 
