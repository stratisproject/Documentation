*******************************************************************
Smart Contract Tutorial 3 - Extending the "Hello World" example
*******************************************************************

The next tutorial in the series extends the "Hello World" program from the previous example. Rather than just hold a single greeting, the smart contract is upgraded to hold multiple greetings and cycle through them as greetings are requested. To accommodate this, the smart contract is extended with a new method allowing users of the smart contract to add additional greetings.

You can find the source code for the "Hello World 2" smart contract examples in the `Stratis.SmartContracts.Examples.HelloWord <https://github.com/stratisproject/StratisBitcoinFullNode/tree/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld>`_ project, which is included in the ``LSC-tutorial`` branch of the Stratis Full Node. For this tutorial, you will study, build, and deploy `HelloWorld2.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld/HelloWorld2.cs>`_. 

Building and deploying the smart contract
==========================================

To build and deploy the "Hello World 2" smart contract, refer to:

* :ref:`compiling-the-hello-world-smart-contract`
* :ref:`deploying-the-hello-world-smart-contract`

The procedure is exactly the same, except you supply the ``HelloWorld2.cs`` file to the sct tool instead.

An overview of the code
==============================

The upgrade to the smart contract essentially involves modifying the ``Greeting`` property to hold an array of strings. The first thing to be aware of is that smart contracts do not persists arrays, but if you want to store a group of a particular type of data, you can adapt key-value pairs to do this. The accessors for the ``Greeting`` property wrap up the logic but rely on two other integer properties to maintain the array: ``Index`` and ``Bounds``.

::

    private int Index 
    {
        get
        {
            return this.PersistentState.GetInt32("Index");
        }   
        set
        {
            PersistentState.SetInt32("Index", value);
        }
    }    

    private int Bounds 
    {
        get
        {
            return this.PersistentState.GetInt32("Bounds");
        }   
        set
        {
            PersistentState.SetInt32("Bounds", value);
        }
    }    
    
    private string Greeting 
    {
        get
        {
            Index++;
            if (Index >= Bounds)
            {
                Index = 0;
            }

            return this.PersistentState.GetString("Greeting" + Index);
        }   
        set
        {
            PersistentState.SetString("Greeting" + Bounds, value);
            Bounds++;
        }
    }

You can see that the indexes are built into the keys and as far as the smart contract is concerned, it is just persisting individual pieces of data.

Because the properties contain the "array maintenance logic", the ``AddGreeting()`` method just uses the ``Greeting`` property set accessor to add new greetings and, as before, the ``Greeting`` property get accessor supplies the ``SayHello()`` method with a greeting.

Using a dictionary approach
-----------------------------

Because smart contracts use the key-value pairs, you may want to approach storing grouped data from a dictionary approach and not iterate through grouped data from start to finish at all. Take a look at this code excerpt from a `C# version of an ERC-20 smart contract <https://github.com/stratisproject/StratisSmartContractsSamples/blob/master/src/Stratis.SmartContracts.Samples/Stratis.SmartContracts.Samples/StandardToken.cs>`_:

::

    private void SetApproval(Address owner, Address spender, ulong value)
    {
        PersistentState.SetUInt64($"Allowance:{owner}:{spender}", value);
    }

    /// <inheritdoc />
    public ulong Allowance(Address owner, Address spender)
    {
        return PersistentState.GetUInt64($"Allowance:{owner}:{spender}");
    }

``Allowance`` is effectively a 2D dictionary with two addresses being used to form the key. As the only requirement is to access the allowance for any two addresses, there is no need to keep a record of an index or bounds. In fact, the bounds of the 2D dictionary can grow as required. When storing the allowances in the above code, as far as the smart contract is concerned, it is just persisting individual pieces of data.

Calling a method on the contract for the first time
====================================================

To begin, we are going to call the ``SayHello()`` again. From examining the code, you will see that the call receipt will give a ``returnValue`` of "Hello World" no matter how many times the method is called. The ``Index`` property updates from -1 to 0 and, from then on, remains at 0. To remind yourself how to make a method call, refer to :ref:`creating-a-real-transaction-which-calls-sayhello`.

