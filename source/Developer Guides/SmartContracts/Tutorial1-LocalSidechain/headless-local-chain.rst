****************************************************
Running the Cirrus Core (Developer Edition) Headless  
****************************************************

This section specifically focuses on those who are wanting to develop in a headless environment. If you have followed the previous tutorial, utilising the Cirrus Core UI then this section can be skipped and you can continue on to * :ref:`hello-world-tutorial-introduction`.

Pre-Requisites
==============

This guide requires Docker Community Edition to be installed, this can be obtained from `here <https://docs.docker.com/install/>`_

Getting Started
===============

There are a number of network designs that can be configured and run, these network designs are defined within Docker Compose files. These configuration files can be located in the ``./Docker/Docker-Compose`` directory from the below GitHub repositories.

Standard: https://github.com/stratisproject/StratisBitcoinFullNode/tree/DeveloperEdition

DLT: https://github.com/stratisproject/StratisBitcoinFullNode/tree/DeveloperEdition-DLT

The key difference between either repository lies within the need for determinism. In a public blockchain environment, determinism is key and ultimatley required for all participating block producers to reach consesnsus. However, within a DLT environment the behaviour of a network can be more predictable and adhere to a Leader-Follower consesnsus.

Starting a Network
==================

To begin, you first need to obtain the relevant Docker Image from the following repository and clone the respective repository.

::

	git clone https://github.com/stratisproject/StratisBitcoinFullNode -b DeveloperEdition

	docker pull stratisgroupltd/blockchaincovid19:latest

Once the Docker Image has been pulled, you can bring up a network of your choosing by specifying the relevant network.

::

	docker-compose -f 3-NodeNetwork.yml up

This will laucnh three nodes within their own respective containers.

::
	
	CONTAINER ID        IMAGE                                      COMMAND             CREATED              STATUS              PORTS                                                                                                            NAMES
	7665c8ec6ee5        stratisgroupltd/blockchaincovid19:latest   "entrypoint.sh"     About a minute ago   Up About a minute   127.0.0.1:16177->16175/tcp, 127.0.0.1:16181->16179/tcp, 127.0.0.1:37225->37223/tcp, 127.0.0.1:38825->38823/tcp   node_3
	e2995b5aab02        stratisgroupltd/blockchaincovid19:latest   "entrypoint.sh"     About a minute ago   Up About a minute   127.0.0.1:16176->16175/tcp, 127.0.0.1:16180->16179/tcp, 127.0.0.1:37224->37223/tcp, 127.0.0.1:38824->38823/tcp   node_2
	838c6e11d33a        stratisgroupltd/blockchaincovid19:latest   "entrypoint.sh"     About a minute ago   Up About a minute   127.0.0.1:16175->16175/tcp, 127.0.0.1:16179->16179/tcp, 127.0.0.1:37223->37223/tcp, 127.0.0.1:38823->38823/tcp   node_1

*node_1* will mine the genesis block and the pre-mine will be credited to wallet of *node_1*. Each running node can be interacted with by connecting to the respestive Swagger interface for each node. 

The forwarded port from each container will be incremented by 1 in a numerical order. This is also evident when listing docker containers via the command line under the "Ports" header.

Interacting with the Network
============================

Once the network is running, you can interact with each node via RESTFul API that is presented by the node. The available endponints are `documented in Swagger <../../../Swagger/index.html>`_, you can use this Swagger interface to reference example request bodys and understand the required parameters for specific endpoints.