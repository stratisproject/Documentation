#####################
Headless Cold-Staking
#####################

We would recommend the utilization of an 'air-gapped' device for the Cold-Wallet, transferring necessary information with the use of a secure device. The STRAX-TEST Blockchain Network is utilized throughout this guide; however, the same steps can be followed on the STRAX Blockchain Network by simply amending the request examples.

This guide assumes that you already have two wallets configured, one on a cold-device and another on your hot-device.  

Cold-Wallet Configuration
=========================

1. An additional account must be created via the coldstaking/cold-staking-account endpoint

.. code-block:: bash

  curl 'http://localhost:27103/api/coldstaking/cold-staking-account' -H 'Accept: application/json' -H 'Content-Type: application/json' --data-binary "{\"walletName\":\"STRAX-Cold-Wallet\",\"walletPassword\":\"ColdWalletPassword\",\"isColdWalletAccount\":true}"

A successful call will return the account name.

3. We must now retrieve an address relating to the Cold-Staking account that was just created. The coldstaking/cold-staking-address will return an address

.. code-block:: bash

  curl 'http://localhost:27103/api/coldstaking/cold-staking-address?walletName=STRAX-Cold-Wallet&isColdWalletAddress=true' -H 'Accept: application/json' -H 'Content-Type: application/json'

4.  A new address is returned, please keep a note of this address as it
    will be defined later in the process. We will refer to this address
    as the **Cold-Staking Wallet Cold Address**

5.  Finally, we must acquire the ExtPubKey of the Cold-Wallet to enable
    us to build a transaction offline. This is retrieved from the
    Wallet/extpubkey endpoint

.. code-block:: bash
  
  curl 'http://localhost:27103/api/Wallet/extpubkey?WalletName=STRAX-Cold-Wallet' -H 'Accept: application/json' -H 'Content-Type: application/json' 
   
Hot-Wallet Configuration
========================

1. An additional account must be created via the
   coldstaking/cold-staking-account endpoint

.. code-block:: bash

  curl 'http://localhost:27103/api/coldstaking/cold-staking-account' -H 'Accept: application/json' -H 'Content-Type: application/json' --data-binary "{\"walletName\":\"STRAX-Hot-Wallet\",\"walletPassword\":\"HotWalletPassword\",\"isColdWalletAccount\":false}"


A successful call will return the account name.

2. We must now retrieve an address relating to the Cold-Staking account
   that was just created. The coldstaking/cold-staking-address will
   return an address

.. code-block:: bash

  curl 'http://localhost:27103/api/coldstaking/cold-staking-address?walletName=STRAX-Hot-Wallet&isColdWalletAddress=false' -H "Accept: application/json" -H "Content-Type: application/json"

A new address is returned, please keep a note of this address as it will
be defined later in the process. We will refer to this address as the
**Cold-Staking Wallet Hot Address**

3. The wallet/recover-via-extpubkey endpoint is utilized to create a
   'Watch Only' wallet on the Stratis Full Node. Providing the ability
   to monitor a wallet address(es) without the ability to spend.

.. code-block:: bash

  curl 'http://localhost:27103/api/wallet/recover-via-extpubkey' -H 'Accept: application/json' -H 'Content-Type: application/json' --data-binary "{\"extPubKey\":\"xpub6CKmpE2VpXuW4x4kjh3Esa17T5rCoZoCnohBNT9WVAGuEgHPtsbvpqU55p9ATnhb7oHzv2b8u77soBa78iYWKp2sztVABBaq5XUKDpQumqD\",\"accountIndex\":0,\"name\":\"STRAX-Cold-Wallet\",\"creationDate\":\"2020-12-31T11:36:32.000Z\"}"

4. After the above request has been executed, the balance of the wallet
   can be queried utilizing the Wallet/balance endpoint. Initially, the
   balance may return as zero synchronisation takes place.

.. code-block:: bash

  curl 'http://localhost:27103/api/Wallet/balance?WalletName=STRAX-Cold-Wallet' -H 'accept: \*/*'
 
5. The synchronization status can be queried with the Node/status
   endpoint

.. code-block:: bash

  curl 'http://localhost:27103/api/Node/status' -H 'accept: \*/*'

6. Once synchronization has completed and the expected balance is returned, 
   we can begin to create the unsigned transaction that details the cold-staking 
   setup.

7. First, we must establish the fee required to perform the transaction so it can be definitively defined. This is achieved through the coldstaking/estimate-offline-cold-staking-setup-tx-fee endpoint
The important values to define below are both **coldWalletAddress** and **hotWalletAddress**. You should define the respective addresses that you have kept a record of whilst progressing through this process. In this example, we can see that both the **Cold-Staking Wallet Cold Address** and **Cold-Staking Wallet Hot Address** are defined.
The **walletName** has to be the wallet name you choose when creating the watch only wallet.

