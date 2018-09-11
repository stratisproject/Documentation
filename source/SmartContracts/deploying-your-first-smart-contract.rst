###############################
Deploying Your First Smart Contract
###############################

This chapter takes you through deploying a smart contract, which simulates an auction. The smart contract is provided as a Visual Studio Project Template. As part of the deployment process, the smart contract is validated to ensure it does not contain any non-deterministic elements. Once deployed, a bid is then placed on the auction to test that the smart contract was deployed correctly. The steps taken when deploying the smart contract are as follows:

1. Download or clone the source.
2. Installing the Visual Studio Project Template. 
3. Create a smart contracts project, which will include an auction smart contract and unit tests.
4. Validate the smart contract with the smart contract tool (SCT).
5. Run the smart contract enabled version of the full node.
6. Get the funds to deploy the auction smart contract and place a bid.
7. Build and deploy the smart contract.
8. Place a bid.
9. Check the bid has been stored on the test network.

.. note::
    This chapter assumes a Windows development environment. Stratis smart contracts can be developed on other platforms, and documentation to support this will be available soon.

Downloading the smart contract source
-------------------------------------

First, download a copy of `Microsoft Visual Studio <https://www.visualstudio.com/downloads/>`_ if you don't have a copy already. This is the standard IDE for C# development and the Community Edition is available for free.

Next, make sure you have the latest .NET SDK installed. You can verify this by running ``dotnet --version`` on the command line. If you do not have the .NET SDK installed, download and install it from `here <https://www.microsoft.com/net/learn/get-started/windows#install>`_.

Next, you must download or clone the `latest alpha branch of the Stratis Smart Contract Enabled Full Node <https://github.com/stratisproject/StratisBitcoinFullNode/tree/sc-alpha-latest>`_. This repository contains everything you need to run a Stratis full node that can sync and mine on a Stratis smart contract network. It also contains the ``sct`` tool, which validates and deploys contracts.

::

  git clone https://github.com/stratisproject/StratisBitcoinFullNode.git
  git checkout sc-alpha-latest


Installing the Visual Studio Project Template 
---------------------------------------------

The Stratis smart contract Visual Studio Project Template provides an easy way to create a new smart contract project. It contains a template for a smart contract, unit tests, and references to appropriate NuGet packages.

The template can be `found on the Visual Studio marketplace <https://marketplace.visualstudio.com/items?itemName=StratisGroupLtd.StratisSmartContractsTemplate>`_.

Creating a smart contracts project
----------------------------------

To create a new smart contracts project, navigate to File > New > Project… and create a new ‘Stratis SmartContract Project’ under ‘Visual C#’. This generates a new solution containing Auction.cs and some sample unit tests. Notice that Auction.cs just contains a C# class called Auction. Later, you will explore the individual properties and methods on this class in detail.

Validating your smart contract
------------------------------

When you attempt to deploy a smart contract by including it in a transaction, it is tested to see if its C# code is correct and deterministic. Mining nodes carry out this testing before they include a smart contract transaction in a block. In addition, other nodes on the network attempt to validate any smart contracts that they find in any blocks they receive. If the smart contracts are not valid, the entire block is rejected. Therefore, you will want to know your smart contract meets the validation criteria before you try and deploy it. Stratis provides SCT (a command-line tool) for validating and building smart contracts.

The SCT tool is located within the source code of the full node that was cloned earlier. Navigate to this source code directory, and then change into the SCT project directory:

::

  cd src/Stratis.SmartContracts.Tools.Sct

You are now going to validate the auction smart contract and request to see its byte code. When you begin writing your own smart contracts, you will also carry out this step for them before you deploy. Right click on your Auction.cs file tab in Visual Studio and click ‘Copy Path’. Then, back on the command line, use the ``validate`` command:

::

  dotnet run -- validate [PASTE_YOUR_PATH HERE] -sb

You should see the following output:

::

  ====== Smart Contract Validation results for file [YOUR_FILE_PATH] ======
  Compilation Result
  Compilation OK: True

  Format Validation Result
  Format Valid: True

  Determinism Validation Result
  Determinism Valid: True

  ByteCode
  4D5A90000300000004000000F...
  
Congratulations! You have compiled your first smart contract in C#. The bytecode is a hexadecimal representation of the .NET IL compiled for this contract and is all you need to deploy your contract on a network (provided you have a node running).

To further understand why this tool is important, go back to your contract and add this line in the constructor:

::

  var test = DateTime.Now;

And this line at the top of the Auction.cs file:

::

  using System;  


So why is the first line problematic inside a smart contract? Different nodes are going to execute the code at different times and because of this, they all receive a different result for ``DateTime.Now``. If this value was persisted in some way, all of the nodes would receive a different outcome for the contract state and would fail to reach a consensus.

