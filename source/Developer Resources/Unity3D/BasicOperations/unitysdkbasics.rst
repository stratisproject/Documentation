=====================================
Basic operations with StratisUnitySDK
=====================================

This tutorial will show you how to use the basic functionality of the Stratis Unity SDK: create a wallet, check your balance, and send coins to another address.

What is required to work with basic functionality of the SDK?
=============================================================

The `Stratis Unity Integration <https://academy.stratisplatform.com/Developer%20Resources/Unity3D/Integration/unitytutorial.html>`_ guide can be followed to get information about public node API references.

Setting up StratisUnityManager and creating a wallet
====================================================

First of all, we need to set up ``StratisUnityManager`` to be able to use all of the API methods provided by the SDK.

Let's create a new script inherited from ``MonoBehaviour``\ :

.. code-block:: csharp

   public class TutorialScript : MonoBehaviourß
   {
      async void Start()
      {
         // TODO: place for your code
      }
   }

We'll use this class to set up and hold the ``Unity3dClient`` and the ``StratisUnityManager`` instances and to run some code inside the ``Start`` method later.

Now we're going to set up base URL, network, and wallet mnemonic.

Let's walk through the steps:


#. 
   Set base URL. To use Stratis Unity SDK, you need a full node to be running locally or remotely. Find your node's address (IP or domain) if you're going to use a remote Cirrus node in testnet then use ``https://cirrustest-api-ha.stratisplatform.com/``, or if you're running your Cirrus node locally in test network then use ``http://localhost:38223/``. We recommend to use remote public node as running Fullnode locally may take more time for synchronisation.

#. 
   Set the network you want to operate on. Use ``CirrusTest`` or ``CirrusMain`` to operate on Cirrus testnet or production networks. For development and learning purpose we recommend to use test network where you don't need real money, you can use Test coins.

#. 
   Set a mnemonic for your wallet. Mnemonic is a sequence of words used to define the private key of your wallet. You can create mnemonic `using just a pen, a paper, and a dice <https://armantheparman.com/dicev1/>`_\ , or use different hardware & software mnemonic generators.

.. code-block:: csharp

   Network network = new CirrusTest();
   StratisNodeClient client = new StratisNodeClient("https://cirrustest-api-ha.stratisplatform.com/");
   Mnemonic mnemonic = new Mnemonic("legal door leopard fire attract stove similar response photo prize seminar frown", Wordlist.English);
   StratisUnityManager stratisUnityManager = new StratisUnityManager(client, new BlockCoreApi("https://cirrustestindexer.stratisnetwork.com/api/"), network, mnemonic);


Now, let's print current wallet's address to the console:

.. code-block:: csharp
   
   Debug.Log("Your address: " + stratisUnityManager.GetAddress());


Now we need to attach this script to game object on the scene and run the game. An address of our wallet will be printed after the game started.

Getting a wallet balance
========================

Now let's learn how we can get a balance of our wallet.

.. code-block:: csharp

   try {
      decimal balance = await stratisUnityManager.GetBalanceAsync();
      Debug.Log("Your balance: " + balance);
   } catch (Exception e) {
      Debug.Log("Balance request failed, got error:" + e.ToString());
      throw e;
   }

This code will print your balance if the call succeeds, and print an error otherwise.


Sending coins & waiting for a receipt
=====================================

Now let's try to implement a more complex logic: send some coins and wait for transaction's receipt.

At first, define a couple of variables:


* ``destinationAddress``\ : in this example, we're using ``tD5aDZSu4Go4A23R7VsjuJTL51YMyeoLyS`` for **Cirrus Test network**
* ``amount``\ : the number of satoshis we want to send. Let's send 10.000 satoshis (= 0.0001 CIRRUS).

.. code-block:: csharp

   string destinationAddress = "tD5aDZSu4Go4A23R7VsjuJTL51YMyeoLyS";
   long amount = 10000;

Now, send ``amount`` of coins to ``destinationAddress`` with the code shown below:

.. code-block:: csharp

   string txId = await stratisUnityManager.SendTransactionAsync(destinationAddress, amount);


Well, now we want to know when the receipt for this transaction is available.
To achieve this, you can use the code shown below:

.. code-block:: csharp

   var receipt = await stratisUnityManager.WaitTillReceiptAvailable(txId);


Examples
========

You can find more examples in the Examples folder.

`\Assets\Code\Examples\TestApiMethods.cs` - general example that covers usage of basic wallet functionality.

To run this or another examples just add their scripts to any object in your scene or use prebuilt scenes from ``\Assets\Scenes``.
