**********************************************
An overview of the code
**********************************************

The upgrade to the smart contract essentially involves modifying the ``Greeting`` property to hold an array of strings. The first thing to be aware of is that smart contracts do not persist arrays, but if you want to store a group of a particular type of data, you can adapt key-value pairs to do this. The accessors for the ``Greeting`` property wrap up the logic but rely on two other integer properties to maintain the array: ``Index`` and ``Bounds``.

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

***************************
Using a dictionary approach
***************************

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

************************************************
Building and deploying the HelloWorld2 contract
************************************************

To build and deploy the "Hello World 2" smart contract, refer to:

* :ref:`compiling-the-hello-world-smart-contract-dev`
* :ref:`deploying-the-hello-world-smart-contract-dev`

The procedure is exactly the same, except you supply the ``HelloWorld2.cs`` file to the sct tool instead.


***************************************************
Calling a method on the contract for the first time
***************************************************

To begin, we are going to call the ``SayHello()`` again. From examining the code, you will see that the call receipt will give a ``returnValue`` of "Hello World" no matter how many times the method is called. The ``Index`` property updates from -1 to 0 and, from then on, remains at 0. To remind yourself how to make a method call, refer to :ref:`calling-the-sayhello-method`

.. note:: If you want to check the ``Index`` value, you could try and create a method to retrieve it. In this case you must redeploy the smart contract. You don't have to rename the smart contract because, as you saw in the last tutorial, smart contracts are identified by their address. However, it is good from a code management point of view.

***********************************************
Adding multiple greetings to the smart contract
***********************************************

The new smart contract method, ``AddGreeting()``, takes a single string parameter which specifies the new greeting. To begin with, add the greeting in Polish: **Witaj świecie!**. 

::

	curl -X POST "http://localhost:38223/api/contract/PWyA6fYiGFbJxaLqpPq3aSyGkHw9QNv9kY/method/AddGreeting" -H "accept: application/json" -H "GasPrice: 100" -H "GasLimit: 100000" -H "Amount: 0" -H "FeeAmount: 0.01" -H "WalletName: cirrusdev" -H "WalletPassword: stratis" -H "Sender: P9zz49VdoPrirKhU2DBytwVTdCupcR4wYh" -H "Content-Type: application/json" -d "{ \"helloMessage\": \"Witaj świecie!\"}"
	
.. note:: Ensure you are specifying a Sender address that has a balance to fund the transaction.

After making the call to the AddGreeting method, we will get a response similiar to what we saw before.

::

	{
		"fee": 11000000,
		"hex": "0100000002eecc4fdc3caa2cccdb3af3b3593a41bcbc2cfa363c1e5860ce03af643d168b59010000006b483045022100dbb471cf296ac203d36f0e70e7136d396e4bc0a4475e2e1e919e174fc0ed523a022072cb725ac9ce873ba7d1edd3af87747f68b9fe2a60195ce964d1691a486aae84012102d8d7e4e8c427038596e69f4ce944986eeeb1fc3eb7327fe7b39d71eb6b72f0a2ffffffffa94d159db096d6919a7dfc2c3fc5af258d6952344334c8eee94b56a95731101b000000006a4730440220377fb94a7ec06257bc3e9e18502b8735cb1f8d0499d50174df77462445d0de150220725cf93b6e490cc08d64acd3ad241ac7aa8e9ade5a3aa3579dba514199d17054012102d8d7e4e8c427038596e69f4ce944986eeeb1fc3eb7327fe7b39d71eb6b72f0a2ffffffff021c1b5500000000001976a914bf64d5ee5f797568ac5624053fda4a9ee52a5e3f88ac000000000000000049c1010000006400000000000000a0860100000000001b6ed3b8bc4659e2d42e5e5cf037e3f212651c9fdf8b4164644772656574696e6792d19004576974616a20c59b7769656369652100000000",
		"message": "Your CALL method AddGreeting transaction was successfully built.",
		"success": true,
		"transactionId": "997f923d0144e0d8249cea8e9c71efa17df63e33c18b189f192bb8a899e64999"
	}

Let's get the Transaction ID and pass it to the /SmartContracts/receipt endpoint.

::

	curl -X GET "http://localhost:38223/api/SmartContracts/receipt?txHash=997f923d0144e0d8249cea8e9c71efa17df63e33c18b189f192bb8a899e64999" -H "accept: application/json"
	
