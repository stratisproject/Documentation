###############################
Testing Locally with TestChain
###############################

When developing smart contracts locally you will likely want to test execution on-chain via transactions, emulating how a contract will behave in practice.

For this purpose we have built an easy to use tool, ``TestChain``, which spawns a local development blockchain with near-identical parameters to the production Stratis smart contract blockchain, though you won't have to wait for the lengthy block times.

The fastest way to get started is to jump into TestChainExample.cs in the Stratis.SmartContracts.TestChain.Tests namespace in the Stratis.SmartContracts.TestChain repository. This document will walk you through how this test works so you can get started on your own. You can run the test in Visual Studio by right clicking on ``[Fact]`` and selecting "Run Test(s)".

The Code
--------

The first thing that we do inside the ``TestChain_Auction`` method is to compile the contract we're looking to test with the TestChain. This compiles the contract using Roslyn and if successful will return the contract's bytecode in ``compilationResult.Compilation``.

::

  // Compile the contract we want to deploy
  ContractCompilationResult compilationResult = ContractCompiler.CompileFile("SmartContracts/Auction.cs");
  Assert.True(compilationResult.Success);

.. important::
  When compiling your own smart contract file in a TestChain test, ensure that it is set to be copied to the output directory. You can do this in Visual Studio by right-clicking the file and selecting "Properties", then setting "Copy to Output Directory" to "Copy if newer".  

The local blockchain can be started by calling ``Initialize`` on a new instance of ``TestChain``. This will set up a new chain with very similar properties to the live Stratis smart contract chain. It also sets up 5 addresses with 100,000 test coins each. The following line inside the scope of the TestChain demonstrates how you can access these funded addresses:

::

  // Get an address we can use for deploying
  Base58Address deployerAddress = chain.PreloadedAddresses[0];
