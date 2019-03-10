*******************************************************************
Smart Contract Tutorial 3 - Extending the "Hello World" example
*******************************************************************

The next tutorial in the series extends the "Hello World" program from the previous example. Rather than just hold a single greeting, the program is upgraded to hold multiple greetings and cycle through them as greetings are requested. To accomodate this, the smart contract is extended with a new method allowing users of the smart contract to add additional greetings.

You can find the source code for the "Hello World 2" smart contract examples in the `Stratis.SmartContracts.Examples.HelloWord <https://github.com/stratisproject/StratisBitcoinFullNode/tree/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld>`_ project, which is included in the ``LSC-tutorial`` branch of the Stratis Full Node. For this tutorial, you will study, build, and deploy `HelloWorld2.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld/HelloWorld2.cs>`_. 

Building and deploying the smart contract
==========================================

To build and deploy the "Hello World 2" smart contract, refer to:

* :ref:`compiling-the-hello-world-smart-contract`
* :ref:`deploying-the-hello-world-smart-contract`

The procedure is exactly the same except, you supply the ``HelloWorld2.cs`` file to the sct tool.

A brief overview of the code
==============================

dictionary.

Calling a method on the contract for the first time
====================================================

To begin, we are going SayHello(). Fromm examining the code, you can see that the call receipt will give a ``returnValue`` of "Hello World" no matter how many times the method is called. To remind yourself how to make a method call, refer to :ref:`creating-a-real-transaction-which-calls-sayhello`.


Adding multiple greetings to the smart contract
================================================

In this example, the program is capable of displaying several greetings, which say exactly the same thing but in a different language. The new smart contract method, ``AddGreeting()``, takes a single string parameter which specifies the new greeting. To begin with let's add the greeting in French: "Bonjour le monde!".   
Again, you will use the ``/api/SmartContracts/local-call`` API call to make a method call on the smart contract. When filling out the ``BuildCallContractTransactionRequest`` object, the important thing to notice is how the single string argument to the smart contract is specified in the .

Cycling through the greetings
==============================


What happens if you call Hello World 2 methods locally?
=========================================================







