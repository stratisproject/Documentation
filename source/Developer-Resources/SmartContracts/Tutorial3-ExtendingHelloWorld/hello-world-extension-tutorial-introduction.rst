*******************************************************************
Extending the "Hello World" example
*******************************************************************

The next tutorial in the series extends the "Hello World" program from the previous example. Rather than just hold a single greeting, the smart contract is upgraded to hold multiple greetings and cycle through them as greetings are requested. To accommodate this, the smart contract is extended with a new method allowing users of the smart contract to add additional greetings.

You can find the source code for the "Hello World 2" smart contract examples in the `Stratis.SmartContracts.Examples.HelloWord <https://github.com/stratisproject/StratisBitcoinFullNode/tree/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld>`_ project, which is included in the ``LSC-tutorial`` branch of the Stratis Full Node. For this tutorial, you will study, build, and deploy `HelloWorld2.cs <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.SmartContracts.Examples.HelloWorld/HelloWorld2.cs>`_. 

.. toctree::
   :maxdepth: 2
   :caption: Contents:   
   
   deploying-hello-world2-contract