Make sure you have saved Auction.cs and run the validation command again. SCT recognizes this non-deterministic call:

::

  ====== Smart Contract Validation results for file [YOUR_FILE_PATH] ======
  Compilation Result
  Compilation OK: True

  Format Validation Result
  Format Valid: True

  Determinism Validation Result
  Determinism Valid: False

  .ctor:
     System.DateTime System.DateTime::get_Now() is non-deterministic.
   
Now back out the non-deterministic code and resave.

More about the SCT
^^^^^^^^^^^^^^^^^^

The SCT uses 3 commands:

+---------+-----------------------------------------------------------+
|Command  |Description                                                |
+=========+===========================================================+
|build    |Builds a contract and outputs a dll. For testing purposes. |
+---------+-----------------------------------------------------------+
|deploy   |Deploys a smart contract to the given node.                |
+---------+-----------------------------------------------------------+
|validate |Validates smart contracts for structure and determinism.   |
+---------+-----------------------------------------------------------+

The SCT provides further information on using these commands. For example, the following usage requests help on the validate command:

::

 dotnet run -- validate  --help

Running a smart contract enabled version of the Stratis full node
-----------------------------------------------------------------

To interact with the smart contract test network, you now need to build the smart contract daemon. This is the Stratis.StratisSmartContractsD project in the `sc-alpha branch of the Stratis Smart Contract Enabled Full Node <https://github.com/stratisproject/StratisBitcoinFullNode/tree/sc-alpha>`_, which you either downloaded or cloned. When the project is built, run the daemon as follows:

::

  cd src/Stratis.StratisSmartContractsD
  dotnet run -- -addnode=13.64.119.220 -addnode=20.190.57.145 -addnode=40.68.165.12

Adding the three nodes attempts to connect the daemon to the smart contract test network. 

.. note::
  The smart contract test network is a testing environment and its uptime may fluctuate. For the most up-to-date information on the test network status, join us on Discord: :ref:`support_and_community`.

Getting the funds to deploy smart contracts
-------------------------------------------

To deploy a smart contract you need funds to pay the transaction fees and the gas to run the smart contract. In this case, you are also going to test the smart contract out by placing a bid, which involves calling one of its methods. There is additional expenditure involved here because you must pay for:

1. The amount you are going to bid.
2. The transaction fees involved when making the bid (sending money to a deployed auction smart contract).
3. The gas to run the smart contract method.

To get funds, you must first create a wallet and then request the funds. The next two subsections detail how to do this.

Creating a wallet
^^^^^^^^^^^^^^^^^

Because the smart contract API hasn't been integrated with any GUI wallets yet, you must use the API directly via Swagger. Whilst your node is running, navigate to `http://localhost:38220/swagger <http://localhost:38220/swagger>`_.

To create a wallet, navigate to the Wallet section and use the `/api/Wallet/create` call. You only need to specify a name and password in the request. For example:

::

  {
    "name": "Satoshi",
    "password": "password"
  }

You now have a wallet containing some TSTRAT addresses. To see the addresses, use the `/api/Wallet/addresses` call, which is also found in the Wallet section. You just need to specify your wallet name and an AccountName of "account 0".

Getting funds 
^^^^^^^^^^^^^

The easiest way to get some TSTRAT is use the `smart contracts faucet <https://smartcontractsfaucet.stratisplatform.com/>`_. To receive 100 TSTRAT, specify a TSTRAT address from your wallet. Make a note of the address you use. Use this TSTRAT address for deploying and testing the smart contract.  

Alternatively, if you want to get more involved and earn some TSTRAT along the way, feel free to start mining! To begin mining, restart your node with an address from your wallet:

::

  dotnet run -- -addnode=13.64.119.220 -addnode=20.190.57.145 -addnode=40.68.165.12 -mine=1 -mineaddress=[YOUR_WALLET_ADDRESS]
  
Use the TSTRAT address you use for the mine address when deploying and testing the smart contract. 

Deploying the auction smart contract
------------------------------------

While you deploy your smart contract, it is important to remember that deploying a smart contract involves several steps:

* Compiling the contract.
* Validating the contract.
* Creating a transaction which contains the contract’s code.
* Broadcasting the transaction to the network.

From the command-line, you can use the ``deploy`` command to achieve all these steps:

::

  dotnet run -- deploy [PATH_TO_SMART_CONTRACT] http://localhost:38220 -wallet [YOUR_WALLET_NAME] -password [YOUR_PASSWORD] -fee 0.002 -sender=[YOUR_WALLET_ADDRESS] -params=[CONSTRUCTOR_PARAMS_IF_REQUIRED]
  
