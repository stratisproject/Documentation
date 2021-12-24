
Getting Started
===============

In this tutorial, we'll show you how to set up a basic UE4 project with `Stratis Plugin <https://github.com/stratisproject/UnrealEnginePlugin>`_ on board.
If you are looking for more information about Unreal Engine itself, please follow `an official UE's website <https://www.unrealengine.com/>`_.

**Let's go!**

Prerequisite
^^^^^^^^^^^^

First of all, you need Unreal Engine to be installed on your computer. If you don't have it yet, you can `get it on the official website <https://www.unrealengine.com/>`_.
As well as Unreal Engine, you need a Stratis Full Node to be installed either on your local machine or remote web server. Please check `Stratis Academy <https://academy.stratisplatform.com/Developer%20Resources/Stratis%20Full%20Node/Running.html#>`_ if you need an Operation Guide for Full Node.
Also, you need something like a text editor or an IDE if you are going to work with C++ in your project. UE4 supports Visual Studio, Visual Studio Code, XCode, CLion, etc.
Finally, some experience with Git will be very useful. If you want to learn more about Git VSC, please `follow git-scm.com <https://git-scm.com/>`_.

Creating a sample project
^^^^^^^^^^^^^^^^^^^^^^^^^

Now we are going to create our new project. Run Unreal Engine, find a project browser, and pick the **Games** category. Now we can see a list of available project templates we can use. Let's just pick a **First Person** template, but if you are familiar with UE, you can go with any of them. On the next page, set the path and name for your project, and choose the programming language you want to go with. You can choose from C++ and Blueprint, and if you are not familiar with C-style programming languages, it's better to go ahead with Blueprint. Remember, you can always add C++ classes to the Blueprint project (and vice versa) later. 

..

But what is Blueprint? Blueprint is a graphical programming language used in Unreal Engine to simplify development for non-programmers and for people who are not familiar with C++. **Stratis Unreal Plugin** supports both C++ and Blueprint, so you can choose the tool you are more comfortable with.


Then, just press the **Create project** button and voilà, we did it!

Installing Stratis Unreal Plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Next, we need to install the plugin within our new project path. Go to the project path and create the **Plugin** directory (if it does not exist).

..

Stratis Unreal Plugin uses Git LFS to maintain a large precompiled third-party dependencies for each of the supported platforms. You need to ensure that the LFS extension is installed on your computer, or you can get it from `the official website <https://git-lfs.github.com/>`_.


Now go to the `Stratis Unreal Plugin <https://github.com/stratisproject/UnrealEnginePlugin>`_ GitHub repository and clone it to the **Plugin** directory. Rename the cloned directory to **Stratis** to eliminate potential missing path problems. Ensure that precompiled libraries within your plugin installation have a proper size (hundreds of MB), and if it's not, make sure you have the Git LFS plugin installed within your environment.

Compilation & running sample game
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now we have a successfully set up project & plugin, so let's build the project and run the sample game! For that, let's restart Unreal Engine Editor, reopen our project and Unreal Engine will ask us to recompile the project. Press the confirmation button and wait until the compilation ended. Finally, press the **Play** button on the toolbar and enjoy your game!

What's next?
^^^^^^^^^^^^

Now you can use **Stratis Unreal Plugin** functionality & Statis Blockchain eco-system to build next-level gameplay & economics within your game! In the next tutorials, we will show you how to use STRAX currency and NFT in your games. 

If you found a problem, you can `open an issue <https://github.com/stratisproject/UnrealEnginePlugin/issues>`_ on the project's Github page.
If you still have questions, feel free to ask them in `our Discord channel <https://discord.gg/9tDyfZs>`_.

Stay tuned!
