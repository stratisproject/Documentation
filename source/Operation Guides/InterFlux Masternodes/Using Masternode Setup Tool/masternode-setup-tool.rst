************
Introduction
************

This guide details the process required for joining the Cirrus
Sidechain as a Block Producing Node, known as an InterFlux Masternode using the Masternode Setup Tool. The request to join the Cirrus Sidechain as a block
producer, requires you to setup the Masternode Setup tool, therefore, a request to join the Cirrus Sidechain will be
made once the Masternode is fully configured.

Pre-Requisites
==============

To join as a InterFlux Masternode, there are a number of criteria
that must be met.

Wallet Requirements
-------------------

You must know the mnemonic and passphrase (if applicable) for a STRAX
Wallet that contains the required collateral and fee.

-  **Collateral Amount:** 100,000 STRAX

-  **Fee Amount:** 501 STRAX


Sidechain Masternode Hardware Requirements
------------------------------------------

The below hardware requirements are a minimum.

-  2x vCPU / Dual Core

-  8GB RAM

-  50GB SSD / HDD

Sidechain Masternode Software Requirements
------------------------------------------

There are only three pre-requisites software installations that need to
take place before operating a InterFlux Masternode.

.NET Core SDK
~~~~~~~~~~~~~

.NET Core is the platform that the InterFlux Masternode has been
developed upon. Therefore, you will need to install the .NET Core SDK.

Please install the latest version of .NET Core SDK 3.1

https://dotnet.microsoft.com/download/dotnet-core/3.1

Git for Windows
~~~~~~~~~~~~~~~

Navigate to the URL below to download the Git for Windows Installer.
This should be the topmost file with .exe extension.

https://github.com/git-for-windows/git/releases

Masternode Setup Tool
~~~~~~~~~~~~~~~~~~~~~

The Masternode Setup Tool is a specialized utility designed to streamline
the experience of joining the federation by providing a intuitive interface.

#. For simplicity, it is recommended you download and install the MSI
   relevant for your operating system.

Network Requirements
~~~~~~~~~~~~~~~~~~~~

There are three firewall rules required to allow connectivity between
your InterFlux Masternode and other nodes on the network.

============= ============= ============ ========
**Rule Name** **Direction** **Protocol** **Port**
============= ============= ============ ========
StraxMain     Inbound       TCP          17105
CirrusMain    Inbound       TCP          16179
ICMP          Inbound       ICMPv4       N/A
============= ============= ============ ========

Wallet Configuration
====================

It is recommended that you create a new wallet when completing this
process, so your STRAX Tokens can be separated from any other STRAX
Tokens you may hold.

1. Download the STRAX Wallet and Create a New Wallet

https://github.com/stratisproject/StraxUI/releases

2. Please ensure you take note of your Mnemonic and Passphrase. These
   **will be required** later in the process

2. Download Cirrus Core and Create a New Wallet

https://github.com/stratisproject/CirrusCore/releases

3. Please ensure you take note of your Mnemonic and Passphrase. These
   **will be required** later in the process

3. Login to your STRAX Wallet

.. image:: media/image2.jpeg
   :width: 4.40157in
   :height: 4.02362in

4. Obtain a Receive Address and send 100,501 STRAX to this address

.. image:: media/image3.png
   :width: 4.40157in
   :height: 4.02362in

4. You will have to wait for 100% Wallet Synchronization before seeing
   your balance

5. Login to your Cirrus Core Wallet

.. image:: media/image4.png
   :width: 4.57874in
   :height: 3.86614in

6. Select Address 0

.. image:: media/image5.png
   :width: 4.58268in
   :height: 3.86614in

7. Obtain a Receive Address

.. image:: media/image6.png
   :width: 4.58268in
   :height: 3.86614in

8. Perform a Cross-Chain Transfer of **500.9 STRAX** to your Cirrus
   Address

.. image:: media/image7.png
   :width: 4.40157in
   :height: 4.02362in

9. The Cirrus Core Wallet will receive 500.8~ CRS after 80 Blocks have
   passed on the STRAX Blockchain (~1Hr)

.. image:: media/image8.png
   :width: 4.58268in
   :height: 3.86614in

10. Now, you must consolidate the STRAX Balance to ensure it all resides
    in a single address. To do this, obtain another Receive Address and
    send **100,000 STRAX**