.. note:: If you want to check the ``Index`` value, you could try and create a method to retrieve it. In this case you must redeploy the smart contract. You don't have to rename the smart contract because, as you saw in the last tutorial, smart contracts are identified by their address. However, it is good from a code management point of view.

Adding multiple greetings to the smart contract
================================================

The new smart contract method, ``AddGreeting()``, takes a single string parameter which specifies the new greeting. To begin with, add the greeting in French: "Bonjour le monde!". Again, use the ``/api/SmartContracts/build-and-send-call`` API call to make a method call on the smart contract. When filling out the ``BuildCallContractTransactionRequest`` object, the important thing to notice is how the single string argument to the smart contract is specified as one of the ``parameters``. For example:

::

    {
      "walletName": "LSC_node1_wallet",
      "accountName": "account 0",
      "contractAddress": "CWbdDECSwo4m5eDeUbjCXJgWyvtueu2yuM",
      "methodName": "AddGreeting",
      "amount": "0",
      "feeAmount": "0.02",
      "password": "777777",
      "gasPrice": 100,
      "gasLimit": 100000,
      "sender": "CTr6DQ3RwSaFBPgMXKvMxqekkrnm88ia4z",
      "parameters": [
    "4#Bonjour le monde!"
    ]
    }

:ref:`parameter-serialization` explains how to specify all types of parameters. When you have made the call, check the receipt using the ``/api/SmartContracts/receipt`` API call.

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
      "returnValue": "Added 'Bonjour le monde!' as a greeting.",
      "bloom":         "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "error": null,
      "logs": []
    }

The ``returnValue`` should confirm the greeting was added successfully.

After you have added a greeting in French, you can add a "Hello World" greeting in some other languages. Here are some suggestions:

* Hallo Welt! - German
* Привет, мир! - Russian
* Witaj świecie! - Polish 
* Hej Verden! - Danish

Cycling through the greetings
------------------------------

Use ``/api/SmartContracts/build-and-send-call`` to make repeat calls to ``SayHello()``. The first call you make should have a ``returnValue`` of "Bonjour le monde!". If you have added all four languages shown previously, they will then be returned with each subsequent call. Assuming "Hej Verden!" was the last greeting added, then after it has been returned, the next call returns "Hello World!" and the cycle begins again.

What happens if SayHello() is called by a different node?
-----------------------------------------------------------

This is an interesting question and answering it can help clarify how smart contracts work. You can also see this in action by running both node1 and node 2 and alternating the calls to ``SayHello()`` between the nodes. Assuming the smart contract holds all six greetings and the ``Index`` property begins at 0, the following results are returned:

1. Node1: Hello World! 
2. Node2: Bonjour le monde!
3. Node1: Hallo Welt!
4. Node2: Привет, мир!
5. Node1: Witaj świecie!
6. Node2: Hej Verden!
7. Node1: Hello World!
8. and so on...

When ``SayHello()`` accesses the ``Greeting`` property, the ``Index`` property is incremented in the ``Greeting`` get accessor. As you might expect, using the ``++`` operator invokes the ``Index`` write accessor:

::

   set
   {
       PersistentState.SetInt32("Index", value);
   }

Every node receives this state update once the related transaction has been mined, and the same is true of any state update made by ``PersistentState.Set*()``. Therefore, in terms of cycling through the greetings, the persisting of the index across the network allows each node to carry on where the last one left off.

What happens if you call Hello World 2 methods locally?
---------------------------------------------------------

Related to the previous subsection is the question of what happens if you call either ``HelloWorld2.SayHello()`` and ``HelloWorld2.AddGreeting()`` using the ``/api/SmartContracts/local-call`` API call. Based on the knowledge that local smart contract calls make a copy of the persisted state but never persist any changes they make, the following predictions can be made:

1. ``SayHello()`` returns the next greeting. This continues until a node creates a transaction containing a ``SayHello()`` call, which is then successfully mined.
2. ``AddGreeting()`` returns "Added '*the_new_greeting*!' as a greeting.". However, the new greeting will never be displayed by any ``SayHello()`` call.

If you like, you can check the results of calling Hello World 2 methods locally.





