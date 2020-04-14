***********************
Acquiring the CRS Token
***********************

Once you have installed Cirrus Core, you will need to run it either on testnet or mainnet. As this document refers to the StratisTest (TestNet) network, you will need to run the
wallet in testnet.

| **On Windows**
| From the command line run the following command:

::

    start "" "C:\\Program Files\Cirrus Core\Cirrus Core.exe" -testnet

| **On Mac**
| Open ScriptEditor to create a new applescript document and insert the following script:

::

    do shell script "open /Applications/Cirrus\\ Core.app --args -testnet"

Save the script in the Applications folder with the name of CirrusCoreTest.app and make sure to save it as an application type.

Once you have Cirrus Core running on testnet, you will need to follow the prompted steps to create a wallet, once this wallet has been created, you will be able to generate addresses that derive from the newly created wallet.

.. image:: CirrusAddress.png
     :width: 900px
     :alt: Cirrus Address
     :align: center

The Cirrus Token is required to interact or deploy contracts, the amount is wholly dependant on the computational cost defined by the complexity of the Smart Contract.

Initially you will need to obtain a minimum of 1 STRAT and have it available within the Stratis Core wallet. The Stratis Core wallet can be downloaded and installed from the below release page.

`https://github.com/stratisproject/StratisCore/releases
<https://github.com/stratisproject/StratisCore/releases>`_

Once you have installed Stratis Core, you will need to run it either on testnet or mainnet. As this document refers to the StratisTest (TestNet) network, you will need to run the wallet in testnet.

| **On Windows**
| From the command line run the following command:

::

    start "" "C:\\Program Files\Stratis Core\Stratis Core.exe" -testnet

| **On Mac**
| Open ScriptEditor to create a new applescript document and insert the following script:

::

    do shell script "open /Applications/Stratis\\ Core.app --args -testnet"

Save the script in the Applications folder with the name of StratisCoreTest.app and make sure to save it as an application type.

Once you have Stratis Core running on testnet, you will need to follow the prompted steps to create a wallet, once this wallet has been created, send a minimum of 1 STRAT to an address generated from the newly created wallet.

.. image:: StratisCore.png
     :width: 900px
     :alt: Stratis Core Dashboard
     :align: center

Once the balance is confirmed, you will need to perform a cross-chain transfer to the Cirrus Sidechain.

.. image:: StratisCore-Send.png
     :width: 900px
     :alt: Stratis Core Send
     :align: center

As this document refers to the StratisTest (TestNet) network, the StratisTest and CirrusTest federation addresses are being utilized.

Federation detail for both test environments and production environments can be found below:

| **Production Environment**
| **Stratis Federation Address:** sg3WNvfWFxLJXXPYsvhGDdzpc9bT4uRQsN
| **Cirrus Federation Address:** cnYBwudqzHBtGVELyQNUGzviKV4Ym3yiEo

| **Test Environment**
| **Stratis Federation Address:** 2N1wrNv5NDayLrKuph9YDVk8Fip8Wr8F8nX
| **Cirrus Federation Address:** xH1GHWVNKwdebkgiFPtQtM4qb3vrvNX2Rg

The exchange of STRAT for CRS is known as a Cross-Chain Transfer. Each Cross-Chain Transfer will subject to an exchange fee of 0.001, meaning if you perform a Cross-Chain Transfer of 1 STRAT you will receive 0.999 CRS Tokens.

A Cross-Chain Transfer is also subject to a larger amount of confirmations, this is to cater for any reorganisations on the network and invalid credits being made on either chain. The confirmation times can be seen below.

**STRAT to CRS:** 500 Blocks (64 Second Block Time x 500 Blocks = 32000 Seconds ÷ 60 = 533 Minutes ÷ 60 = 8 Hours 48 Minutes)

**CRS to STRAT:** 240 Blocks (16 Second Block Time x 240 Blocks = 3840 Seconds ÷ 60 = 64 Minutes)

Once 500 Blocks have passed after making a Cross-Chain Transfer from STRAT to CRS you will see the CRS Balance appear in your wallet.

.. image:: CirrusCore.png
     :width: 900px
     :alt: Cirrus Core Dashboard
     :align: center