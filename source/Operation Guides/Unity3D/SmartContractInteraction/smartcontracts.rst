Stratis Smart Contracts with Unity3D
====================================

Stratis Smart Contracts are enabled on Cirrus Main and Cirrus Test
networks. Only whitelisted smart contracts can be deployed. A list of
whitelisted smart contracts can be found here:
https://github.com/stratisproject/CirrusSmartContracts

You can also check if Smart Contract is whitelisted using
``/api/Voting/whitelistedhashes``. 

For example if you run node on CirrusTest; this link will provide you with list of hashes of whitelisted
contracts: http://localhost:38223/api/Voting/whitelistedhashes\`

What is required to work with Stratis Smart Contracts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The `Stratis Unity Integration <https://academy.stratisplatform.com/Operation%20Guides/Unity3D/Integration/unitytutorial.html>`_ guide can be followed to setup your local environment for development.

Deploying Smart Contracts
~~~~~~~~~~~~~~~~~~~~~~~~~

When you deploy smart contracts you are creating a transaction which
requires a fee. So before you proceed make sure you have some STRAX or
TSTRAX (STRAX on testnet) deposited to your address.

This can be obtained from members of the community in the `Stratis Discord Server <https://discord.gg/P5ZsX37M4X>`_

The following code generates your address and then displays it in the debug
console.

::

    c# Unity3dClient Client = new
    Unity3dClient("http://localhost:44336/");

    Mnemonic mnemonic = new Mnemonic("legal door leopard fire attract stove
    similar response photo prize seminar frown", Wordlist.English);

    StratisUnityManager stratisUnityManager = new
    StratisUnityManager(client, network, mnemonic);

    Debug.Log("Your address: " + stratisUnityManager.GetAddress());

To deploy a smart contract you need to use ``stratisUnityManager.SendCreateContractTransactionAsync`` which returns the txId after execution. That txId can be used to get a receipt once the transaction has been executed. 

For example here is how to deploy StandardToken contract: 

::

        List<string> constructorParameter = new List<string>()
        {
            $"{(int)MethodParameterDataType.ULong}#1000000",
            $"{(int)MethodParameterDataType.String}#TestToken",
            $"{(int)MethodParameterDataType.String}#TT",
            $"{(int)MethodParameterDataType.UInt}#8"
        };

        string txId = await stratisUnityManager.SendCreateContractTransactionAsync(WhitelistedContracts.StandartTokenContract.ByteCode, constructorParameter.ToArray(), 0).ConfigureAwait(false);
        Debug.Log("Contract deployment tx sent. TxId: " + txId);

And once transaction is confirmed you can use the below to query the receipt.

::

    ReceiptResponse receipt = await
    client.ReceiptAsync("95b9c1e8ab28071b750ab61a3647954b0476d75173d91d0c8db0267c4894d1f6").ConfigureAwait(false);

    string contractAddr = receipt.NewContractAddress;

Also there are wrappers for smart contracts that perform constructor parameter encoding for you. You can check `StandartTokenWrapper` and `NFTWrapper` for examples.  Here is StandardToken deployment example using a wrapper: 

::

    await NFTWrapper.DeployNFTContractAsync(this.stratisUnityManager, "TestNFT", "TNFT", "TestNFT\_{0}", false);

Using Smart Contracts
~~~~~~~~~~~~~~~~~~~~~~~~

There are two ways to interact with a Smart Contract: call and local call. Calls should be used when you want to change a smart contract's state. Local calls are used to get data from smart contract and using them doesn't result in creating an on-chain transaction, nor any associated cost. 

Here is an example of making local call: 

::

    var localCallData = new LocalCallContractRequest() { GasPrice = 10000,
    Amount = "0", GasLimit = 250000, ContractAddress = contractAddr,
    MethodName = "MaxVotingDuration", Sender =
    stratisUnityManager.GetAddress().ToString(), Parameters = new List() };

    LocalExecutionResult localCallResult = await
    client.LocalCallAsync(localCallData).ConfigureAwait(false);
    Debug.Log("MaxVotingDuration: " + localCallResult.Return.ToString());

The below is an example of making an on-chain call: 

::

    // Make an on-chain smart contract call. string callId = await
    stratisUnityManager.SendCallContractTransactionAsync("CNiJEPppjvBf1zAAyjcLD81QbVd8NQ59Bv","WhitelistAddress",
    new string[]
    {"9#CPokn4GjJHtM7t2b99pdsbLuGd4RbM7pGL"}).ConfigureAwait(false);

For more information, you can check examples in `TestSmartContracts.cs <https://github.com/stratisproject/Unity3dIntegration/blob/main/Src/StratisUnity3d/Assets/Code/Examples/TestSmartContracts.cs>`_

Using Smart Contracts via Wrappers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NFT and StandartToken contracts have wrappers to make it easier to interact with them. A Wrapper is a class that constructs call parameters and makes a call, further simplifying the process. 

Here is an example for StandardToken Wrapper that displays information about target StandardToken: 

::

    string standartTokenAddr = "tLG1Eap1f7H5tnRwhs58Jn7NVDrP3YTgrg";
    StandartTokenWrapper stw = new StandartTokenWrapper(stratisUnityManager,
    standartTokenAddr);

    Debug.Log("Symbol: " + await stw.GetSymbolAsync()); Debug.Log("Name: " +
    await stw.GetNameAsync()); Debug.Log("TotalSupply: " + await
    stw.GetTotalSupplyAsync()); Debug.Log("Balance: " + await
    stw.GetBalanceAsync(firstAddress)); Debug.Log("Decimals: " + await
    stw.GetDecimalsAsync());

Here is an example for a NFT Contract and minting a new NFT: 

::

    string nftAddr = "t8snCz4kQgovGTAGReAryt863NwEYqjJqy"; NFTWrapper nft =
    new NFTWrapper(stratisUnityManager, nftAddr);

    ulong balanceBefore = await
    nft.BalanceOfAsync(this.firstAddress).ConfigureAwait(false);
    Debug.Log("NFT balance: " + balanceBefore);

    string mintId = await nft.MintAsync(firstAddress).ConfigureAwait(false);

    await this.WaitTillReceiptAvailable(mintId).ConfigureAwait(false);

    ulong balanceAfter = await
    nft.BalanceOfAsync(this.firstAddress).ConfigureAwait(false);

    Assert.IsTrue(balanceAfter == balanceBefore + 1); 

For more examples, you can check in `SCInteractTest.cs <https://github.com/stratisproject/Unity3dIntegration/blob/main/Src/StratisUnity3d/Assets/Code/Examples/SCInteractTest.cs>`_

Examples
~~~~~~~~

You can find full listings for smart contract examples in the Examples
folder.

`\Assets\Code\Examples\TestSmartContracts.cs` - general example that
covers contract deployment and interaction.

`\Assets\Code\Examples\SCInteractTest.cs` - example that covers NFT
and StandartToken contracts deployment and interaction.

To run those examples just add their scripts to any object in your scene
or use prebuilt scenes from ``\Assets\Scenes``.
