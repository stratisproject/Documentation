**********************************************
Breeze Wallet
**********************************************

The Breeze Wallet is a lightweight `Hierarchical Deterministic (HD) wallet <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch05.asciidoc#hd-wallets-bip-32bip-44>`_ that supports both BTC and STRAT transactions. This wallet is considered lightweight because it doesn't rely on blocks saved in a file system to run; instead the wallet relies on network peers to download the blocks.

The source for the Breeze wallet is available `here <https://github.com/stratisproject/Breeze>`_. Full instructions on building and running the wallet `are also available <https://github.com/stratisproject/Breeze/blob/master/Breeze.UI/README.md>`_. Like the Stratis Core wallet, the Breeze wallet requires a Stratis Full Node daemon to be running. However, a Breeze-specific version of the Stratis Full Node daemon is used. The Breeze daemon doesn't validate the full blockchain and only uses the blocks it receives to build the wallet UTXO database. It then attempts to match UTXOs in the database with the addresses that it holds.

The Breeze Wallet front-end is built using Electron and Angular technologies.



