*******************************************
Creating the premine block
*******************************************

The premine block is particularly important as it is here that the miner node creates the 100,000,000 LSC tokens that you will use to fund your smart contracts! The first step is to create a wallet to pay the funds into.

Your miner's wallet
==================================

To create a wallet, we will use the Swagger API, which requires that a node is running. Now we have mined the genesis block, we do not want the node to mine until we have an address from our new wallet to pay the funds to. To temporarilly stop the node mining, move the federationKey.dat file out of the data directory and then run the node again using the script.

Connect to the miner node using Swagger: 

http://localhost:38201/swagger/index.html

First, create a mnemonic for the wallet using the ``/api/Wallet/mnemonic`` API call. A mnemonic of 12 words is fine for our purposes.

Next, use the ``api/Wallet/create`` API call to create the wallet. Use the name "LSC_miner_wallet" and give a suitable password and passphrase. The wallet should now appear in your node output:

::

    ======Wallets======
    Wallet[SC]: LSC_miner_wallet,     Confirmed balance: 0.00000000

At the moment, the balance is 0.

The code behind the premine block
====================================

In this Local Smart Contract network, the LSC tokens are simply paid into a wallet held by the miner. However, the address to pay the tokens into in the repository code needs to be updated to one from your miner's new wallet; otherwise the 100,000,000 LSC tokens will be lost! This is because the address provided in the relavent code was generated for another wallet on another instance of the LSC network. In general, on a blockchain, if funds are paid to an address and that address does not exist in any wallet on that blockchain, the funds are lost.

The ``FederatedPegBlockDefinition.Build()`` function contains the code to ensure a reward is paid to a block miner. Under normal circumstances the ``rewardScript`` pays 1 STRAT to the block miner. However, if this function detects that it is mining a premine block, then it premines the tokens and pays them to the wallet address provided.  

::

    public override BlockTemplate Build(ChainedHeader chainTip, Script scriptPubKey)
    {
        BitcoinAddress bitcoinAddress = BitcoinAddress.Create("CP9G8ZHYTcU9hK9vXKKaYExt9G74sEWC1X", this.Network);
        Script rewardScript = (chainTip.Height + 1) == this.Network.Consensus.PremineHeight
            ? bitcoinAddress.ScriptPubKey
            : this.payToMemberScript;

        return base.Build(chainTip, rewardScript);
    }

You only have to alter the 34 character address string to an address you have generated for your miner's wallet using the following ``api/Wallet/unusedaddress`` API call.

The PremineHeight setting
----------------------------

You may have guessed from the code above that the block height at which a node creates the is held as setting on the ``Consensus`` class. You can see it has been set to 2 in ``LocalSmartContractsMain`` class, which defines the Local Sidechain Network. The ``Network`` is a very important base class, and classes which inherit from it are used to define networks.  

Creating the premine block
====================================

Put the federationKey.dat file into data directory and run the miner node again. The node will rebuild as one line of source code has changed.

Look out for the following output, which indicates the premine block has been mined:

::

    info: Stratis.Bitcoin.Features.PoA.PoAMiner[0]
          <<==============================================================>>
          Block was mined 1-01ed0a5f66d8a2628e790968e96e5ddd53d66005eb9284f9fb29d7fb1a19a8b7.
          <<==============================================================>>

Your wallet should display the balance:

::

      ======Wallets======
      Wallet[SC]: LocalSC_wallet1,     Confirmed balance: 100000000.00000000

Congratulations, you have now created your own local network on which to run smart contracts.
