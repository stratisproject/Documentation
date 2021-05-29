****************************************************
Creating a new feature summary
****************************************************

This chapter summarizes the steps that you need to take to create a custom feature:

1. Create a ``FullNodeBuilder`` extension method for your feature. There is no specific naming convention for these methods, but something like ``UseFeatureX()`` would be ideal. The extension method will need its own static class. Again, a name like ``FullNodeBuilderXExtension`` is ideal for the class but this is not enforced.
2. Create a class for the feature, which inherits from ``FullNodeFeature``, and implement at least the ``IFullNodeFeature.InitializeAsync()`` method.
3. Populate your feature extensions method using the same pattern found in the other extension methods:

	1. Call ``FullNodeBuilder.ConfigureFeature()`` with a lambda function as the parameter.
	2. Lambda A: Register your feature class with ``IFeatureCollection.AddFeature()`` and begin a fluid interface.
	3. If required, register dependencies by extending the fluid interface with calls to ``IFeatureRegistration.DependOn()``.
	4. Extend the fluid interface by making a call to ``IFeatureRegistration.FeatureServices()`` with a lambda function as the parameter.
	5. Lambda B: Register your feature interfaces and classes as singleton services using ``IServiceCollection.AddSingleton()``.   

4. Place a call to your feature extension method in the Full Node Builder fluid interface found in ``Main()``.  

  




