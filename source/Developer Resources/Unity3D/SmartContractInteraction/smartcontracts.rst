====================================
Stratis Smart Contracts with Unity3D
====================================

Stratis Smart Contracts are enabled on Cirrus Main and Cirrus Test
networks. Only whitelisted smart contracts can be deployed. A list of
whitelisted smart contracts can be found here:
https://github.com/stratisproject/CirrusSmartContracts

You can also check if Smart Contract is whitelisted using
``/api/Voting/whitelistedhashes``. 

For example if you run node on CirrusTest; this link will provide you with list of hashes of whitelisted
contracts: http://localhost:38223/api/Voting/whitelistedhashes

What is required to work with Stratis Smart Contracts
=====================================================


For this tutorial you need some coins in your Cirrus wallet.

When you deploy or call smart contracts you are creating a transaction which
requires a fee. So before you proceed make sure you have some CRS or
TCRS (TCRS for Testnet) deposited to your address.

This can be obtained from members of the community in the `Stratis Discord Server <https://discord.gg/P5ZsX37M4X>`_

The following code generates your address and then displays it in the debug
console.

.. code-block:: csharp

      Network network = new CirrusTest();

      StratisNodeClient client = new StratisNodeClient("https://cirrustest-api-ha.stratisplatform.com/");

      Mnemonic mnemonic = new Mnemonic("legal door leopard fire attract stove similar response photo prize seminar frown", Wordlist.English);

      StratisUnityManager stratisUnityManager = new StratisUnityManager(client, new BlockCoreApi("https://cirrustestindexer.stratisnetwork.com/api/"), network, mnemonic);

      Debug.Log("Your address: " + stratisUnityManager.GetAddress());


Transaction-level API
=====================

At first, let's see how we can interact with smart contracts using low-level (i.e. transaction-level) API.

Deploying Smart Contracts
-------------------------

To deploy a smart contract you need to use ``stratisUnityManager.SendCreateContractTransactionAsync`` which returns the txId after execution. That txId can be used to get a receipt once the transaction has been executed. 

.. code-block:: csharp

    public async Task<string> SendCreateContractTransactionAsync(
        string contractCode, 
        string[] parameters = null,
        Money amount = null)

* 
  ``contractCode`` - hex-encoded bytecode of the contract. You can compile your contract using `sct tool <https://academy.stratisplatform.com/Architecture%20Reference/SmartContracts/working-with-contracts.html#compiling-a-contract>`_\ , 
  or you can use one of the whitelisted contracts from the ``WhitelistedContracts`` class.

* 
  ``parameters`` - `serialized <https://academy.stratisplatform.com/Architecture%20Reference/SmartContracts/working-with-contracts.html#parameter-serialization>`_ arguments passed to contract's constructor.
  Supported data types described in ``MethodParameterDataType`` enum.

* 
  ``money`` - the number of satoshis to deposit on the contract's balance.

* 
  **Returns**  ``transactionID`` of contract creation.


For example here is how to deploy StandardToken contract: 

.. code-block:: csharp

        List<string> constructorParameter = new List<string>()
        {
            $"{(int)MethodParameterDataType.ULong}#1000000",
            $"{(int)MethodParameterDataType.String}#TestToken",
            $"{(int)MethodParameterDataType.String}#TT",
            $"{(int)MethodParameterDataType.UInt}#8"
        };

        string txId = await stratisUnityManager.SendCreateContractTransactionAsync(WhitelistedContracts.StandartTokenContract.ByteCode, constructorParameter.ToArray(), 0).ConfigureAwait(false);
        Debug.Log("Contract deployment tx sent. TxId: " + txId);

And once transaction is confirmed you can use transactionId to query the receipt as shown below.

.. code-block:: csharp

    ReceiptResponse receipt = await
    client.ReceiptAsync("95b9c1e8ab28071b750ab61a3647954b0476d75173d91d0c8db0267c4894d1f6").ConfigureAwait(false);

    string contractAddr = receipt.NewContractAddress;

Using Smart Contracts
---------------------

There are two ways to interact with a Smart Contract: call and local call. Calls should be used when you want to change a smart contract's state. Local calls are used to get data from smart contract and using them doesn't result in creating an on-chain transaction, nor any associated cost. 

To make local call, we need to use the ``Unity3dClient.LocalCallAsync`` method, which takes ``LocalCallContractRequest`` argument and returns ``LocalExecutionResult``.

Here is an example of making local call: 