As before, when you were validating the auction smart contract, you need to obtain the path to the Auction.cs file. However, because the Auction C# class contains a constructor parameter, ``durationBlocks``, you must pass this value as well. The ``durationBlocks`` parameter specifies how many blocks are added to blockchain before the auction ends. In the following example, 20 blocks are added to the blockchain before the auction ends:

::

  dotnet run -- deploy PATH_TO_SMART_CONTRACT http://localhost:38220 -wallet [YOUR_WALLET_NAME] -password [YOUR_PASSWORD] -fee 0.002 -sender=[YOUR_WALLET_ADDRESS] -params="10#20"
  
A value of 20 is used because blocks are not confirmed until they are 5 blocks deep. Until the block which the smart contract is in has been confirmed, you cannot run the smart contract. You will notice that the value of 20 is preceeded by 10#. This information is part of the ``durationBlocks`` constructor parameter. More information on specifying constructor parameters is given in `Specifying smart contract constructor parameters`_. 

When you deploy the smart contract, you should also check the block height. To do this, find the Consensus.Height in the Node Stats of the full node output. Keep checking the block height. After Consensus.Height has incremented by 5, you can be sure the smart contract has been deployed.

The tool returns the address of the contract if the contract was deployed successfully. Make sure you record this as you are going to use it when you place a bid.

Specifying smart contract constructor parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Smart contract parameters are serialized into a string. The format of each parameter is "{0}#{1}" where: {0} is an integer representing the Type of the serialized data and {1} is the serialized data itself. Serialized array values are separated by a dash ``-`` character.

These params must be serialized into a string. The format of each parameter is "{0}#{1}", where {0} is an integer representing the Type of the serialized data, and {1} is the serialized data itself.

Multiple params must be specified in order and can be done like so: ``-param="7#abc" -param="8#123"``.

Currently, only certain types of data can be serialized. Refer to the following table for the mapping between a type and its integer representation.

.. csv-table:: Param Type Serialization
  :header: "Type", "Integer representing
   serialized type", "Serialize to string"

  System.Boolean, 1, System.Boolean.ToString()
  System.Byte, 2, System.Byte.ToString()  
  System.Byte[], 3, BitConverter.ToString()
  System.Char, 4, System.Char.ToString()
  System.SByte, 5, System.SByte.ToString()
  System.Short, 6, System.Short.ToString()
  System.String, 7, System.String
  System.UInt32, 8, System.UInt32.ToString()
  NBitcoin.UInt160, 9, NBitcoin.UInt160.ToString()
  System.UInt64, 10, System.UInt64.ToString()
  Stratis.SmartContracts.Address, 11, Stratis.SmartContracts.Address.ToString()
  System.Int64, 12, System.Int64.ToString()

.. note::
    The requirement to pass in the Type is ugly, but it allows us to resolve overloaded methods easily.

As a further example, imagine a smart contract which has a constructor with the following signature:

::

  public Token(ISmartContractState state, UInt160 owner, UInt64 supply, Byte[] secretBytes)

In addition to the mandatory ISmartContractState, there are 3 parameters which need to be supplied. Assuming they have these values:

* UInt160 owner = 0x95D34980095380851902ccd9A1Fb4C813C2cb639
* UInt64 supply = 1000000
* Byte[] secretBytes = { 0xAD, 0xBC, 0xCD }

The serialized string representation of this data looks like this:

The command for passing these params to sct looks like this:

::

  -param="9#0x95D34980095380851902ccd9A1Fb4C813C2cb639" -param="10#1000000" -param="3#AD-BC-CD"

Placing a bid on the auction smart contract
-------------------------------------------

You can use Swagger to place a bid on the auction smart contract you have deployed. Navigate to the SmartContracts section and use `/api/SmartContracts/build-and-send-call`. For example, the following usage places a bid of 10 TSTRAT.

::

  {
    "walletName": "[YOUR_WALLET_NAME]",
    "contractAddress": "[YOUR_CONTRACT_ADDRESS]",
    "methodName": "Bid",
    "amount": "10",
    "feeAmount": "0.001",
    "password": "[YOUR_PASSWORD]",
    "sender": "[YOUR_WALLET_ADDRESS]",
  }

Once you have placed the bid, you will need to wait for the Consensus.Height to be incremented by another 5 blocks. At this point the bid transaction is confirmed. Finally, you can check the bid is stored on the test network.
 
Checking the bid has been stored on the test network
-----------------------------------------------------

Bids are persisted on each node in the network. You can use a Swagger call to check your bid has been stored on the test network. Navigate to the SmartContracts section and use `/api/SmartContracts/storage`. For the parameters, use the address of your deployed auction smart contract, the string "HighestBid" for the StorageKey, and Ulong for the DataType. A value of 10 should be returned.




