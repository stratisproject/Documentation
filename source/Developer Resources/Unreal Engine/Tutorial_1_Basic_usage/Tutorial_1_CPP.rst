
Tutorial #1 - Basic plugin usage
================================

In this tutorial we'll show you how to use the basic functionality of the Stratis Unreal plugin: create a wallet, check your balance and unspent transaction outputs (UTXOs), and send coins to another address.

**Of we go!**

Prerequisite
------------

You need to set up your project and Stratis Unreal Plugin within it. If you looking for a tutorial about basic project setup, please check our :doc:`Tutorial #0 <../Tutorial_0_Plugin_set_up/Tutorial_0>`.

Setting up StratisUnrealManager and creating a wallet
-------------------------------------------------------------

First of all, we need to set up ``StratisUnrealManager`` to be able to use all of the API methods provided by the plugin.

Let's open the **Source** path of your project and create a new header named ``StratisHandler.h``\ :

.. code-block:: cpp

   #pragma once

   #include "CoreMinimal.h"
   #include "UStratisUnrealManager.h"

   #include "StratisHandler.generated.h"

   UCLASS(minimalapi)
   class UStratisHandler : public UObject {
     GENERATED_BODY()

   public:
     UStratisHandler();

     UPROPERTY()
     UStratisUnrealManager *stratisManager;

     UWorld *GetWorld() const override;

     UFUNCTION(BlueprintCallable, Category = "StratisHandler")
     void RunSomeLogic();
   };

We'll use this class to set up and hold the ``UStratisUnrealManager`` instance and to run some code inside the ``RunSomeLogic`` method later.

Okay, now we're going to implement the ``StratisHandler`` class we defined above:

.. code-block:: cpp

   #include "StratisHandler.h"

   UStratisHandler::UStratisHandler() {
     stratisManager =
         CreateDefaultSubobject<UStratisUnrealManager>(TEXT("StratisManager"));

     //TODO: Initialize stratisManager
   }

   UWorld *UStratisHandler::GetWorld() const { return GetOuter()->GetWorld(); }

   void UStratisHandler::RunSomeLogic() {
       //TODO: print balance, utxos etc
   }

Now we're going to set up base URL, network, and wallet mnemonic.

Let's walk through the steps:


#. 
   Set base URL. To use Stratis Unreal Plugin, you need a full node to be running locally or remotely. Find your node's address (IP or domain) if you're running a remote node, or use ``http://localhost:44336`` if you're running your node locally.

#. 
   Set the network you want to operate on. Use ``ENetwork::CIRRUS`` and ``ENetwork::CIRRUS_TEST`` for production and testing respectively.

#. 
   Set a mnemonic for your wallet. Mnemonic is a sequence of words used to define the private key of your wallet. You can create mnemonic `using just a pen, a paper, and a dice <https://armantheparman.com/dicev1/>`_\ , or use different hardware & software mnemonic generators.

.. code-block:: cpp

   UStratisHandler::UStratisHandler() {
     stratisManager =
         CreateDefaultSubobject<UStratisUnrealManager>(TEXT("StratisManager"));

     stratisManager->setBaseUrl(TEXT("http://148.251.15.126:44336"));
     stratisManager->setPredefinedNetwork(ENetwork::CIRRUS_TEST);
     stratisManager->setMnemonic(TEXT("legal door leopard "
                                      "fire attract stove "
                                      "similar response photo "
                                      "prize seminar frown"));
   }

Now, let's write something interesting inside of the ``RunSomeLogic`` method - print current wallet's address to log console:

.. code-block:: cpp

   void UStratisHandler::RunSomeLogic() {
     UE_LOG(LogTemp, Display, TEXT("Address: %s"),
            *(stratisManager->getAddress()));
   }

The last thing we need to do is to make use of our ``UStratisHandler``.
Open **...Character.h** and add lines below to the class declaration:

.. code-block:: cpp

   UPROPERTY(VisibleAnywhere, BlueprintReadOnly, meta = (AllowPrivateAccess = "true"))
   UStratisHandler* stratisHandler;

And now add object initialization code into the character's class constructor definition:

