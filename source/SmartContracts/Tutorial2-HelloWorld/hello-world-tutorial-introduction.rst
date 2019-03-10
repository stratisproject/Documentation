**********************************************************
Smart Contract Tutorial 2 - A "Hello World" smart contract
**********************************************************

The next tutorial in the series looks at a classic "Hello World" program.

Commonly, "Hello World" programs are very simple and consist of just one function, which outputs a string. However, because of the nature of smart contracts, this example is slightly more complicated, and we will take an opportunity to see how smart contracts are built from C# classes. Every interaction with a smart contract is made via a method call to the smart contract including its deployment. There is a limit of one call in any transaction.

If you are unfamiliar with any of the following C# topics, the following links will help you as you progress through the tutorial:

* `C# Classes <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/classes>`_
* `C# Inheritance <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/inheritance>`_
* `Class Constructors <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/constructors>`_
* `Property Getters and Setters <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/using-properties>`_

You can find the source code for the "Hello World" smart contract examples in the `Stratis.SmartContracts.Examples.HelloWord <https://github.com/stratisproject/StratisBitcoinFullNode/tree/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld>`_ project, which is included in the ``LSC-tutorial`` branch of the Stratis Full Node. For this tutorial, you will study, build, and deploy `HelloWorld.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld/HelloWorld.cs>`_. 

How the concept of a class links to a smart contract
=====================================================

Smart contracts in C# are intriniscally linked to object oriented design even when they are very basic.

The smart contract constructor
================================

Being object oriented also enables smart contracts to inherit methods and properties. This allows a level of basic smart contract functionality to be readily available to all smart contracts via base class methods and properties.

Deployment of the smart contract involves calling the constructor for the smart contract class. This is when any initialization of the smart contract should take place. Before we look at what the constructor does, let's examine its syntax.

Firstly, as previously mentioned, all smart contracts in C# inherit from ``SmartContract``. It is mandatory to include the following line at the top of the file:

::

    using Stratis.SmartContracts;

This allows a smart contract to inherit from the base ``SmartContract`` class. Your project will need to reference the ``Stratis.SmartContracts`` nuget package.

The class declaration specifies that your class inherits from the ``SmartContract`` class:

::

    [Deploy]
    public class HelloWorld : SmartContract
    {
        ...
    }

The ``[Deploy]`` attribute only needs to be specified when more than one class is declared in the file, but specifying it anyway is fine. When a smart contract is deployed, the entire cs file is compiled into Common Intermediate Language (CIL), which is then supplied to the deployment call.

::

    public HelloWorld(ISmartContractState smartContractState)
        : base(smartContractState)
    {
        ...
    }

The first parameter passed to the constructor must be an object conforming to the ``ISmartContractState`` interface. You can define additional parameters, and when you deploy the smart contract, you only need to specify the parameters you defined. The first parameter is handled internally. The ``base`` constructor (the ``SmartContract`` constructor) must also be called with the ``ISmartContractState`` parameter and you can see this in the code above. The name of the first parameter could theorectically be changed, but ``smartContractState`` will work fine.

In our Hello World example, we do one thing and that is initialize the ``Greeting`` property.

::

    this.Greeting = "Hello World!";

The actual line intiating the ``Greeting`` property if fairly self-explanatory. Let's take a look at the property getter and setters.

::

    private string Greeting
    {
        get 
        {
            return this.PersistentState.GetString("Greeting");
        }
        set
        {
            this.PersistentState.SetString("Greeting", value);
        }
    }

The ``PersistentState`` property belongs to the ``SmartContract`` class and facilitates the storage and retrieval of a string. Smart contract data is stored as a series of key-value pairs and in this case "Greeting" is used as the key. THe ``Greeting`` property is marked as private as there is no need for it to be accessed from anywhere other than inside the smart contract. Unlike methods, C# properties on a smart contract cannot be called even if they are public.

Finally, let's look at the simple method ``Greeting()``, which returns the "Hello World!" string.

.. _compiling-the-hello-world-smart-contract:

Compiling the Hello World Smart Contact
==========================================

A smart contract in C# must be compiled into CIL before it can be deployed. For this, we are going to use the `Stratis sct tool <https://github.com/stratisproject/Stratis.SmartContracts.Tools.Sct>`_. After cloning the repository:

