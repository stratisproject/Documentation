***************************************************************
Creating custom builds and extending the feature set
***************************************************************

The Stratis Full Node has a componentized architecture. This makes it easy to add and remove features and thereby customize a build to your own requirements.

The audience for this document is anyone who wants to create their own custom build of the Full Node. This could involve simply mixing and matching from the existing features. Alternatively, you might want to modify the capabilities of an existing feature or create an entirely new feature. The document begins by looking at how the projects supplied with the Full Node are put together before diving into the code behind one of the features. 

A knowledge of C# is assumed. In particular, `extension methods <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods>`_, `fluid interfaces <https://en.wikipedia.org/wiki/Fluent_interface>`_ and `lambda functions <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/statements-expressions-operators/lambda-expressions>`_ are used frequently in the feature code, so if any of these topics are new to you, you might want to read up on them. In addition, the `dependency injection (DI) software design pattern <https://en.wikipedia.org/wiki/Dependency_injection>`_ is used for instantiating all the main classes and interfaces that make up a feature. The Full Node uses the default DI facility available in .NET Core, which you can read more about `here <https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-2.2>`_. 

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   console-application-builds
   exploring-the-base-feature
   creating-a-new-feature-summary
