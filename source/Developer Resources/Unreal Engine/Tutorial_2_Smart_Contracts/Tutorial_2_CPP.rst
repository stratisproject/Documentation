
Tutorial #2 - Interacting with smart contracts
==============================================

In this tutorial, we will learn how to deploy and interact with `smart contracts <https://academy.stratisplatform.com/Architecture%20Reference/SmartContracts/smartcontracts-introduction.html>`_ supported by the Stratis blockchain.
Let's get started!

Prerequisite
------------

For this tutorial, you need to fully-setup the ``StratisUnrealManager`` instance, as described in Tutorial #0.

Transaction-level API
---------------------

At first, let's see how we can interact with smart contracts using low-level (i.e. transaction-level) API.

Deploying a smart contract
^^^^^^^^^^^^^^^^^^^^^^^^^^

To deploy a smart contract, we should use the method ``sendCreateContractTransaction``\ :

.. code-block:: cpp

   void UStratisUnrealManager::sendCreateContractTransaction(
       const FString& contractCode, 
       const TArray<FString>& parameters, 
       int64 money,
       TFunction<void(const TResult<FString>&)> callback)

where:


* 
  ``contractCode`` - hex-encoded bytecode of the contract. You can compile your contract using `sct tool <https://academy.stratisplatform.com/Architecture%20Reference/SmartContracts/working-with-contracts.html#compiling-a-contract>`_\ , 
  or you can use one of the whitelisted contracts from the ``UWhitelistedSmartContracts`` class.

* 
  ``parameters`` - `serialized <https://academy.stratisplatform.com/Architecture%20Reference/SmartContracts/working-with-contracts.html#parameter-serialization>`_ arguments passed to contract's constructor.
  You can encode parameters using ``USmartContractsParametersEncoder``.

* 
  ``money`` - the number of satoshis to deposit on the contract's balance.

* 
  ``callback`` - error-aware callback, returns either ``transactionID`` of contract creation or error.

Example:

.. code-block:: cpp

   TArray<FString> parameters{
       USmartContractsParametersEncoder::encodeString(name),
       USmartContractsParametersEncoder::encodeString(symbol),
       USmartContractsParametersEncoder::encodeString(tokenURIFormat),
       USmartContractsParametersEncoder::encodeBoolean(ownerOnlyMinting)};

   this->stratisManager->sendCreateContractTransaction(
       UWhitelistedSmartContracts::GetNFTContractCode(),
       parameters, 
       0,
       [callback](const TResult<FString>& result) { callback(result); });

Calling contract's methods
^^^^^^^^^^^^^^^^^^^^^^^^^^

To call contract's methods, we need to use the ``sendCallContractTransaction`` method:

.. code-block:: cpp

   void UStratisUnrealManager::sendCallContractTransaction(
       const FString& contractAddress, 
       const FString& methodName,
       const TArray<FString>& parameters, 
       uint64 money,
       TFunction<void(const TResult<FString>&)> callback)

where:


* ``contractAddress`` - transaction ID of contract deployment transaction
* ``methodName`` - name of the method we want to call.
* ``parameters`` - serialized parameters list. See more in **Deploying smart contract** section.
* ``money`` - amount of satoshis to send to contract.
* 
  ``callback`` - error-aware callback, returns either ``transactionID`` of contract call or error.

  Example:

  .. code-block:: cpp

     this->stratisManager->sendCallContractTransaction(
          /* contractAddress */ this->contractAddress, 
          /* methodName */ TEXT("TransferFrom"),
          /* parameters */ {
              USmartContractsParametersEncoder::encodeAddress(fromAddress),
              USmartContractsParametersEncoder::encodeAddress(toAddress),
              USmartContractsParametersEncoder::encodeULong(tokenID)
          },
          /* money */ 0, 
          /* callback */ [callback](const TResult<FString>& result) { callback(result); });

Making a local call
^^^^^^^^^^^^^^^^^^^

Sometimes, we want to get some information from the smart contract, but we don't want to post any updates to the blockchain. In this case, we can use a `local call functionality <https://academy.stratisplatform.com/Architecture%20Reference/SmartContracts/working-with-contracts.html#calls-and-local-calls>`_.

To make a local call, we need to use the ``makeLocalCall`` method:

.. code-block:: cpp

   void UStratisUnrealManager::makeLocalCall(
       const FLocalCallData& data,
       TFunction<void(const TResult<FString>&)> callback)

where: 


* ``data`` - structure containing the all necessary information to resolve smart contract's method call.
* ``callback`` - error-aware callback, returns either string-encoded return value or error.

Example:

.. code-block:: cpp

   FLocalCallData localCallData;
   localCallData.gasPrice = 10000;
   localCallData.gasLimit = 250000;
   localCallData.amount = 0;
   localCallData.contractAddress = this->contractAddress;
   localCallData.methodName = TEXT("Owner");
   localCallData.sender = stratisManager->getAddress();

   this->stratisManager->makeLocalCall(
       localCallData,
       [callback](const TResult<FString>& result) { callback(result); });

Smart contract wrappers
-----------------------

Although, we can use any method of any of smart contracts with 3 methods we discussed above, 
this requires a lot of boilerplate code for each call.

That's why we have wrappers for some of the white-listed contracts, such as the NFT contract.
These wrappers encapsulate all of the necessary boilerplate, giving you a simple and powerful interface.

Conclusion
----------

In this tutorial, we've learned how to interact with smart contracts using low-level and high-level APIs. 
In the next tutorial we will see how we can use Stratis Unreal plugin to integrate NFT into your game.

If you found a problem, you can `open an issue <https://github.com/stratisproject/UnrealEnginePlugin/issues>`_ on the project's Github page.
If you still have questions, feel free to ask them in `our Discord channel <https://discord.gg/9tDyfZs>`_.

Stay tuned!
