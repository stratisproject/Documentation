****************************************************
Exploring the Base Feature of the Full Node 
****************************************************

This chapter takes a look at how the Base Feature is declared and implemented.

The ``UseBaseFeature()`` function, which we saw in the previous chapter being called from ``UseNodeSettings()``, is an extension method as well. It is defined in the `FullNodeBuilderBaseFeatureExtension  <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin/Base/BaseFeature.cs>`_ class and extends the Full Node Builder too. 

Features have their own classes, and in the case of the Base Feature, this is the `BaseFeature <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin/Base/BaseFeature.cs>`_ class. Feature classes inherit from the abstract `FullNodeFeature <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin/Builder/Feature/FullNodeFeature.cs>`_ class, which implements the `IFullNodeFeature <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin/Builder/Feature/FullNodeFeature.cs>`_ interface. The only requirement of ``FullNodeFeature`` subclasses is to implement the ``InitializeAsync()`` method, although they may need to override the empty ``Dispose()`` and ``ValidateDependencies()`` methods. In addition, the subclasses will have their own feature-specific methods and properties. 

The ``UseBaseFeature()`` function typifies how a feature is added to a build of the Full Node:

::

    public static IFullNodeBuilder UseBaseFeature(this IFullNodeBuilder fullNodeBuilder)
    {
        fullNodeBuilder.ConfigureFeature(features =>
        {
            features
            .AddFeature<BaseFeature>()
            .FeatureServices(services =>
            {
                services.AddSingleton<DBreezeSerializer>();
                services.AddSingleton(fullNodeBuilder.NodeSettings.LoggerFactory);
                services.AddSingleton(fullNodeBuilder.NodeSettings.DataFolder);
                services.AddSingleton<INodeLifetime, NodeLifetime>();
                services.AddSingleton<IPeerBanning, PeerBanning>();
                services.AddSingleton<FullNodeFeatureExecutor>();
                services.AddSingleton<Signals.Signals>().AddSingleton<ISignals, Signals.Signals>(provider => provider.GetService<Signals.Signals>());
                services.AddSingleton<FullNode>().AddSingleton((provider) => { return provider.GetService<FullNode>() as IFullNode; });
                services.AddSingleton<ConcurrentChain>(new ConcurrentChain(fullNodeBuilder.Network));
                services.AddSingleton<IDateTimeProvider>(DateTimeProvider.Default);
                services.AddSingleton<IInvalidBlockHashStore, InvalidBlockHashStore>();
                services.AddSingleton<IChainState, ChainState>();
                services.AddSingleton<IChainRepository, ChainRepository>();
                services.AddSingleton<IFinalizedBlockInfoRepository, FinalizedBlockInfoRepository>();
                services.AddSingleton<ITimeSyncBehaviorState, TimeSyncBehaviorState>();
                services.AddSingleton<IAsyncLoopFactory, AsyncLoopFactory>();
                services.AddSingleton<NodeDeployments>();
                services.AddSingleton<IInitialBlockDownloadState, InitialBlockDownloadState>();

                // Consensus
                services.AddSingleton<ConsensusSettings>();
                services.AddSingleton<ICheckpoints, Checkpoints>();

                // Connection
                services.AddSingleton<INetworkPeerFactory, NetworkPeerFactory>();
                services.AddSingleton<NetworkPeerConnectionParameters>();
                services.AddSingleton<IConnectionManager, ConnectionManager>();
                services.AddSingleton<ConnectionManagerSettings>();
                services.AddSingleton<PayloadProvider>(new PayloadProvider().DiscoverPayloads());
                services.AddSingleton<IVersionProvider, VersionProvider>();
                services.AddSingleton<IBlockPuller, BlockPuller>();

                // Peer address manager
                services.AddSingleton<IPeerAddressManager, PeerAddressManager>();
                services.AddSingleton<IPeerConnector, PeerConnectorAddNode>();
                services.AddSingleton<IPeerConnector, PeerConnectorConnectNode>();
                services.AddSingleton<IPeerConnector, PeerConnectorDiscovery>();
                services.AddSingleton<IPeerDiscovery, PeerDiscovery>();
                services.AddSingleton<ISelfEndpointTracker, SelfEndpointTracker>();

                // Consensus
                services.AddSingleton<IConsensusManager, ConsensusManager>(); 
                services.AddSingleton<IChainedHeaderTree, ChainedHeaderTree>();
                services.AddSingleton<IHeaderValidator, HeaderValidator>();
                services.AddSingleton<IIntegrityValidator, IntegrityValidator>();
                services.AddSingleton<IPartialValidator, PartialValidator>();
                services.AddSingleton<IFullValidator, FullValidator>();

                // Console
                services.AddSingleton<INodeStats, NodeStats>();
            });
        });

        return fullNodeBuilder;
    }

.. note:: When you supply a parameter via a lambda function, the code in the lambda function is only executed when the parameter is first used in the function. Keeping this in mind can help when visualizing the exact sequence of events in the code above.

There are four basic steps to the process:

1. ``FullNodeBuilder.ConfigureFeature()`` is called. The function takes an ``IFeatureCollection`` interface and expects the collection to hold one or more features.
2. ``IFeatureCollection.AddFeature()`` adds the ``BaseFeature`` to the collection. ``AddFeature()`` creates a Feature Registration for the feature and returns an ``IFeatureRegistration`` interface.
3. ``IFeatureRegistration.FeatureServices()`` is called. The function takes an ``IServiceCollection`` interface and expects the collection to hold the services required for the feature.
4. ``IServiceCollection.AddSingleton()`` adds classes and interfaces to the collection and specifies that they should be singletons. When adding an interface, a class that implements the interface must be supplied as the second parameter.

.. note:: The Full Node uses a Direct Injection design pattern. For example, if you search the Full Node code for a place where a ``ConsensusManager`` constructor is called, you will not find it. When a class depends on ``ConsensusManager``, an instance of ``ConsensusManager`` will be created, or if an instance already exists, this will be used. This behavior is defined by ``AddSingleton()`` and by making this call you inform the Direct Injection implementation how to provide the service. The Full Node relies exclusively on the singleton design pattern when providing services and you should continue this pattern with any features that you create or modify. 

Essentially, the feature ``FullNodeBuilder.ConfigureFeature()`` receives has the services it requires fully defined. If you need to create your own feature or customize an existing one by adding some extra services, you should follow the pattern above.

Other Full Node features
=========================

Each Full Node feature usually has its own project in the source code, and every feature has its own Full Node Builder extension method, which is declared in a static class. As a general rule, the static class is named FullNodeBuilder*Extension.cs and held in a file called \*Feature.cs (found at the top level of a feature project) where \* is the name of the feature. The feature class (\*Feature) is also usually declared in this file too.

It is a good idea to look at the code for including some of the other features in a build. Comparing the code of the different features can help cement the ideas behind the Full Node Builder in your mind.

:ref:`registering-consensus-features` discusses the registration of consensus features. In particular, it focusses on how you would adapt an existing registration to create the code for your own custom consensus feature.



