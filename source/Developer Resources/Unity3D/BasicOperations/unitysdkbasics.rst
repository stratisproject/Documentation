=====================================
Basic operations with StratisUnitySDK
=====================================

This tutorial will show you how to use the basic functionality of the Stratis Unity SDK: create a wallet, check your balance and unspent transaction outputs (UTXOs), and send coins to another address.

What is required to work with basic functionality of the SDK?
=============================================================

The `Stratis Unity Integration <https://academy.stratisplatform.com/Operation%20Guides/Unity3D/Integration/unitytutorial.html>`_ guide can be followed to setup your local environment for development.

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
   Set base URL. To use Stratis Unity SDK, you need a full node to be running locally or remotely. Find your node's address (IP or domain) if you're running a remote node, or use ``http://localhost:44336`` if you're running your node locally.

#. 
   Set the network you want to operate on. Use ``StraxMain`` or ``CirrusMain`` to operate on Strax or Cirrus production networks, or use ``StraxTest`` or ``CirrusTest`` for testing purposes.

#. 
   Set a mnemonic for your wallet. Mnemonic is a sequence of words used to define the private key of your wallet. You can create mnemonic `using just a pen, a paper, and a dice <https://armantheparman.com/dicev1/>`_\ , or use different hardware & software mnemonic generators.

.. code-block:: csharp

   Network network = new StraxMain();
   Unity3dClient Client = new Unity3dClient("http://localhost:44336/");
   Mnemonic mnemonic = new Mnemonic("legal door leopard fire attract stove similar response photo prize seminar frown", Wordlist.English);
   StratisUnityManager stratisUnityManager = new StratisUnityManager(client, network, mnemonic);


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

Getting unspent transaction outputs
===================================

Okay, now we will try to find unspent transaction outputs for our wallet:

.. code-block:: csharp

   GetUTXOsResponseModel utxos = await Client.GetUTXOsForAddressAsync(this.address.ToString());

Now, if we want to convert response model to list of Coins, we can write something like this:

.. code-block:: csharp

   var coins = utxos.Utxos.Select(x => 
               new Coin(
                  new OutPoint(uint256.Parse(x.Hash), x.N), 
                  new TxOut(new Money(x.Satoshis), address)
               )
            ).ToList();

Sending coins & waiting for a receipt
=====================================

Now let's try to implement a more complex logic: send some coins and wait for transaction's receipt.

At first, define a couple of variables:


* ``destinationAddress``\ : in this example, we're using ``tD5aDZSu4Go4A23R7VsjuJTL51YMyeoLyS`` for **Cirrus Test network**
* ``amount``\ : the number of satoshis we want to send. Let's send 10.000 satoshis (= 0.0001 STRAX).

.. code-block:: csharp

   string destinationAddress = "tD5aDZSu4Go4A23R7VsjuJTL51YMyeoLyS";
   long amount = 10000;

Now, send ``amount`` of coins to ``destinationAddress`` with the code shown below:

.. code-block:: csharp

   string txId = await stratisUnityManager.SendTransactionAsync(destinationAddress, amount);


Well, now we want to know when the receipt for this transaction is available.
To achieve this, use the code shown below:

.. code-block:: csharp

   var receipt = await stratisUnityManager.WaitTillReceiptAvailable(txId);


Examples
========

You can find more examples in the Examples folder.

`\Assets\Code\Examples\TestApiMethods.cs` - general example that covers usage of basic wallet functionality.

To run this or another examples just add their scripts to any object in your scene or use prebuilt scenes from ``\Assets\Scenes``.
