*******************************************************************
Smart Contract Tutorial 3 - Extending the "Hello World" example
*******************************************************************

The next tutorial in the series extends the "Hello World" program from the previous example. Rather than just hold a single greeting, the program is upgraded to hold multiple greetings and cycle through them as greetings are requested. To accomodate this, the smart contract is extended with a new method allowing users of the smart contract to add additional greetings.

Adding mutliple greetings to the smart contract
================================================

In this example, the greetings are going to say exactly the same thing but in a different language. The new smart contract method, ``AddGreeting()``, takes a single string parameter which specifces the new greeting. To begin with let's add the greeting in French: "Bonjour le monde!".   
Again, you will use the ``/api/SmartContracts/local-call`` API call to make a method call on the smart contract. When filling out the ``BuildCallContractTransactionRequest`` object, the important thing to notice is how the single string argument to the smart contract is specified in the .