.. code-block:: bash

  curl 'http://localhost:27103/api/coldstaking/estimate-offline-cold-staking-setup-tx-fee' -H 'Accept: application/json' -H 'Content-Type: application/json' --data-binary "{\"coldWalletAddress\":\"qSSpa7uEsocW17f8wvkFbujB2RGAZewDqe\",\"hotWalletAddress\":\"qZoPtiEGkgNNGz2cyXXoBb9HR82Y5QEYZd\",\"walletName\":\"STRAX-Cold-Wallet\",\"walletAccount\":\"account 0\",\"amount\":\"100000\",\"fees\":0,\"walletPassword\":null,\"subtractFeeFromAmount\":true}"

The response returns a fee amount in satoshi – This must be divided by 1e8 (100,000,000) to establish the fee amount that will be defined within the unsigned transaction.

8. We can now build the body of the unsigned transaction to setup 
   cold-staking. Again, the important values to define below are 
   both **coldWalletAddress** and **hotWalletAddress**.

.. code-block:: bash

  curl 'http://localhost:27103/api/coldstaking/setup-offline-cold-staking' -H 'Accept: application/json' -H 'Content-Type: application/json' --data-binary "{\"coldWalletAddress\":\"qSSpa7uEsocW17f8wvkFbujB2RGAZewDqe\",\"hotWalletAddress\":\"qZoPtiEGkgNNGz2cyXXoBb9HR82Y5QEYZd\",\"walletName\":\"STRAX-Cold-Wallet\",\"walletAccount\":\"account 0\",\"amount\":100000,\"fees\":0.0001,\"walletPassword\":null,\"subtractFeeFromAmount\":true}"

The response will be a transaction signing request that can be processed
safely and securely on another device, in this example our Docker
Container that has no network connectivity.

.. code-block:: bash 

  {"walletName":"STRAX-Cold-Wallet","walletAccount":"account 0","unsignedTransaction":"010000000139ba5c83cb756e7cd90d618c25b758bd0df17c1eab895ca02fe949a700fe2adb0100000000ffffffff020080ca39612400001976a914685757640e4953f5854060e50ab557e73d79e4e088acf078724e180900003376a97b63b914b22873455ecf330f3e877a6cd0fe3d7bdc0033e16714617b6f9b2614a09d4859089906126bc799a2cf3f6888ac00000000","fee":"0.0001","utxos":[{"transactionId":"db2afe00a749e92fa05c89ab1e7cf10dbd58b7258c610dd97c6e75cb835cba39","index":"1","scriptPubKey":"76a9146c673e92c1e5aaf490d1bf44b60d177cf83e1bc388ac","amount":"500000"}],"addresses":[{"address":"qTSZpJD9VXN2wsHAQveH9Lc2kTBuWSJYzq","keyPath":"m/44'/1'/0'/0/0","addressType":"p2pkh"}]}

9. Before the unsigned transaction can be processed, we must also
   include the walletPassword property and specify the password
   relative to the Cold-Staking Cold Wallet. If your wallet name that
   you used when recovering from the extpubkey was different to your
   cold wallet name, also adjust the walletName parameter.

   This can be added to the beginning of the request body as seen below.

.. code-block:: bash

  {"walletPassword":"ColdWalletPassword","walletName":"STRAX-Cold-Wallet","walletAccount":"account 0","unsignedTransaction":"010000000139ba5c83cb756e7cd90d618c25b758bd0df17c1eab895ca02fe949a700fe2adb0100000000ffffffff020080ca39612400001976a914685757640e4953f5854060e50ab557e73d79e4e088acf078724e180900003376a97b63b914b22873455ecf330f3e877a6cd0fe3d7bdc0033e16714617b6f9b2614a09d4859089906126bc799a2cf3f6888ac00000000","fee":"0.0001","utxos":[{"transactionId":"db2afe00a749e92fa05c89ab1e7cf10dbd58b7258c610dd97c6e75cb835cba39","index":"1","scriptPubKey":"76a9146c673e92c1e5aaf490d1bf44b60d177cf83e1bc388ac","amount":"500000"}],"addresses":[{"address":"qTSZpJD9VXN2wsHAQveH9Lc2kTBuWSJYzq","keyPath":"m/44'/1'/0'/0/0","addressType":"p2pkh"}]}

10. The request body must now be converted to incorporate JavaScript
    escaped indentation. A tool such as
    https://www.freeformatter.com/json-formatter.html can be used to
    achieve this.

Sign Cold-Staking Setup Transaction
===================================

