.. _creating-headless-network:

******************
Creating a Network 
******************

This section specifically focuses on those who are wanting to develop in a headless environment. If you would prefer to complete the tutorials with the use of a GUI, please follow the GUI focused guides on :ref:`gui-tutorials`.

Pre-Requisites
==============

This guide requires Docker Community Edition to be installed, this can be obtained from `here <https://docs.docker.com/install/>`_

******************
Starting a Network
******************

To begin, you first need to obtain the relevant Docker Image from the following repository and clone the respective repository.

::

	docker pull stratisplatform/stratisfullnode:Stratis.CirrusMinerD-1.1.0.0-ext

Once the Docker Image has been pulled, you can bring up a network of your choosing by executing the below command.

::

	docker run -p 38223:38223 stratisplatform/stratisfullnode:Stratis.CirrusMinerD-1.1.0.0-ext 

Interacting with the Network
============================

Once the network is running, you can interact with each node via RESTFul API, available on http://localhost:38223/Swagger that is presented by the node. The available endponints are documented on the :ref:`developers-api` page. 