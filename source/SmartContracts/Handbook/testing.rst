###############################
Testing
###############################

Stratis Smart Contracts are unit-testable in the same way as any other C# class. Unit tests can be written with the testing framework of your choice. Tests can be developed and debugged with Visual Studio's step-through debugger.

.. note::
  While contracts are fully testable, the available testing utilities are still primitive. Future versions of smart contracts will enable testing on top of a local test blockchain with resource tracking code injected.

The Basics
----------

The smart contract `token sample contract <https://github.com/stratisproject/StratisSmartContractsSamples/tree/master/src/Stratis.SmartContracts.Samples/Stratis.SmartContracts.Samples>`_ also contains tests for this contract. The tests described here verify that your smart contract logic executes as intended before you deploy it to a live network. The tests use the ``Microsoft.VisualStudio.TestTools.UnitTesting`` library, which may be familiar to C# developers:

- ``[TestClass]`` defines a class in which tests are defined.
- ``[TestInitialize]`` is used to mark a method to be run before tests execute, most commonly to set up some testing context.
- ``[TestMethod]`` marks the actual tests to be run.
- The static class ``Assert`` provides access to a range of methods to validate the results of whatever execution you perform inside your tests.

To run the tests together, right click on ``[TestClass]`` and select `Run Tests` in Visual Studio. To run tests individually, right click on the individual method and select `Run Tests`. Once clicked, the solution will take a couple of seconds to build and then the Test Explorer will open. You should see your tests listed next to a green tick, which indicates the tests have passed.

You can also debug contract execution in Visual Studio. If breakpoints are set in the Auction smart contract methods and you then right click and select `Debug Tests` on the test methods, you will reach any breakpoints set in the methods being tested. You can then inspect the current state of the contract and step through execution as with any other C# application.

State Injection
---------------

A Stratis smart contract's constructor has a single mandatory parameter: ``public ExampleContract(ISmartContractState state)``. Contextual blockchain state is injected into this parameter at contract execution time. Because state is abstracted behind the ``ISmartContractState`` interface, it allows any possible state of the blockchain to be mocked and injected while unit testing is being carried out.

The ``ISmartContractState`` interface contains these members:

* IBlock Block - Contains information about the block in which the smart contract transaction has been included.
* IMessage Message - Contains information about the contract invocation environment.
* IPersistentState PersistentState - Represents the persistent storage available to a contract.
* IGasMeter GasMeter - Represents an object used to measure the amount of gas consumed during contract execution.
* IInternalTransactionExecutor InternalTransactionExecutor - Represents an executor used to process transactions generated from within the contract.
* IInternalHashHelper InternalHashHelper - Provides hashing functions to the contract.
* Func<ulong> GetBalance - A function which provides the current balance of the contract.

A unit test can define its own representations of these interfaces and then inject them into the contract under test.

An Example
----------

Stepping through the `Constructor_Assigns_TotalSupply_To_Owner()` method from tests should help you understand the basic approach to unit testing your contracts with a mock contract state.

::

  var standardToken = new StandardToken(this.mockContractState.Object, 100_000);

The first step to testing your contracts is initialising them. A ``mockContractState`` object is injected into the ``StandardToken`` object. This ``TestSmartContractState`` object is a mock implementation of the same ``ISmartContractState`` interface that is injected when smart contracts are initialised on-chain. The only difference is that in this case all of the properties can be set by you. This is really useful if you want to explicitly target scenarios in your contract's execution.

::

  this.mockPersistentState.Verify(s => s.SetUInt64($"Balance:{this.owner}", totalSupply));

This checks that a call was made to the PersistentState class to set the initial balance of the contract's owner.