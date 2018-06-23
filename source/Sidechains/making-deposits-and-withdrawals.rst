###########################################################
Making deposits and withdrawals to and from the sidechain
###########################################################

This chapter details the practical steps you just take to make deposits and withdrawals to and from a sidechain. To begin with, you must download two wallets:

1. A version of the Stratis Core with sidechain deposit functionality ||Link
2. The APEX wallet ||Link

Turning on cross-chain functionality
====================================
Before you begin make cross-chain transactions, you must ensure cross-chain functionality is turned on in the wallet you are using. The procedure is the same for both wallets. The screenshots below are from the Stratis Core wallet.

1. On the main page, click the *Settings* button.
2. The *Settings* dialog is displayed:

 .. image:: settings.png
     :width: 900px
     :alt: Stratis Core settings
     :align: center

3. Click the *Enable* button for Cross-Chain transactions.
4. Click the *Save* button.

Deposit TSTRAT on the sidechain using the Stratis Core wallet
===============================================================

1. Log in to your Stratis Core wallet.

 .. image:: stratis-core-main-page.png
     :width: 900px
     :alt: Stratis Core main page
     :align: center
	 
2. On the main page, click the *Cross-Chain* button.
3. The *Deposit to Sidechain* dialog is shown.

 .. image:: deposit-to-sidechain.png
     :width: 900px
     :alt: Stratis Core main page
     :align: center

4. Specify the amount of TSTRAT you wish to deposit.
5. Specify the Mainchain Federation address. For the alpha release of sidechains, use ??Add later??. This is a P2SH address. More details are available here. || Link
6. Specify the Sidechain Destination address. You can obtain an address by clicking the *Receive* button in your APEX wallet.
7. Specify a transaction fee.
8. Enter your wallet password and press the *Deposit* button.

Withdraw TSTRAT on the sidechain using the Stratis Core wallet
===============================================================

1. Log in to your APEX wallet.

 .. image:: stratis-core-main-page.png
     :width: 900px
     :alt: APEX wallet main page
     :align: center

2. On the main page, click the *Cross-Chain* button.
3. The *Withdraw from Sidechain* dialog is shown.

 .. image:: withdraw-from-sidechain.png
     :width: 900px
     :alt: Stratis Core main page
     :align: center
	 
4. Specify the amount of TAPEX you wish to withdraw. TAPEX have a 1:1 ratio with TSTRAT.
5. Specify the Sidechain Federation address. For the alpha release of sidechains use ??Add later??. This is a P2SH address. More details are available here. || Link
6. Specify the Mainchain Destination address. You can obtain an address by clicking the *Receive* button in your Stratis Core wallet.
7. Specify a transaction fee.
8. Enter your wallet password and press the *Deposit* button.

Setting up to auto-population for the Federation address 
=========================================================

You can speed up the deposit and withdrawal process by setting a default Federation address to use each time you make a cross-chain transaction. The procedure is the same for both wallets. The screenshots below are from the Stratis Core wallet.

1. On the main page, click the *Settings* button.
2. The *Settings* dialog is displayed:

 .. image:: settings.png
     :width: 900px
     :alt: Stratis Core settings
     :align: center

3. Click the *Enable* button for Federation address auto-populate.

 .. image:: default-federation-address.png
     :width: 900px
     :alt: Stratis Core settings
     :align: center
 
4. Add the default address. For the alpha release of sidechains, use ??Add later?? for the mainchain federation address and ??Add later?? for the sidechain federation address.
5. Click the *Save* button.

Getting the funds to make deposits on the sidechain
=====================================================

The easiest way to get some TSTRAT to deposit on the sidechain is to use the `smart contracts faucet <https://smartcontractsfaucet.stratisplatform.com/>`_. To receive 100 TSTRAT, specify a TSTRAT address from your Stratis Core wallet. You can then use these funds to make a deposit on the sidechain, and from there, you can begin making further transactions on the sidechain including withdrawals. 







