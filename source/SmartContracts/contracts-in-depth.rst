###############################
Smart Contracts In-Depth
###############################

Introduction
-------------------------------------
This document provides an in-depth examination of C# smart contracts on the Stratis platform.

Compiled contract assembly
-------------------------------------
All Stratis CIL contracts must be deployed as `assemblies <https://docs.microsoft.com/en-us/dotnet/api/system.reflection.assembly>`_ which contain one or more `Types <https://docs.microsoft.com/en-us/dotnet/api/system.type>`_.

A contract maps one-to-one with a type in the assembly. Multiple types are allowed in an assembly, but this requires that a primary type is denoted with ``[Deploy]``. If multiple types are present, only the primary type will be deployed in a contract creation transaction. During execution, the primary type has access to the other types defined in an assembly and can use these to deploy new contracts.

Contracts exist as object instances in the dotnet runtime. Conceptually, they can be thought of as singletons with an infinite lifetime. CREATE transactions invoke the type's constructor to create an instance of the type. On deployment, each contract is assigned an address, which can be thought of as a reference to the object instance. CALL transactions invoke methods on the instance and are the means of interacting with a contract.

Unlike a .NET object, a contract's state is not stored in fields on the object. Instead, it must be explicitly accessed using the ``PersistentState`` object exposed on the ``Stratis.SmartContracts`` base class.

The Stratis.SmartContract object
-------------------------------------
All contracts must inherit from the ``Stratis.SmartContract`` type, which exposes methods useful to the contract. Contracts must contain a single constructor whose first parameter is an ``ISmartContractState`` object. The ``ISmartContractState`` object is injected at runtime and provides the current state and services used within a contract.

.. csv-table:: Stratis.SmartContract base class methods
  :header: "Method Name", "Description"
  :escape: \

  Address, The address of this contract
  Balance, The balance of this contract
  Block, The current block height and coinbase
  Message, The current contract's address\, sender\, and value
  PersistentState, Access to the contract's key/value store
  Serializer, Access to serialization methods
  Transfer, Used to send funds to an address
  Call, Used to call a method on another contract
  Create<T>, Used to create a new contract of type ``T`` from the current contract's assembly
  Keccak256, Used to keccak256 hash a byte array
  Assert, Used to halt execution if a condition is false
  Log<T>, Used to log an event of type T
  Receive, Used to apply processing incoming funds

Example
~~~~~~~~~~~~~~~~~~~

The contract below represents a simple use case of storing a value provided on contract creation.

::

  public class Contract : SmartContract
  {
    public Contract(ISmartContractState state, ulong value)
    {
      this.PersistentState.SetUInt64("value", value);
    }
  }

The lifecycle of the contract creation is:

* Constructor called with ``IPersistentState`` object injected and constructor params injected
* ``PersistentState`` called and state database updated with ``value``
