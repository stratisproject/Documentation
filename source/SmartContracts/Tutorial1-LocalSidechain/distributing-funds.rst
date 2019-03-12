**************************************************
Distributing premine funds
**************************************************

This next step is not strictly essential in order to deploy a smart contact on the network that you have created. At this stage, the miner could theoretically deploy a smart contract using the funds from the premine wallet. However, rather than just run a solo node, we are going to create a network and give two other nodes the chance to work with smart contracts.

The steps are as follows:

1. Ensure the miner node is up and running.
2. Run the first standard node:

::

./start_node1.sh 

3. Connect to node 1 using Swagger: http://localhost:38202/swagger/index.html
4. Use the ``/api/Wallet/mnemonic`` and ``api/Wallet/create`` API calls to create a wallet named "LSC_node1_wallet".
5. Use the ``/api/SmartContractWallet/account-addresses`` API call to get an address to pay funds to. Choosing a smart contract account address has advantages, which are explored in later tutorials.
6. Connect to the miner using Swagger: http://localhost:38201/swagger/index.html
7. Use the ``/api/Wallet/build-transaction`` API call to build a transaction that sends 100 LSC tokens from the miner's wallet to the smart contract account address from LSC_node1_wallet.
8. Use the ``/api/Wallet/send-transaction`` API call to broadcast the contract to the network.
9. After a short time, LSC_node1_wallet should contain a balance of 100 LSC tokens.
 
Repeat the process for node 2 (http://localhost:38203/swagger/index.html) but name the wallet "LSC_node2_wallet". 

Both nodes should now contain 100 LSC tokens. Either of these nodes can now be used to deploy the "Hello World" smart contract in Tutorial 2.
 