1. Navigate to ``Stratis.SmartContracts.Tools.Sct``.
2. Execute the following command: ``dotnet run -- validate [PATH_TO_SMART_CONTRACT] -sb``. A relative path to ```HelloWorld.cs`` in your Stratis Full Node repository should work fine.
3. Copy the CIL to your clipboard.

To see more information on the options available for the sct ``validate`` command, use the following comand: ``dotnet run -- validate --help`` 

To see the general help on the sct, use the following command: ``dotnet run -- help``

**Picture of CIL**

.. _deploying-the-hello-world-smart-contract:

Deploying the Hello World Smart Contract
===========================================

Begin by making sure that you have a local smart contract network running. You will need funds to deploy the smart contract, and if you get the local network up and running, you should now be in possession of 100,000,000 LSC (Local Smart Contract) tokens! You can deploy the token using Swagger by connecting to either of the two standard  nodes once you have got them running:

* http://localhost:38202/swagger/index.html
* http://localhost:38203/swagger/index.html

You will use the ``/api/SmartContracts/build-and-send-create`` API call to deploy the Smart Contract. This involves filling out the ``BuildCreateContractTransactionRequest`` object. Each member of the object is fully documented in the API. Copy the CIL code you generated in the previous section into the ``contractCode`` field. For the gas limit, specify the maximum value as we are not expending real gas.

Execute the API call, and you should see something like the following:

::

    {
      "newContractAddress": "CWbdDECSwo4m5eDeUbjCXJgWyvtueu2yuM",
      "fee": 12000000,
      "hex": "01000000010932c7ec4b21621bde70a41f33f07bd7a1f5b86ed8100c5962aa6ae534bd886b000000006b483045022100b7f72b0ecb5f8ac693958dc3792fde0d6e0985a1bf294c4a8e3496421aae5b880220586136f599e2bf0380ad3769a9d2fed5ac502c3b60d33e87e00bd5823041cf020121023a8dc138cfb94af04b1d93a4e377ce9f6d619f8ad9b49156887155204371a4baffffffff0200782f51020000001976a9147cdc4138be4e458e2cf2ad581dcbd263f0b1a5cc88ac0000000000000000fd1c0cc0010000006400000000000000a086010000000000f90c04b90c004d5a90000300000004000000ffff0000b800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000e1fba0e00b409cd21b8014ccd21546869732070726f6772616d2063616e6e6f742062652072756e20696e20444f53206d6f64652e0d0d0a2400000000000000504500004c01020034a113eb0000000000000000e00022200b0130000008000000020000000000009e2700000020000000400000000000100020000000020000040000000000000004000000000000000060000000020000000000000300408500001000001000000000100000100000000000001000000000000000000000004c2700004f000000000000000000000000000000000000000000000000000000004000000c000000302700001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002e74657874000000a4070000002000000008000000020000000000000000000000000000200000602e72656c6f6300000c0000000040000000020000000a00000000000000000000000000004000004200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008027000000000000480000000200050074210000bc05000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004602280500000a72010000706f0600000a2a4a02280500000a7201000070036f0700000a2a4602280500000a720d0000706f0600000a2a4a02280500000a720d000070036f0700000a2a00001330030046000000010000110228010000060a020617d6280200000602280100000602280300000632070216280200000602280500000a721b0000700228010000068c09000001280800000a6f0900000a2a000013300300320000000100001102280500000a721b0000700228030000068c09000001280800000a036f0a00000a0228030000060a020617d628040000062a860203280b00000a021628040000060215280200000602722d00007028060000062a1e0228050000062a62020328060000067247000070037257000070280c00000a2a00000042534a4201000100000000000c00000076342e302e33303331390000000005006c0000002c020000237e0000980200000402000023537472696e6773000000009c040000780000002355530014050000100000002347554944000000240500009800000023426c6f6200000000000000020000014715a2010900000000fa013300160000010000000b0000000200000009000000050000000c0000000400000001000000010000000300000006000000010000000200000000003a010100000000000600ac008b010600dc008b010600980062010f00ab0100000a00cc00ba010a00d801ba010a004c00ba010a007300ba0106000d004c0106000d014c010600e6014c01000000001f00000000000100010001001000130000001900010001005020000000008108ed014b0001006220000000008108f70101000100752000000000810875014b00020087200000000081088001010002009c2000000000810814014f000300f0200000000081082101530003002e210000000086185c0135000400502100000000860053014f00050058210000000086002e012a00050000000100fa0000000100fa0000000100fa00000001006000000001003f0009005c01010011005c01060019005c010a0029005c01060031008400100041000100150041000a001a005100d1012400410000012a0041000a012f0031005c0135005100d1013b002e000b0060002e00130069002e001b0088004300230091002000020001000000fb015800000084015800000031015c00020001000300010002000300020003000500010004000500020005000700010006000700048000000000000000000000000000000000d801000004000000000000000000000042002800000000000000070000000000000000000000ba0100000000000000476574496e74333200536574496e7433320048656c6c6f576f726c6432003c4d6f64756c653e0053797374656d2e507269766174652e436f72654c69620068656c6c6f4d6573736167650049536d617274436f6e7472616374537461746500736d617274436f6e74726163745374617465004950657273697374656e745374617465006765745f50657273697374656e7453746174650044656275676761626c6541747472696275746500436f6d70696c6174696f6e52656c61786174696f6e73417474726962757465004465706c6f794174747269627574650052756e74696d65436f6d7061746962696c6974794174747269627574650076616c756500476574537472696e6700536574537472696e67006765745f4772656574696e67007365745f4772656574696e67004164644772656574696e6700536d617274436f6e74726163742e646c6c0053797374656d0053617948656c6c6f002e63746f720053797374656d2e446961676e6f7374696373006765745f426f756e6473007365745f426f756e64730053797374656d2e52756e74696d652e436f6d70696c6572536572766963657300446562756767696e674d6f64657300537472617469732e536d617274436f6e74726163747300436f6e63617400536d617274436f6e7472616374004f626a656374006765745f496e646578007365745f496e64657800000000000b49006e00640065007800000d42006f0075006e006400730000114700720065006500740069006e0067000019480065006c006c006f00200057006f0072006c0064002100000f4100640064006500640020002700011f27002000610073002000610020004700720065006500740069006e00670001002d92eb2c7ece894f9a8cea80ee083f06000420010108032000010520010111110420001221042001080e052002010e08030701080500020e1c1c0420010e0e052002010e0e05200101121d0600030e0e0e0e087cec85d7bea7798e032000080320000e042001010e032800080328000e0801000800000000001e01000100540216577261704e6f6e457863657074696f6e5468726f77730108010002000000000004010000000000000000000000000000000000100000000000000000000000000000007427000000000000000000008e27000000200000000000000000000000000000000000000000000080270000000000000000000000005f436f72446c6c4d61696e006d73636f7265652e646c6c0000000000ff25002000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000c000000a037000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000",
      "message": "Your contract was successfully deployed.",
      "success": true,
      "transactionId": "f229b16e10231025e327a61a6db9b2efa2788c4d047c1a099fcd180d3f3df116"
    }

Although the message says that the contract has been successfully deployed, it does not confirm whether the transaction containing the call to the smart contract constructor in now on the blockchain. You can check that the transaction has been added to the blockchain using the ``/api/SmartContracts/receipt`` API call. Copy the ``transactionId`` field from the response above and paste it into the ``txHash`` field of the receipt API call. If the transaction has been successfully added, this API call returns something like the following:

::

    {
      "transactionHash": "f229b16e10231025e327a61a6db9b2efa2788c4d047c1a099fcd180d3f3df116",
      "blockHash": "9125968d9be8d0f74ba85bc3c8f9383494514c462968f2a4dc6bee8251e97ea0",
      "postState": "953cee53421b56aac3eae94d7281f97736c4b24e98e4f5c1856f0258bde47ff8",
      "gasUsed": 13149,
      "from": "CTr6DQ3RwSaFBPgMXKvMxqekkrnm88ia4z",
      "to": null,
      "newContractAddress": "CWbdDECSwo4m5eDeUbjCXJgWyvtueu2yuM",
      "success": true,
      "returnValue": null,
      "bloom": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "error": null,
      "logs": []
    }

.. note:: If the transaction has been added to the blockchain, this also means that a miner has executed the smart contract constructor. The constructor is, in fact, executed by all nodes who receive the block containing this transaction during block validation. Executing the smart contract constructor effectively persists the ``Greeting`` property on all the nodes. 

The ``newContractAddres`` field is particularly important to note as you use this to identify a smart contract when you call a method on it.  

Calling the SayHello() method locally
===========================================

We are going to call the ``SayHello()`` method as a local call. This means that:

1. No gas will be expended making the call.
2. The persistant state for the ``Greeting`` property will be copied and worked on for the duration of the call.

The second point is academic in this situation because the value is only read and not written to. However, as we shall see, what this means is that persistant state is not updated by local calls made to smart contract methods.

Use the ``/api/SmartContracts/local-call`` API call to make a local method call on the smart contract. This involves filling out the ``LocalCallContractRequest`` object. Each member of the object is fully documented in the API. As before, for the gas limit, specify the maximum value. Even on a real sidechain, we would not be expending real gas when a local call is made.

You should see the following response:

::

    {
      "InternalTransfers": [],
      "GasConsumed": {
      "Value": 10038
    },
    "Revert": false,
    "ErrorMessage": null,
    "Return": "Hello World!",
    "Logs": []
    }

The ``Return`` value proves the local call was successful.

.. _creating-a-real-transaction-which-calls-sayhello:

Creating a real transaction which calls SayHello()
======================================================

The value returned when the ``SayHello()`` method is called from within a transaction is the same as when it is called locally. This is because the call does not change the persistant state for the ``Greeting`` property. However, when the call is part of a broadcast transaction and subsequently included in a mined block, other nodes are able to see the result of the transaction call.

Use the ``/api/SmartContracts/build-and-send-call`` API call to create a transaction containing a call to the smart contract. This involves filling out the "BuildCallContractTransactionRequest" object. Each member of the object is fully documented in the API. For the gas limit, specify the maximum value as we are not expending real gas.

Execute the API call, and you should see something like the following:

::

    {
      "fee": 12000000,
      "hex": "010000000116f13d3f0d18cd9f091a7c044d8c78a2efb2b96d1aa627e3251023106eb129f2000000006b483045022100eb0603606870c473834652dc92e2ca8b46e87b4437517f9b7dcfc160a9ba3af802200d99a6692363acaac0922b730f7fc1ff496da8e9697f6ec6077a29f8c2f113690121023a8dc138cfb94af04b1d93a4e377ce9f6d619f8ad9b49156887155204371a4baffffffff02005d7850020000001976a9147cdc4138be4e458e2cf2ad581dcbd263f0b1a5cc88ac000000000000000034c1010000006400000000000000a0860100000000009b08448b4c83bf44c82386320e2e3f03cab9849aca8853617948656c6c6f8000000000",
      "message": "Contract was successfully called with method SayHello.",
      "success": true,
      "transactionId": "2d6e07dfa0511aed2ee6c8c2af3149c2c5e01d9f6a6dceb95621c67a5efe9a4b"
    }

Although the message says that the contract has been successfully deployed, it does not confirm whether the transaction containing the call to ``SayHello()`` method in now on the blockchain. Check that the transaction has been added to the blockchain using the ``/api/SmartContracts/receipt`` API call. Copy the ``transactionId`` field from the response above and paste it into the ``txHash`` field of the receipt API call. If the transaction has been successfully added, this API call returns something like the following:

::

    {
      "transactionHash": "2d6e07dfa0511aed2ee6c8c2af3149c2c5e01d9f6a6dceb95621c67a5efe9a4b",
      "blockHash": "92e37bc1a2345789788eea9603aa463c071fefaf436eaebc1b15f8ff6fbd94d4",
      "postState": "5939ac0e3e3c28d6a31b040c1ce3fc4e7c6b9a039f907f317f511627745bea67",
      "gasUsed": 10357,
      "from": "CTr6DQ3RwSaFBPgMXKvMxqekkrnm88ia4z",
      "to": "CWbdDECSwo4m5eDeUbjCXJgWyvtueu2yuM",
      "newContractAddress": null,
      "success": true,
      "returnValue": "Hello World!",
      "bloom":         "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "error": null,
      "logs": []
    }





