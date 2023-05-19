NFT with StratisUnity3dSDK
==========================

In this tutorial we will explain how to start using NFTs with
the Stratis Unity SDK.

The employment of Blockchain technology within the gaming industry has become more ever more apparent with the launch of several popular play-to-earn models. The Stratis Unity Gaming SDK enables gaming developers to design, build and deploy games using existing programming languages within a familiar environment.

Non-Fungible Tokens are an area of particular interest for those developing games with in-game valuables. By introducing an NFT, the player can genuinely own in-game items, removing the risk of losing earned items through forgotten login details and account deactivations. This brings the birth of a radical change in gaming marketplaces, with decentralized platforms offering the exchange of in-game items without the need for a trusted intermediary.

What is required to work with Stratis Smart Contracts and NFTs?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Firstly, you need to create a new unity project and import StratisUnitySDK. Latest version can be found here: 
https://github.com/stratisproject/Unity3dIntegration/tree/main/Resources

Generate new address and fund it with some TCRS. You will need coins in order to deploy and interact with NFTs. If you have already Unity address in Cirrus chain then you can utilise existing address as well.

This article uses Stratis hosted public API references in test network which is recommended. Alternatively, you can launch Fullnode locally in test network or main network for which you can refer to the `Stratis Unity Integration <https://academy.stratisplatform.com/Developer%20Resources/Unity3D/Integration/unitytutorial.html>`_ guide to setup your local environment for development.


Deploying a new NFT
~~~~~~~~~~~~~~~~~~~

Firstly, we must generate a new address and fund it. You will need tokens in order to deploy and interact with an NFT.

.. code:: c#

      Network network = new CirrusTest();

      StratisNodeClient client = new StratisNodeClient("https://cirrustest-api-ha.stratisplatform.com/");

      Mnemonic mnemonic = new Mnemonic("legal door leopard fire attract stove similar response photo prize seminar frown", Wordlist.English);

      StratisUnityManager stratisUnityManager = new StratisUnityManager(client, new BlockCoreApi("https://cirrustestindexer.stratisnetwork.com/api/"), network, mnemonic);

      Debug.Log("Your address: " + stratisUnityManager.GetAddress());

Choose a name and symbol for your NFT and call
``NFTWrapper.DeployNFTContractAsync``, the return value is a transaction id.
Once the transaction is mined it’s executed and your contract is deployed.
After that you can use transaction id to get a receipt which will contain new
contract’s address. For example:

.. code:: c#

   string nftName = "gameSword";
   string nftSymbol = "GS";

   string txId = await NFTWrapper.DeployNFTContractAsync(stratisUnityManager, nftName, nftSymbol, false, stratisUnityManager.GetAddress().ToString(), 0);

   ReceiptResponse res = await this.stratisUnityManager.WaitTillReceiptAvailable(txId).ConfigureAwait(false);

   Debug.Log("NFT deployed, it's address: " + res.NewContractAddress);

Minting NFT
~~~~~~~~~~~

Calling ``MintAsync`` with specified target owner address will result in
minting a new NFT that will belong to that address. For example:

::

   
   string firstAddress = "t8ehx5Nm4QXeRhzt92ATTgCRc1zDkFXAdw";
   string uri = "https://stratisplatorm.com/content/nftcollction/demonft.png";
   string nftContractAddress = "tRxYDrnKGAKcrSrc1VQMoKa28RSGUXywP5";

   NFTWrapper nft = new NFTWrapper(stratisUnityManager, nftContractAddress);        

   await nft.MintAsync(firstAddress, uri).ConfigureAwait(false);
   Debug.Log("NFT minted successfully!");


Getting NFT balance
~~~~~~~~~~~~~~~~~~~

NFT balance of address is the amount of NFTs that this address controls.
You can get it like this:

::

   NFTWrapper nft = new NFTWrapper(stratisUnityManager, "t8snCz4kQgovGTAGReAryt863NwEYqjJqy");

   ulong balance = await nft.BalanceOfAsync(this.firstAddress).ConfigureAwait(false);
   Debug.Log("NFT balance: " + balance);

Transferring NFT to another address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To transfer an NFT you need to use ``TransferFromAsync`` and specify
address from which transfer should occur, receiver address and id of a
token you want to transfer.

::

   ulong tokenId = 12345;
           string txId = await nft.TransferFromAsync("tD5aDZSu4Go4A23R7VsjuJTL51YMyeoLyS", "tP2r8anKBWczcBR89yv7rQ1rsSZA2BANhd", tokenId);


Examples
~~~~~~~~

You can find full listings for NFT examples in the `\Assets\Code\Examples\NFTExample.cs` file.
