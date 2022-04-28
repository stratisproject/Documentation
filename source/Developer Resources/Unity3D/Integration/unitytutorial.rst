###################
Unity3D Integration
###################

This tutorial will take you through the steps of setting up an environment and performing basic
interaction with the STRAX Mainnet Blockchain.

**************
Pre-Requisites
**************

-  Download and install `.NET Core SDK 3.1 <https://dotnet.microsoft.com/download/dotnet/3.1>`_

-  Download and install `Git <https://git-scm.com/downloads>`_

-  Download `Stratis Unity SDK Package <https://github.com/stratisproject/Unity3dIntegration/tree/main/Resources>`_

*The Stratis Unity SDK is currently going through the Unity Store approval process, in the meantime, the package can be obtained from our GitHub source above.*

*************************
Prepare Stratis Full Node
*************************

First, you must obtain a local copy of the Stratis Full Node; this can
be achieved by using the git clone command. 

For the purpose of this document, we will be using the desktop as the
root directory. 

**Execute the below command**: 

.. code-block:: bash

   git clone http://github.com/stratisproject/StratisFullNode C:/Users/Admin/Desktop/StratisFullNode

The above command will clone the source code to the below directory,

.. code-block:: bash

   C:\Users\Admin\Desktop\StratisFullNode\src\Stratis.StraxD

It's cloned now so let's go to the source and let's build it.

.. code-block:: bash

   dotnet build

Once the build has completed, we can run the project.

.. code-block:: bash

   dotnet run -txindex=1 -addressindex=1 -unityapi_enable=true -unityapi_apiuri=http://0.0.0.0

Once we execute the command, a local version of Stratis FullNode will
start running and syncing with the mainnet. While it's syncing we can open the port in the firewall, as we want to
allow inbound ports.

The default port for unity API is
44336, but you can specify what you want by altering the ``-unityapi_apiuri=http://0.0.0.0`` parameter, for example ``-unityapi_apiuri=http://0.0.0.0:12345`` would configure the UnityAPI to listen on ``TCP12345``.

Now let's check if it works, so first let's go to swagger on
http://localhost:44336.

**Note**: The node can take some time depending on the internet speed, and available resources
to get fully synced. The synchronization completion can be confirmed by the viewing the console and checking the below

.. code-block:: bash
   
   >> Consensus Manager
	Tip Age                 : 00.00:00:07 (maximum is 00.00:12:48)
	Synced with Network     : Yes

Once the node is fully synchronized; let's go and run unity and try to connect to our API.

*************
Running Unity
*************

Create a new project within Unity and import the Stratis Blockchain SDK Unity Package that we obtained earlier.
Once it's imported we can open and run the example scene. It is a simple UI that you can use to test the
solution, first, we will need to provide the correct endpoint and in my
case, ``http://localhost:44336`` is the IP address and port that was defined when launching the ``StratisFullNode``, so if you've set up
everything properly, click test.


You will see that the API test was successful. And you can now generate a new mnemonic. 
You can also just use your old mnemonic in case you already have a wallet created in unity. 
Click on ``Initialize`` and here is your address to which you can deposit
STRAX. Let's copy it and now let's go back to our swagger API server. I
has a default wallet that I have prepared here which has ``0.1 STRAX``.

So let's send some STRAX from this wallet. We will go to ``StratisFullNode API`` and build a transaction via the
``/api/wallet/build-transaction`` endpoint.

An example body can be seen below:

.. code-block:: json

   {
  "password": "Sup3rS3cur3!!",
  "walletName": "MyWallet",
  "accountName": "account 0",
  "recipients": [
    {
      "destinationAddress": "<UnityAddress>",
      "amount": "0.1"
    }
  ],
  "feeType": "low",
  "allowUnconfirmed": true,
  "shuffleOutputs": true
   }


Once executed, a hex will be returned. This hex is an encoded representation of the transaction request just made.
The ``/api/wallet/send-transaction`` endpoint can now be utilized to broadcast the transaction to the network.
You can also just use a Wallet GUI to deposit to your Unity Address. The GUI Wallet can be downloaded below:

https://github.com/stratisproject/StraxUI/releases

Now if we go back to unity and refresh our balance we can see that the balance has changed.

***********************
Performing Transactions
***********************

We can send two types of transactions, one is a normal transaction where
you supply the destination address and the amount you want to send, and
the second is an op return transaction which basically allows you to
encode any data and post it to the blockchain. So let's try both of
those. Let's say I deposited ``0.0505`` to an address.

Now we can see the transaction was created and we get the transaction
id, based on which we can explore about the transaction on
`Stratis Block Explorer <https://chainz.cryptoid.info/strax/>`_.
Let's open this address in the blockchain explorer and see if any transaction was
created, so it will take some time for the transaction to be mined
before it will appear. Typically it will be less than half a minute, so
let's wait.

Once the transaction is confirmed, it will appear on the explorer, you can select the transaction to see the
transaction detail. i.e. What inputs were selected and what the outputs were.
Now you can do the second type of transaction, which is encoding any
operator and data. So let's put any data in the ``SEND OP_RETURN transaction`` field and click send.

Then again open `Stratis Block Explorer <https://chainz.cryptoid.info/strax/>`_ and look for this address, once the
transaction is confirmed and we can see the transaction details, if we
open it that we have an output ``OP_RETURN`` and it will have your data encoded
there.

So that's pretty much it! Click next to view a further guide based on integrating Stratis Smart Contracts.