.. code-block:: cpp

   stratisHandler = CreateDefaultSubobject<UStratisHandler>(TEXT("StratisHandler"));

Add ``RunSomeLogic`` call to the end of ``OnFire`` event definition:

.. code-block:: cpp

   stratisHandler->RunSomeLogic();

Now we need to compile code and run the game. An address of our wallet will be printed on every shot we make.

Getting a wallet balance
------------------------

Now let's learn how we can get a balance of our wallet.

Put the code below inside the ``RunSomeLogic`` method:

.. code-block:: cpp

   stratisManager->getBalance([](const auto &result) {
   if (result::isSuccessful(result)) {
       UE_LOG(LogTemp, Display, TEXT("Balance in satoshis: %llu"),
               result::getValue(result));
   } else {
       UE_LOG(LogTemp, Error, TEXT("%s"), *(result::getError(result).message));
   }
   });

In this example, we're using the ``getBalance`` method with ``TFunction`` parameter. You can also use another overloaded version of this method which takes delegates as parameters.

This code will print your balance if the call succeeds, and print an error otherwise.

Getting unspent transaction outputs
-----------------------------------

Okay, now we will try to find unspent transaction outputs for our wallet.

Put the code below inside the ``RunSomeLogic`` method:

.. code-block:: cpp

   stratisManager->getCoins([](const auto &result) {
       if (result::isSuccessful(result)) {
           const auto &utxos = result::getValue(result);

           for (const auto &utxo : utxos) {
               UE_LOG(LogTemp, Display, TEXT("UTXO #%i, hash: %s, satoshis: %llu"),
                       utxo.n, *(utxo.hash), utxo.satoshis);
           }

       } else {
           UE_LOG(LogTemp, Error, TEXT("%s"), *(result::getError(result).message));
       }
   });

Here we're using a range-based for loop to iterate over **TArray** of **FUTXO** items.

This code will print all of your utxos to log console one-by-one if the call is successful, and print error otherwise.

Sending coins & waiting for a receipt
-------------------------------------

Now let's try to implement a more complex logic: send some coins *and* await for transaction's receipt.

At first, define a couple of variables:


* ``destinationAddress``\ : in this example, we're using ``tD5aDZSu4Go4A23R7VsjuJTL51YMyeoLyS`` for **Cirrus Test network**
* ``amount``\ : the number of satoshis we want to send. Let's send 10.000 satoshis (= 0.0001 STRAX).

.. code-block:: cpp

   FString destinationAddress(TEXT("tD5aDZSu4Go4A23R7VsjuJTL51YMyeoLyS"));
   int64 amount = 10000;

Now, send ``amount`` of coins to ``destinationAddress`` with the code shown below:

.. code-block:: cpp

   stratisManager->sendCoinsTransaction(
         destinationAddress, amount, [this](const auto &result) {
           if (result::isSuccessful(result)) {
             const auto &transactionID = result::getValue(result);

             // TODO: now we need to await receipt

           } else {
             UE_LOG(LogTemp, Error, TEXT("%s"),
                    *(result::getError(result).message));
           }
         });

Well, now we want to know when the receipt for this transaction is available.
To achieve this, use the code shown below:

.. code-block:: cpp

   this->stratisManager->waitTillReceiptAvailable(
       transactionID, [transactionID](const auto &result) {
       if (result::isSuccessful(result)) {
           UE_LOG(LogTemp, Display,
                   TEXT("Coins had been sent successfuly, transaction "
                       "id: %s"),
                   *transactionID);
       } else {
           UE_LOG(LogTemp, Error, TEXT("%s"),
                   *(result::getError(result).message));
       }
       });

What's next?
------------

In this tutorial, we've learned how to use some core plugin functions: get balance, send coins, and wait for a receipt. In the next tutorial, we'll cover more advanced functionality of the plugin - interacting with smart contracts.

If you found a problem, you can `open an issue <https://github.com/stratisproject/UnrealEnginePlugin/issues>`_ on the project's Github page.
If you still have questions, feel free to ask them in `our Discord channel <https://discord.gg/9tDyfZs>`_.

Stay tuned!
