*******************************************
Creating the genesis block
*******************************************

Running the mining node with the ``FederationKey.dat`` file in its data directory will result in mining taking place. However, we only want to mine the genesis block, and then abort the node before it begins to create the premine block. 

Now run the node and keep a close eye on the miner node output. When you see the following output, shut the node down using ``Ctrl + C``:

::

    info: Stratis.Bitcoin.Features.PoA.PoAMiner[0]
          <<==============================================================>>
          Block was mined 1-01ed0a5f66d8a2628e790968e96e5ddd53d66005eb9284f9fb29d7fb1a19a8b7.
          <<==============================================================>>

The code behind the creation of the genesis block
==================================================

Now let's take a closer look at the code `behind the genesis block <https://github.com/stratisproject/StratisBitcoinFullNode/blob/LSC-tutorial/src/Stratis.LocalSmartContracts.Networks/LocalSmartContractsNetwork.cs>`_. We took a look at one of the settings, ``GenesisTime``, and updated it when first running the miner.  

::

    // Create the genesis block.
    this.GenesisTime = 1545310504;
    this.GenesisNonce = 761900;
    this.GenesisBits = new Target(new uint256("00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"));
    this.GenesisVersion = 1;
    this.GenesisReward = Money.Zero;

    string coinbaseText = "https://www.bbc.co.uk/news/world-africa-45889707?intlink_from_url=https://www.bbc.co.uk/news/topics/cyd7z4rvdm3t/crypto-currency&link_location=live-reporting-story";
    Block genesisBlock = LocalSmartContractsNetwork.CreateGenesis(consensusFactory, this.GenesisTime, this.GenesisNonce, this.GenesisBits, this.GenesisVersion, this.GenesisReward, coinbaseText);

    this.Genesis = genesisBlock;

The genesis block contains a single transaction, which has one transaction input and one transaction output. Some of the genesis block settings are in fact stored as members of the ``LocalSmartContractsMain`` class:

+----------------+------------------------------------------------------------------------------------------------------------------+
| Setting        | Description                                                                                                      |
+================+==================================================================================================================+
| GenesisTime    | The UNIX time for the genesis block.                                                                             |
+----------------+------------------------------------------------------------------------------------------------------------------+
| GenesisNonce   | Not used by a PoA blockchain so a random value is supplied.                                                      |
+----------------+------------------------------------------------------------------------------------------------------------------+
| GenesisBits    | Not used by a PoA blockchain so a random value is supplied.                                                      |
+----------------+------------------------------------------------------------------------------------------------------------------+
| GenesisVersion | The version of the genesis block. Note that this is different from transaction versioning.                       |
+----------------+------------------------------------------------------------------------------------------------------------------+
| GenesisReward  | There is no reward for mining the genesis block as any transaction output for the genesis block cannot be spent. |
+----------------+------------------------------------------------------------------------------------------------------------------+
| coinbaseText   | Used as input to the first genesis block transaction. Not stored in the LocalSmartContractsMain class.           |
+----------------+------------------------------------------------------------------------------------------------------------------+

The genesis block is also stored as a ``LocalSmartContractsMain`` class member once it has been created. Now let's look at the ``Network`` class extension method that creates the genesis block:

::

    public static Block CreateGenesis(SmartContractPoAConsensusFactory consensusFactory, uint genesisTime, uint nonce, uint bits, int version, Money reward, string coinbaseText)
    {
        Transaction genesisTransaction = consensusFactory.CreateTransaction();
        genesisTransaction.Time = genesisTime;
        genesisTransaction.Version = 1;
        genesisTransaction.AddInput(new TxIn()
        {
            ScriptSig = new Script(Op.GetPushOp(0), new Op()
            {
                Code = (OpcodeType)0x1,
                PushData = new[] { (byte)42 }
            }, Op.GetPushOp(Encoders.ASCII.DecodeData(coinbaseText)))
        });

        genesisTransaction.AddOutput(new TxOut()
        {
            Value = reward
        });

        Block genesis = consensusFactory.CreateBlock();
        genesis.Header.BlockTime = Utils.UnixTimeToDateTime(genesisTime);
        genesis.Header.Bits = bits;
        genesis.Header.Nonce = nonce;
        genesis.Header.Version = version;
        genesis.Transactions.Add(genesisTransaction);
        genesis.Header.HashPrevBlock = uint256.Zero;
        genesis.UpdateMerkleRoot();

        ((SmartContractPoABlockHeader)genesis.Header).HashStateRoot = new uint256("21B463E3B52F6201C0AD6C991BE0485B6EF8C092E64583FFA655CC1B171FE856");
        return genesis;
    }

You will notice the values passed to this function being added to the genesis header. As this is the genesis block, a value of 0 is specified for the hash of the previous block. The ``SmartContractPoABlockHeader.HashStateRoot`` is required on a blockchain supporting smart contracts and represents the state root of an empty Patricia Trie.

The genesis block transaction
------------------------------

The genesis block transaction is given the same time as the genesis block and has one input and one output.

Normally, transaction inputs consist of UTXOs, which are being spent in the transaction. The input here is not a normal input, and is a reference to a blockchain-related article from the BBC. It can be any string but choosing a news article proves the genesis block was created on the same day of the article or after the article. It is a consensus requirement that every transaction in a block should have at least one input, so from this perspective, it is also necessary to create this "news item" input.

The transaction output takes the reward argument, which is 0. Because the genesis block does not undergo full validation, it is not possible to create a spendable UTXO for a genesis block. Therefore, the zero value makes sense and there is no need to create a `locking script <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch06.asciidoc#script-construction-lock--unlock>`_ for this UTXO.