We can see from the response that ``'Witaj świecie!'`` was added as a greeting!

::

	{
		"transactionHash": "997f923d0144e0d8249cea8e9c71efa17df63e33c18b189f192bb8a899e64999",
		"blockHash": "e9fcb1fde9b4fbf1bc24b3a640468a71338a40feef30c8075a660bc7097d186d",
		"postState": "c61e8e6a9d4d774830c4465be6a9cb1466a7eceac065ef6b72503d09846d1308",
		"gasUsed": 10792,
		"from": "P9zz49VdoPrirKhU2DBytwVTdCupcR4wYh",
		"to": "PWyA6fYiGFbJxaLqpPq3aSyGkHw9QNv9kY",
		"newContractAddress": null,
		"success": true,
		"returnValue": "Added 'Witaj świecie!' as a greeting.",
		"bloom": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		"error": null,
		"logs": []
	}

After you have added a greeting in Polish, you can add a "Hello World" greeting in some other languages. Here are some suggestions:

* Hallo Welt! - German
* Привет, мир! - Russian
* 你好，世界！ - Chinese 
* Hej Verden! - Danish

*****************************
Cycling through the greetings
*****************************

Call the ``SayHello`` method on the same contract to see the difference in responses.

::

	curl -X POST "http://localhost:38223/api/contract/PWyA6fYiGFbJxaLqpPq3aSyGkHw9QNv9kY/method/SayHello" -H "accept: application/json" -H "GasPrice: 100" -H "GasLimit: 100000" -H "Amount: 0" -H "FeeAmount: 0.01" -H "WalletName: cirrusdev" -H "WalletPassword: password" -H "Sender: P9zz49VdoPrirKhU2DBytwVTdCupcR4wYh" -H "Content-Type: application/json" -d "{}"

The first call will return the below, as we saw in the original HelloWorld contract.

::

	{
		"transactionHash": "0408673f7cd9584556033ff95c9ded74284d2fd45930b308e9140ae4b39ff1c4",
		"blockHash": "af7fab69533051ceae88cf66c75163515e6191d9a3eee4fd6c7f4aa8dddd2849",
		"postState": "1c0b2cc765d6f0e17a1d0422fed0ba3972beb78aacf6ae659089ed9e9a4a025a",
		"gasUsed": 10357,
		"from": "P9zz49VdoPrirKhU2DBytwVTdCupcR4wYh",
		"to": "PWyA6fYiGFbJxaLqpPq3aSyGkHw9QNv9kY",
		"newContractAddress": null,
		"success": true,
		"returnValue": "Hello World!",
		"bloom": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		"error": null,
		"logs": []
	}

However, a subsequent call will reutrn something different.

::

	{
		"transactionHash": "b6211ae4f0345da332aceb9ed84e42d5729a855fbbd558c24d3d6ca0c403fe70",
		"blockHash": "8c4c6078044be2a75201e73d419240c9fabcc80da3ad8f0c4e3487347efdd355",
		"postState": "1be6ba0cdc123f6ea9fb67cab76641e1303f40eb774e1c69265f4910b116404d",
		"gasUsed": 10360,
		"from": "P9zz49VdoPrirKhU2DBytwVTdCupcR4wYh",
		"to": "PWyA6fYiGFbJxaLqpPq3aSyGkHw9QNv9kY",
		"newContractAddress": null,
		"success": true,
		"returnValue": "Witaj świecie!",
		"bloom": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		"error": null,
		"logs": []
	}

If you have added all four languages shown previously, they will then be returned with each subsequent call. Assuming "Hej Verden!" was the last greeting added, then after it has been returned, the next call returns "Hello World!" and the cycle begins again. 

*********************************************************
What happens if SayHello() is called by a different node?
*********************************************************

This is an interesting question and answering it can help clarify how smart contracts work. You can also see this in action by running two nodes and alternating the calls to ``SayHello()`` between the nodes. Assuming the smart contract holds all six greetings and the ``Index`` property begins at 0, the following results are returned:

1. Node1: Hello World! 
2. Node2: Witaj świecie!
3. Node1: Hallo Welt!
4. Node2: Привет, мир!
5. Node1: 你好，世界！
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