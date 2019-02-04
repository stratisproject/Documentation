***************************************************************
Specifying node and network settings 
***************************************************************

When it comes to individual settings Stratis Full Node is very configurable. Probably the most important settings relate to the network, and it is these settings that you can use to configure your own sidechain or mainchain network. This includes the creation of the genesis block,

This documents follows from :doc:`../Features/features>`, which pull features into a full node. This material details the configurfable values, which further define how these features will operate within the Full Node. For example, there is a setting that defines the maximum block size, and the consensus rules use this to check that the size of a block has not been exceeded. 
		/// <summary>
    	/// Сontains the configuration settings for a Full Node. These settings are taken from both the application command line arguments and the configuration file.
		/// Unlike the settings held by <see cref="Network"/>, these settings are individualized for each Full Node.
		/// </summary>
		
        /// <summary>The version of the protocol supported by the current implementation of the Full Node.</summary>
        public const ProtocolVersion SupportedProtocolVersion = ProtocolVersion.SENDHEADERS_VERSION;

        /// <summary>A factory responsible for creating a Full Node logger instance.</summary>
        public ILoggerFactory LoggerFactory { get; private set; }

        /// <summary>An instance of the Full Node logger, which reports on the Full Node's activity.</summary>
        public ILogger Logger { get; private set; }

        /// <summary>The settings of the Full Node's logger.</summary>
        public LogSettings Log { get; private set; }

        /// <summary>A list of paths to folders which Full Node components use to store data. These folders are found in the <see cref="DataDir"/>.</summary>
        public DataFolder DataFolder { get; private set; }

        /// <summary>The path to the data directory, which contains, for example, the configuration file, wallet files, and the file containing the peers that the Node has connected to. This value is read-only and can only be set via the NodeSettings constructor's arguments.</summary>
        public string DataDir { get; private set; }

        /// <summary>The path to the root data directory, which holds all node data on the machine. This includes separate subfolders for different nodes that run on the machine: a Stratis folder for a Stratis node, a Bitcoin folder for a Bitcoin node, and folders for any sidechain nodes. This value is read-only and can only be set via the NodeSettings constructor's arguments.</summary>
        public string DataDirRoot { get; private set; }

        /// <summary>The path to the Full Node's configuration file. This value is read-only and can only be set via the NodeSettings constructor's arguments.</summary>
        public string ConfigurationFile { get; private set; }

        /// <summary>A combination of the settings from the Full Node's configuration file and the command line arguments supplied to the Full Node when it was run. This places the settings from both sources into a single object, which is referenced at runtime.</summary>
        public TextFileConfiguration ConfigReader { get; private set; }

        /// <summary>The version of the protocol supported by the Full Node.</summary>
        public ProtocolVersion ProtocolVersion { get; private set; }

        /// <summary>The lowest version of the protocol which the Full Node supports.</summary>
        public ProtocolVersion? MinProtocolVersion { get; set; }

        /// <summary>The network which the node is configured to run on. The network can be a "mainnet", "testnet", or "regtest" network. All three network configurations can be defined, and one is selected at the command line (via the  <see cref="NetworkSelector" class) to connect to. A Full Node defaults to running on the mainnet.</summary>
        public Network Network { get; private set; }

        /// <summary>A string that is used to help identify the Full Node when it connects to other peers on a network.
		/// Defaults to "StratisNode".
		/// </summary>
        public string Agent { get; private set; }

        /// <summary>The minimum fee for a kB of transactions on the node.</summary>
        public FeeRate MinTxFeeRate { get; private set; }

        /// <summary>The default fee for a kB of transactions on the node. This is used if no fee is specified for a transaction.</summary>
        public FeeRate FallbackTxFeeRate { get; private set; }

        /// <summary>The minimum relay transaction fee for a kB of transactions on the node. This is the minimum fee for a transaction to be propagated to other peers. A miner may not be prepared to mine a transaction for the specified fee but might be prepared to forward the transaction to another miner who will. For this reason, the minimum relay transaction fee is usually lower than the minimum fee.</summary>
        public FeeRate MinRelayTxFeeRate { get; private set; }


.. toctree::
   :maxdepth: 2
   :caption: Contents:



