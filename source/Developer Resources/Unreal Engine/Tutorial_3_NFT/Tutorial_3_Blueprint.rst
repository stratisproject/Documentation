Tutorial #3 - NFT
==============================================

In this tutorial we will explain how to start using NFTs with
the Stratis Plugin for Unreal Engine.

The employment of Blockchain technology within the gaming industry has become more ever more apparent with the launch of several popular play-to-earn models. The Stratis Plugin for Unreal Engine enables game developers to design, build and deploy games using existing programming languages within a familiar environment.

Non-Fungible Tokens are an area of particular interest for those developing games with in-game valuables. By introducing an NFT, the player can genuinely own in-game items, removing the risk of losing earned items through forgotten login details and account deactivations. This brings the birth of a radical change in gaming marketplaces, with decentralized platforms offering the exchange of in-game items without the need for a trusted intermediary.

Prerequisite
------------

For this tutorial, you need to setup Stratis Full Node, as described in the `Getting started section <https://academy.stratisplatform.com/Developer%20Resources/Unreal%20Engine/Tutorial_0_Plugin_set_up/Tutorial_0.html>`_.


Deploying a new NFT
-------------------
   
At first, we need to generate a new address and fund it. You will need tokens in order to deploy and interact with an NFT.
      
.. image:: images/init-wallet.png
   :target: images/init-wallet.png
   :alt: Initialize wallet

|

To create instance of UNFTWrapper, we can use ``createInstance`` or ``createDefaultInstance`` methods:

.. image:: images/create-wrapper-method.png
   :target: images/create-wrapper-method.png
   :alt: UNFTWrapper factory methods

where:


* ``contractAddress`` - address of deployed contract. For ``createDefaultInstance`` method, canonical NFT contract address will be used.
* ``manager`` - valid pointer to ``UStratisUnrealManager`` instance.
* ``outer`` - "parent" object for our new instance.

To deploy the NFT contract, we need to use the ``deployNFTContract`` method:

.. image:: images/deploy-nft-method.png
   :target: images/deploy-nft-method.png
   :alt: Deploy NFT contract

where:

* ``name``\ , ``symbol``\ , ``tokenURIFormat``\ , ``ownerOnlyMinting`` - parameters passed to `constructor of the NFT contract <https://github.com/stratisproject/CirrusSmartContracts/blob/400e5399e85abf5e0fdb156f07109db5476648b2/Testnet/NonFungibleToken/NonFungibleToken/NonFungibleToken.cs#L159>`_
* ``callback`` - error-aware callback, return either transactionID of contract deployment transaction or error.

Once the transaction is mined it’s executed and your contract is deployed.
After that you can use transaction id to get a receipt which will contain new
contract’s address. For example:

.. image:: images/deploy-nft.png
   :target: images/deploy-nft.png
   :alt: Deploy NFT

|

Minting NFT
-----------

Calling ``UNFTWrapper::mint`` with specified target owner address will result in
minting a new NFT that will belong to that address. For example:

.. image:: images/mint-nft.png
   :target: images/mint-nft.png
   :alt: Mint NFT

|

Getting NFT balance
-------------------

NFT balance of address is the amount of NFTs that this address controls.
You can get it with ``UNFTWrapper::getBalanceOf`` like this:

.. image:: images/get-balance.png
   :target: images/get-balance.png
   :alt: Get NFT balance

|

Transferring NFT to another address
-----------------------------------

To transfer an NFT you need to use ``UNFTWrapper::transferFrom`` and specify
address from which transfer should occur, receiver address and id of a
token you want to transfer.

.. image:: images/transfer-nft.png
   :target: images/transfer-nft.png
   :alt: Transfer NFT

|