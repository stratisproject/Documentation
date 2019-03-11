*******************************************
Creating the premine block
*******************************************

The premine block is particularly important as it is here that the miner node creates the 100,000,000 LSC tokens that you will use to fund your smart contracts! The block is called the premine block because, even though it contains one transaction, the network cannot produce any transactions to mine before its creation. As you will see, in our setup, the premine is set to occur as soon as possible. However, it could be delayed for number of blocks after the genesis block, and in this case, none of these blocks would contain transactions.

The first step is to create a wallet on the miner to pay the tokens into.

Your miner's wallet
==================================

To create a wallet, we will use the Swagger API, which requires that a node is running. Now we have mined the genesis block, we do not want the node to mine until we have a wallet to pay tokens to. To temporarily stop the node mining, *move the federationKey.dat file out of the data directory* and then run the node again.

Once the miner has started up, connect to the miner using Swagger: 

http://localhost:38201/swagger/index.html

First, create a mnemonic for the wallet using the ``/api/Wallet/mnemonic`` API call. A mnemonic of 12 words is fine for our purposes.

Next, use the ``api/Wallet/create`` API call to create the wallet. Use the name "LSC_miner_wallet" and give a suitable password and passphrase. The wallet should now appear in your node output:

::

    ======Wallets======
    Wallet[SC]: LSC_miner_wallet,     Confirmed balance: 0.00000000

At the moment, the balance is 0.

How does the premine block create the tokens
=============================================

With the exception of the genesis block, block templates are created for each block using the `BlockDefinition <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.Bitcoin.Features.Miner/BlockDefinition.cs>`_ class. The ``BlockDefinition`` class is abstract, which means it requires subclassing. The LSC network uses the `SmartContractPoABlockDefinition <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.Bitcoin.Features.SmartContracts/PoA/SmartContractPoABlockDefinition.cs>`_ class, which, in fact, only adds minimal functionality. The ``SmartContractPoABlockDefinition`` inherits from `SmartContractBlockDefinition <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.Bitcoin.Features.SmartContracts/PoW/SmartContractBlockDefinition.cs>`_, and in this class more smart contract specific functionality is added.

The code which creates the LSC tokens as a spendable UTXO in the miner's wallet is in the ``BlockDefinition.onBuild()`` base function, which is called from ``SmartContractBlockDefinition.Build()``. ``Build()`` takes a ``Script`` argument:

::

    public override BlockTemplate Build(ChainedHeader chainTip, Script scriptPubKeyIn)
    {

The passed script is a `scriptPubKey <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch06.asciidoc#script-construction-lock--unlock>`_, which defines who has the right to spend the tokens created in ``onBuild()``. In this case, the hashed public key in the script relates to (is taken from) an *unused address* from the *first account (account 0)* in the *first wallet* on the node. You can see the code for this in the private ``GetScriptPubKeyFromWallet()`` function in the `PoAMiner <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.Bitcoin.Features.PoA/PoAMiner.cs>`_ class:

::

    private Script GetScriptPubKeyFromWallet()
    {
        string walletName = this.walletManager.GetWalletsNames().FirstOrDefault();

        if (walletName == null)
            return null;

        HdAccount account = this.walletManager.GetAccounts(walletName).FirstOrDefault();

        if (account == null)
            return null;

        var walletAccountReference = new WalletAccountReference(walletName, account.Name);

        HdAddress address = this.walletManager.GetUnusedAddress(walletAccountReference);

        return address.Pubkey;
    }

.. note:: In the above code excerpt, ``return address.Pubkey;`` returns the full scriptPubKey locking script.

Now take a look at the following code excerpt from ``onBuild()``.

::

    var coinviewRule = this.ConsensusManager.ConsensusRules.GetRule<CoinViewRule>();
    this.coinbase.Outputs[0].Value = this.fees + coinviewRule.GetProofOfWorkReward(this.height);

Even though this is a PoA network, the code path being followed is anaologous to a `Proof-of-Work <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch10.asciidoc#proof-of-work-algorithm>`_ network with the tokens being added to a `coinbase transaction output <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch10.asciidoc#the-coinbase-transaction>`_ (previously created). The code that actually checks how many tokens to create is part of :doc:`the rules used by the consensus manager </../../FullNode/Consensus/customising-consensus-rule-engines>`. Find the ``GetProofOfWorkReward()`` function in the `PoACoinviewRule <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.Bitcoin.Features.PoA/BasePoAFeatureConsensusRules/PoACoinviewRule.cs>`_ class:

::

    public override Money GetProofOfWorkReward(int height)
    {
        if (height == this.network.Consensus.PremineHeight)
            return this.network.Consensus.PremineReward;

        return 0;
    }

Here we can see two settings in the ``Consensus`` object held by our network class being used: ``PremineHeight`` and ``PremineReward``. *In general, this shows the importance of a network class, which is referenced in many places in the source code, as the definer of the network.*

The PremineHeight setting
----------------------------

This is the block height at which a node creates the premine block. You can see the ``PremineHeight`` property has been set to 2 in `LocalSmartContractsNetwork <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.LocalSmartContracts.Networks/LocalSmartContractsNetwork.cs>`_ class.

The PremineReward setting
----------------------------

This is the reward for the mining the premine block. You can see the ``PremineReward`` property has been set to 100,000,000 in `LocalSmartContractsNetwork <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.LocalSmartContracts.Networks/LocalSmartContractsNetwork.cs>`_ class. A `Money <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/NBitcoin/Money.cs>`_ object is used to specify 100,000,000 tokens:

::

    this.Consensus = new NBitcoin.Consensus(
        ...
        premineReward: Money.Coins(100_000_000),
        proofOfWorkReward: Money.Coins(0),
        ...
        );

Alhough there is a setting for ``proofOfWorkReward``, it is not used because there is no reward for mining blocks on on a PoA network. 

Mining the premine block
====================================

Put the ``federationKey.dat`` file into data directory and run the miner node again. The node will rebuild as one line of source code has changed.

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

.. note:: If you follow the Node Stats in the console output, you will notice that the ``Consensus.Height`` reaches 4 before the balance is displayed in the wallet. The ``Consensus.Height`` after mining the premine block is 2. The delay is because the premine transaction is being confirmed. This delay is defined by ``Consensus.CoinbaseMaturity`` and is set to 1 in ``LocalSmartContractsNetwork`` class; so one block must be mined after the premine block before the UTXO created in it is considered spendable. As you make transactions to deploy and call methods on smart contracts, you will notice that these transactions also take one block to confirm.

.. note:: You must now stop the miner and remove the ``-bootstrap`` config option in last line of the miner script. The miner will now only mine when other peers are connected, which is required for normal running of a PoA network.

