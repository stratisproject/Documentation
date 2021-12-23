
Tutorial #1 - Basic plugin usage
================================

In this tutorial we'll show you how to use the basic functionality of the Stratis Unreal plugin: create a wallet, check your balance and unspent transaction outputs (UTXOs), and send coins to another address.

**Of we go!**

Prerequisite
------------

You need to set up your project and Stratis Unreal Plugin within it. If you looking for a tutorial about basic project setup, please check our :doc:`Tutorial #0 <../Tutorial_0_Plugin_set_up/Tutorial_0>`.

Setting up StratisUnrealManager and creating a wallet
-----------------------------------------------------

First of all, we need to set up ``StratisUnrealManager`` to be able to use all of the API methods provided by the plugin.

Let's click on the **Blueprints** menu in the toolbar and click **Open Level Blueprint**.


.. image:: images/0-blueprint-menu.png
   :target: images/0-blueprint-menu.png
   :alt: Menu

|

Now we see blueprint editor, let's create a variable ``stratisManager`` with the type ``Stratis Unreal Manager``.

Also, let's create a function called ``InitializeStratisUnrealManager``\ , where we will define the initialization logic for our manager.


.. image:: images/1-blueprint_components.png
   :target: images/1-blueprint_components.png
   :alt: Components

|

Define ``InitializeStratisUnrealManager`` like below:


.. image:: images/2-initialize-manager.png
   :target: images/2-initialize-manager.png
   :alt: Object construction

|

Now we're going to set up base URL, network, and wallet mnemonic.

Let's walk through the parameters:


#. 
   ``Mnemonic``. Mnemonic is a sequence of words used to define the private key of your wallet. You can create mnemonic `using just a pen, a paper, and a dice <https://armantheparman.com/dicev1/>`_\ , or using different hardware & software mnemonic generators.

#. 
   ``Base Url``. To use Stratis Unreal Plugin, you need a full node to be running locally or remotely. Find your node's address (IP or domain) if you're running a remote node, or use ``http://localhost:44336`` if you're running your node locally.

#. 
   ``Network``. The network you want to operate on. Use ``Cirrus`` and ``CirrusTest`` for production and testing respectively. 

The last thing we need to do is call our new function ``Initialize Stratis Manager`` on the ``BeginPlay`` event:


.. image:: images/3-initialization-event.png
   :target: images/3-initialization-event.png
   :alt: Initialization event

|

Getting a wallet balance
------------------------

Now let's learn how we can get a balance of our wallet.

First, let's make a function for printing balance response to screen. Implement a blueprint like below:


.. image:: images/4-print-balance-scheme.png
   :target: images/4-print-balance-scheme.png
   :alt: Print balance


..

   Note: ``Value`` has a type of ``FUInt64``.


Now, let's make a very similar function for the ``Error`` type:


.. image:: images/5-print-error-scheme.png
   :target: images/5-print-error-scheme.png
   :alt: Print error

|

Well, now we can call the ``GetBalance`` function and await the result. Add ``GetBalance`` to the event graph (right after manager initialization or after delay like in the example) and set its ``Delegate`` and ``Error Delegate`` fields to custom events via **Get Custom Event**. 


.. image:: images/6-bind-delegate.png
   :target: images/6-bind-delegate.png
   :alt: Bind delegate

|

Bind newly-created events to the functions we defined: ``Print Balance`` and ``Print Error``.

Desired event graph is shown below (\ ``Delay`` node is not necessary):


.. image:: images/7-get-balance-scheme.png
   :target: images/7-get-balance-scheme.png
   :alt: Get balance final scheme

|

Now, just press the **Play** key, and the balance will be printed on your screen & debug console.

Getting unspent transaction outputs
-----------------------------------

Okay, now we will try to find unspent transaction outputs for our wallet.

At first, let's create a method ``Print UTXOs`` and add the input parameter ``UTXOs`` with type ``Array`` of ``UTXO``. Now we're going to iterate over UTXO's array using **For Each Loop** node:


.. image:: images/8-iterate-utxos.png
   :target: images/8-iterate-utxos.png
   :alt: Iterate over UTXOs

|

Now let's just print every UTXO using **Break...** and **Format Text** nodes:


.. image:: images/9-print-utxos-function-scheme.png
   :target: images/9-print-utxos-function-scheme.png
   :alt: Print UTXOs function

|

We are almost done. Now we just need to call the **Get Coins** node as we did for ``Get Balance`` node, and use functions (\ ``Print UTXOs`` and ``Print Error``\ ) we made previously. The final scheme is shown below:


.. image:: images/10-get-utxos-scheme.png
   :target: images/10-get-utxos-scheme.png
   :alt: Print UTXOs scheme

|

Sending coins & waiting for a receipt
-------------------------------------

Now let's try to implement a more complex logic: send some coins *and* await for transaction's receipt.

At first, add the ``Send Coins Transaction`` node and set its inputs:


* ``Destination address``\ : in this example, we're using ``tD5aDZSu4Go4A23R7VsjuJTL51YMyeoLyS`` for **Cirrus Test network**
* ``Money``\ : the number of satoshis we want to send. Let's send 10.000 satoshis (= 0.0001 STRAX).


.. image:: images/11-send-coins-scheme.png
   :target: images/11-send-coins-scheme.png
   :alt: Send Coins

|

And now we need to join the ``Transaction ID`` output of the ``TransactionSent`` event to the ``Transaction ID`` input of the ``Wait Till Receipt Available`` node.

At last, add some printing logic to see when receipt is available, and we're done!


.. image:: images/12-await-receipt-scheme.png
   :target: images/12-await-receipt-scheme.png
   :alt: Await receipt


(See this scheme on `blueprintue.com <https://blueprintue.com/blueprint/zxawrzdx/>`_\ )

What's next?
------------

In this tutorial, we've learned how to use some core plugin functions: get balance, send coins, and wait for a receipt. In the next tutorial, we'll cover more advanced functionality of the plugin - interacting with smart contracts.

If you found a problem, you can `open an issue <https://github.com/stratisproject/UnrealEnginePlugin/issues>`_ on the project's Github page.
If you still have questions, feel free to ask them in `our Discord channel <https://discord.gg/9tDyfZs>`_.

Stay tuned!
