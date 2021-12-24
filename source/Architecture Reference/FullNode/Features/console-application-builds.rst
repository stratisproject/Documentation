******************************************************************
The supplied console application builds
******************************************************************

When you open up the Stratis.FullNode solution in Visual Studio, you will notice that nine projects at the top level. Six of these projects build the Full Node as a console application, and we will be taking a closer look at these. The following table describes the purpose of the six projects:

+--------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| Project                        | Description                                                                                                                  |
+================================+==============================================================================================================================+
| Stratis.StraxD                 | Runs the Full Node as a daemon on the Stratis network.                                                                       |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| Stratis.StraxDnsD              | Runs the Full Node with a DNS service for initial peer discovery.                                                            |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| Stratis.CirrusD                | Runs the Full Node as a daemon on the Cirrus network.                                                                        |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| Stratis.CirrusDnsD             | Runs the Full Node with a DNS service for initial peer discovery.                                                            |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| Stratis.CirrusMinerD           | Runs the Full Node with the Miner Feature on the Cirrus Network (Masternode)                                                 |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------+

If you look inside any of these projects, you will notice a single C# file, program.cs, which contains the entry point, ``Main()``, for the application.

What happens in Main()?
========================

It is in the ``Main()`` function that the settings for a Full Node are registered and its features are added in. Let's take a look at what happens in ``Main()`` at the code level using the Stratis.StraxD project as an example.

::

    public class Program
    {
        public static async Task Main(string[] args)
        {
            try
            {
                var nodeSettings = new NodeSettings(networksSelector: Networks.Strax, protocolVersion: ProtocolVersion.PROVEN_HEADER_VERSION, args: args)
                {
                    MinProtocolVersion = ProtocolVersion.PROVEN_HEADER_VERSION
                };

                Console.Title = $"Strax Full Node {nodeSettings.Network.NetworkType}";

                DbType dbType = nodeSettings.GetDbType();

                IFullNodeBuilder nodeBuilder = new FullNodeBuilder()
                    .UseNodeSettings(nodeSettings, dbType)
                    .UseBlockStore(dbType)
                    .UsePosConsensus(dbType)
                    .UseMempool()
                    .UseColdStakingWallet()
                    .AddSQLiteWalletRepository()
                    .AddPowPosMining(true)
                    .UseApi()
                    .UseUnity3dApi()
                    .AddRPC()
                    .AddSignalR(options =>
                    {
                        DaemonConfiguration.ConfigureSignalRForStrax(options);
                    })
                    .UseDiagnosticFeature();

                IFullNode node = nodeBuilder.Build();

                if (node != null)
                    await node.RunAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine("There was a problem initializing the node. Details: '{0}'", ex);
            }
        }
    }


Two classes are instantiated in the ``Main()`` function: `NodeSettings <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin/Configuration/NodeSettings.cs>`_ and `FullNodeBuilder <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin/Builder/FullNodeBuilder.cs>`_.

``NodeSettings`` contains the configuration for the node, and ``FullNodeBuilder`` is responsible for adding features to the node. Take a look at the fluid interface that creates the instance of the node. To make the settings available to the Full Node Builder, the instance of ``NodeSettings`` needs to first be supplied using ``UseNodeSettings()``. Next, all the features are added. Finally, ``Build()`` is called, which returns an ``IFullNode`` interface. A call is made to ``IFullNode.RunAsync()``, and the node is up and running. All six of the console applications follow this pattern.

If you look at the ``FullNodeBuilder`` class, you will notice that ``Build()`` is the only function, out of those called in ``Main()``, that is declared in the class. The other functions, which pull in the features, are `extension methods <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods>`_. ``UseNodeSettings()`` is, for example, declared in the static `FullNodeBuilderNodeSettingsExtension <https://github.com/stratisproject/StratisBitcoinFullNode/blob/master/src/Stratis.Bitcoin/Builder/FullNodeBuilderNodeSettingsExtension.cs>`_ class. The other functions are also declared in static extension classes. As you will see, if you create your own Full Node feature, you will create an extension function to register it.

The ``UseNodeSettings()`` function is a useful entry point to the next topic. You will notice that the last line in the function makes a call to ``UseBaseFeature()``. The next chapter will explore how features (components) are defined in the Full Node using the Base Feature as an example. Adding the Base Feature in is, in fact, an obligatory step, when building the Full Node, and for this reason, calling ``UseBaseFeature()`` before the ``Build()`` call is an obligatory step too.

.. note:: If your goal is to create a build of the Full Node which uses a different set of features to any of the supplied builds, you should be able to create your own modified build now. Look at the existing builds to see the functions that pull in the feature sets. Then create your own project with a modified Program.cs.   