1. Revert to your air-gapped Cold-Wallet device.

2. The request body we created and formatted to JavaScript Escaped JSON
   can now be utilized as the request body for a call made to the
   offline-sign-request endpoint on the Cold-Wallet device.

.. code-block:: bash

  curl 'http://localhost:27103/api/wallet/offline-sign-request' -H "Accept: application/json" -H "Content-Type: application/json" --data-binary "{\"walletPassword\":\"ColdWalletPassword\",\"walletName\":\"STRAX-Cold-Wallet\",\"walletAccount\":\"account 0\",\"unsignedTransaction\":\"010000000139ba5c83cb756e7cd90d618c25b758bd0df17c1eab895ca02fe949a700fe2adb0100000000ffffffff020080ca39612400001976a914685757640e4953f5854060e50ab557e73d79e4e088acf078724e180900003376a97b63b914b22873455ecf330f3e877a6cd0fe3d7bdc0033e16714617b6f9b2614a09d4859089906126bc799a2cf3f6888ac00000000\",\"fee\":\"0.0001\",\"utxos\":[{\"transactionId\":\"db2afe00a749e92fa05c89ab1e7cf10dbd58b7258c610dd97c6e75cb835cba39\",\"index\":\"1\",\"scriptPubKey\":\"76a9146c673e92c1e5aaf490d1bf44b60d177cf83e1bc388ac\",\"amount\":\"500000\"}],\"addresses\":[{\"address\":\"qTSZpJD9VXN2wsHAQveH9Lc2kTBuWSJYzq\",\"keyPath\":\"m\/44\'\/1\'\/0\'\/0\/0\",\"addressType\":\"p2pkh\"}]}" 

The response provides you with the signed transaction in a hexadecimal
format. Take note of this string as it can now be broadcast to the
blockchain network for acceptance.

Broadcast Cold-Staking Setup Transaction
========================================

1. The Cold-Staking Setup Transaction can now be broadcast to the
   network, utilizing the value of the hex property, taken from the
   signing of the Cold-Staking Setup transaction that was undertaken on
   the Cold-Wallet Docker Container.

.. code-block:: bash

  curl -X POST 'http://localhost:27103/api/Wallet/send-transaction' -H "accept: \*/*" -H "Content-Type: application/json-patch+json" -d "{\"hex\":\"010000000139ba5c83cb756e7cd90d618c25b758bd0df17c1eab895ca02fe949a700fe2adb010000006b483045022100e2a45f8aed8d49df77aea5447571685f6ca73443375de6b47f56a0521517c5190220271f2c99b19136316a725a7c276c3d23658bca2c4467e7f6cc6c9ce978387ac7012103f6660f0a636262cc786e5e2677beb7ab4fcb156f4e5b55e9a1363635f6405169ffffffff020080ca39612400001976a914685757640e4953f5854060e50ab557e73d79e4e088acf078724e180900003376a97b63b914b22873455ecf330f3e877a6cd0fe3d7bdc0033e16714617b6f9b2614a09d4859089906126bc799a2cf3f6888ac00000000\"}"

The response details the transaction ID, confirming that the transaction
has now been broadcast to the network.

2. The setup can be confirmed by querying the Hot-Wallet's Cold-Staking
   Hot Addresses account for a balance.

.. code-block:: bash

  curl -X GET "http://localhost:27103/api/Wallet/balance?WalletName=STRAX-Hot-Wallet&AccountName=coldStakingHotAddresses" -H "accept: \*/*"

The response evidences the setup has been successful as the balance can
be confirmed.

Staking with the Hot-Wallet  
===========================

1. Staking can be enabled simply, by interacting with the
   Staking/startstaking endpoint, as seen below.

.. code-block:: bash

  curl -X POST "http://localhost:27103/api/Staking/startstaking" -H "accept: \*/*" -H "Content-Type: application/json-patch+json" -d "{\"password\":\"HotWalletPassword\",\"name\":\"STRAX-Hot-Wallet\"}" 

2. The staking status can be confirmed by interacting with the
   Staking/startstaking endpoint as seen below.

.. code-block:: bash

  curl -X GET "http://localhost:27103/api/Staking/getstakinginfo" -H "accept: \*/*" 

The response will highlight the staking status in addition, staking
information relating to the network is returned also.

.. code-block:: bash

  {"enabled":true,"staking":true,"errors":null,"currentBlockSize":230,"currentBlockTx":1,"pooledTx":0,"difficulty":4627133.56490853,"searchInterval":16,"weight":10000899990000,"netStakeWeight":6484304056772607,"immature":0,"expectedTime":29176}

3. Staking can be stopped by simply shutting down the node.