.. code-block:: csharp

    var localCallData = new LocalCallContractRequest() { 
        GasPrice = 10000,
        Amount = "0", 
        GasLimit = 250000, 
        ContractAddress = contractAddr,
        MethodName = "MaxVotingDuration", 
        Sender = stratisUnityManager.GetAddress().ToString(), 
        Parameters = new List() 
    };

    LocalExecutionResult localCallResult = await client.LocalCallAsync(
        localCallData).ConfigureAwait(false);

    Debug.Log("MaxVotingDuration: " + localCallResult.Return.ToString());

To make a call that will push some data on-chain we need to use ``stratisUnityManager.SendCallContractTransactionAsync`` method:

.. code-block:: csharp

    public async Task<string> SendCallContractTransactionAsync(
        string contractAddr, 
        string methodName, 
        string[] parameters = null, 
        Money amount = null)

The below is an example of making an on-chain call: 

.. code-block:: csharp
    
    string contractAddress = "CNiJEPppjvBf1zAAyjcLD81QbVd8NQ59Bv";
    string methodName = "WhitelistAddress";
    string whitelistAddress = "CPokn4GjJHtM7t2b99pdsbLuGd4RbM7pGL";
    string[] parameters = new string[] {
        $"{(int)MethodParameterDataType.Address}#{whitelistAddress}"
    };

    string callId = await stratisUnityManager.SendCallContractTransactionAsync(
        contractAddress, 
        methodName, 
        parameters).ConfigureAwait(false);

For more information, you can check examples in `TestSmartContracts.cs <https://github.com/stratisproject/Unity3dIntegration/blob/main/Src/StratisUnity3d/Assets/Code/Examples/TestSmartContracts.cs>`_

Smart Contract Wrappers
=======================

Although, we can use any method of any of smart contracts with 3 methods we discussed above (*deploy, call and local call*), 
that requires a lot of boilerplate code for each call.

That's why we have wrappers for some of the white-listed contracts, such as the NFT (SRC-721) or the StandardToken (SRC-20) contracts.
These wrappers encapsulates all of necessary boilerplate, giving you a simple and powerful interface.

Here is an example for StandardToken Wrapper that displays information about target StandardToken: 

.. code-block:: csharp

    string standartTokenAddr = "tLG1Eap1f7H5tnRwhs58Jn7NVDrP3YTgrg";
    StandartTokenWrapper stw = new StandartTokenWrapper(stratisUnityManager, standartTokenAddr);

    Debug.Log("Symbol: " + await stw.GetSymbolAsync()); 
    Debug.Log("Name: " + await stw.GetNameAsync()); 
    Debug.Log("TotalSupply: " + await stw.GetTotalSupplyAsync()); 
    Debug.Log("Balance: " + await stw.GetBalanceAsync(firstAddress)); 
    Debug.Log("Decimals: " + await stw.GetDecimalsAsync());

Here is an example for a NFT Contract and minting a new NFT: 

.. code-block:: csharp

    string nftAddr = "t8snCz4kQgovGTAGReAryt863NwEYqjJqy";
    string uri = "https://stratisplatorm.com/content/nftcollction/demonft.png";
    string nftContractAddress = "tRxYDrnKGAKcrSrc1VQMoKa28RSGUXywP5"; 
    string firstAddress = "t8ehx5Nm4QXeRhzt92ATTgCRc1zDkFXAdw";

    NFTWrapper nft = new NFTWrapper(stratisUnityManager, nftAddr);

    UInt256 balanceBefore = await nft.BalanceOfAsync(firstAddress);
    Debug.Log("NFT balance: " + balanceBefore);

    string mintId = await nft.MintAsync(firstAddress, uri);

    await stratisUnityManager.WaitTillReceiptAvailable(mintId);

    UInt256 balanceAfter = await nft.BalanceOfAsync(firstAddress);

    Assert.IsTrue(balanceAfter == balanceBefore + 1); 

For more examples, you can check in `SCInteractTest.cs <https://github.com/stratisproject/Unity3dIntegration/blob/main/Src/StratisUnity3d/Assets/Code/Examples/SCInteractTest.cs>`_

Examples
========

You can find full listings for smart contract examples in the Examples
folder.

`\Assets\Code\Examples\TestSmartContracts.cs` - general example that
covers contract deployment and interaction.

`\Assets\Code\Examples\SCInteractTest.cs` - example that covers NFT
and StandartToken contracts deployment and interaction.

To run those examples just add their scripts to any object in your scene
or use prebuilt scenes from ``\Assets\Scenes``.
