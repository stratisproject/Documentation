#####################################
Working with Contracts
#####################################

Writing a contract
-------------------
Stratis smart contracts are CIL bytecode that is executed on top of the dotnet core runtime. Tooling and support is currently provided for writing and compiling contracts in the C# language.

Contracts can be written in any editor that supports C#, however Visual Studio is the recommended contract development environment.

Installing the Visual Studio Project Template 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
There is a Visual Studio Project Template that provides an easy way to create a new smart contract project. The template can be `found on the Visual Studio marketplace <https://marketplace.visualstudio.com/items?itemName=StratisGroupLtd.StratisSmartContractsTemplate>`_.

Validating a contract
-------------------
A Stratis smart contract must not contain any non-deterministic elements. This restricts the standard .NET libraries that can be used when writing a contract. There are additional constraints around the format of the contract that are required to be met before it can be executed. 

All contracts are validated by a node when the contract is being deployed. Invalid contracts will fail validation on-chain. Because of this, it is recommended to validate contracts locally before deployment. 

Validation can be done using the ``sct`` command line tool.

::

  cd src/Stratis.SmartContracts.Tools.Sct
  dotnet run -- validate [CONTRACT_PATH_HERE]

Compiling a contract
-------------------
Contracts can be compiled using the ``sct`` command line tool.

::

  cd src/Stratis.SmartContracts.Tools.Sct
  dotnet run -- compile [CONTRACT_PATH_HERE]

Deploying a contract
-------------------
Contracts can be deployed in several ways:

* Using the ``sct`` command line tool
* Via the swagger API
* Via the wallet

Interacting with a contract
-------------------
The easiest way to interact with a contract is to use the Stratis Core wallet with smart contracts enabled.

- Local calls

Parameter Serialization
-------------------

When deploying or interacting with a contract via the wallet, the API, or SCT, contract parameters must be provided as a string. This requires that a parameter is serialized to a string in the format that the API is expecting.

Additionally, when using the API or SCT, the type of each parameter must be provided in the format "{0}#{1}", where: {0} is an integer representing the Type of the serialized data and {1} is the serialized data itself.

Refer to the following table for the mapping between a type, its integer representation, serializer and an example.

.. csv-table:: Param Type Serialization
  :header: "Type", "Integer representing
   serialized type", "Serializer", "Example"

  System.Boolean, 1, System.Boolean.ToString(), "1#true"
  System.Byte, 2, System.Byte.ToString(), "2#255"
  System.Char, 3, System.Char.ToString(), "3#c"
  System.String, 4, System.String, "4#Stratis"
  System.UInt32, 5, System.UInt32.ToString(), "5#123"
  System.Int32, 6, System.Int32.ToString(), "6#-123"
  System.UInt64, 7, System.UInt64.ToString(), "7#456"
  System.Int64, 8, System.Int64.ToString(), "8#-456"
  Stratis.SmartContracts.Address, 9, Base58Address.ToString(), "9#mtXWDB6k5yC5v7TcwKZHB89SUp85yCKshy"
  System.Byte[], 10, BitConverter.ToString(), "10#04A6B9"

The parameters must be provided in the order they occur in the method signature. For example, calling a method with the signature ``SomeMethod(Address myAddress, byte[] someData)`` with the values ``myAddress = mtXWDB6k5yC5v7TcwKZHB89SUp85yCKshy``, ``someData = 0xFF00AA`` looks like:

In the API:
::

  parameters: [
    "9#mtXWDB6k5yC5v7TcwKZHB89SUp85yCKshy",
    "10#FF00AA"
  ]

As parameters to SCT:
::

  -param="9#mtXWDB6k5yC5v7TcwKZHB89SUp85yCKshy" -param="10#FF00AA"

In the wallet:

.. figure:: wallet-params.png
    :alt: Wallet Params
    :align: center

    Entering contract parameters in the wallet

Testing a contract
-------------------


Gas
-------------------
Gas fees charged
Gas fees and refunds and where they end up on a transaction (coinbase)

SmartContract object
---------------
What the diff fields are etc