.. image:: media/image9.png
   :width: 4.1811in
   :height: 3.82283in

5. You are sending back to an address that you own. Not an external
   address.

11. Your resulting balance and transaction history should look very
    similar to the below

.. image:: media/image10.png
   :width: 4.1811in
   :height: 3.82283in

12. Wallet preparation is now complete; you should now be in position of
    the following.

1. **STRAX Wallet that contains 100,000+ STRAX Tokens.**

2. **The Mnemonic and Passphrase for the aforementioned wallet.**

3. **Cirrus Wallet that contains 500+ CRS Tokens.**

4. **The Mnemonic and Passphrase for the aforementioned wallet.**

13. You must now wait for **80 Confirmations** before the **CRS Tokens**
    are received through the Cross-Chain Transaction, in addition, the
    transaction that was made in **Step 10** also requires 500
    Confirmations.

InterFlux Masternode Registration 
=======================================

Whilst we wait for confirmations, the host that will run your STRAX
Sidechain Masternode configured and prepared to launch the Masternode
Setup Tool.

Please ensure you meet the requirements set out at the `beginning of
this guide <#sidechain-masternode-hardware-requirements>`__, before
you continue.

Obtain the Masternode Setup Tool installer
---------------------------------------------------

A tool has been developed to ease the setup process and ensure
consistency, the tool can be obtained from the below URL.

`Click here to download the Masternode Setup Tool <https://www.stratisplatform.com/>`_

Install the Masternode Setup Tool.

Executing the Desktop App
---------------------------------

Launch the Masternode Setup Tool from the Start Menu or the 
desktop. The desktop application should resemble the 
following interface.

.. image:: media/image11.png
   :width: 6.26806in
   :height: 3.27778in

You now have two options: either run the STRAX Blockchain 
and the Cirrus Sidechain via the Masternode dashboard, or 
initiate Masternode registration within the Federation.


Run Masternode
==============
If you are already a member of the Federation, simply 
launch the app and click on the "Run Masternode" button. 
The app will initialize and synchronize both the 
STRAX Blockchain and the Cirrus Sidechain. Completion 
time varies based on your system specifications. Upon 
completion, the following screen will appear.

.. image:: media/image12.png
   :width: 6.26806in
   :height: 3.27778in

Setup Masternode
================

To join the Federation, launch the app and select the 
"Setup Masternode" button. Follow the setup steps as prompted. 
The app will initialize and synchronize both the STRAX 
Blockchain and the Cirrus Sidechain. It will also guide you 
through the setup process, requesting necessary information. 
Completion time varies depending on your system specifications. 
Upon completion, the following screen will appear.

1. Agree to the End-User License Agreement.
   
.. image:: media/image13.png
   :width: 6.26806in
   :height: 3.27778in

2. Create new or use existing Federation key.

.. image:: media/image14.png
   :width: 6.26806in
   :height: 3.27778in

3. Choose an option to create, restore, or use an existing wallet.

.. image:: media/image15.png
   :width: 6.26806in
   :height: 3.27778in

4. In this example, we will use an existing mining wallet 
   from the `Wallet Configuration <#wallet-configuration>`__ 
   section earlier in this guide. You will be prompted 
   to select the wallet to where you have transferred your collateral.

.. image:: media/image16.png
   :width: 6.26806in
   :height: 3.27778in

5. Enter the password for your STRAX (collateral) wallet twice for confirmation.

.. image:: media/image17.png
   :width: 6.26806in
   :height: 3.27778in

6. You will be prompted to select the mining wallet to where you have 
   transferred your mining fee.

.. image:: media/image18.png
   :width: 6.26806in
   :height: 3.27778in

7. Enter the password for your Cirrus (mining) wallet twice for confirmation.

.. image:: media/image19.png
   :width: 6.26806in
   :height: 3.27778in

8. You will be prompted to select the collateral address from the collateral 
   wallet selected on previous steps.

.. image:: media/image20.png
   :width: 6.26806in
   :height: 3.27778in

9. Upon successful verification of collateral height and mining fee, 
   the following screen will appear, and the Masternode Dashboard will launch.

.. image:: media/image21.png
   :width: 6.26806in
   :height: 3.27778in

Congratulations, you have successfully completed the registration and are now 
a member of the Federation. Your node will begin to earn rewards.