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

Persistent State
-------------------------------------
A contract's state is stored in a key/value store where both the key and the value are byte arrays. Access to the state is exposed to a contract through the ``PersistentState`` object. ``PersistentState`` can access the k/v store directly using byte arrays through the ``SetBytes`` method.

PersistentState also exposes methods which perform de/serialization before storing or retrieving a byte array. These methods are provided for **convenience only**. Internally, they use ``Stratis.SmartContract.Serializer`` to convert a value to its byte array representation before persisting or returning it.

The following are equivalent:

::

  PersistentState.SetUInt32(100_000);
  
and

::

  var serialized = Serializer.Serialize(100_000);
  PersistentState.SetBytes(serialized);


.. note:: 
  All methods except for ``GetBytes`` and ``SetBytes`` are convenience methods. It is **highly** important that you understand exactly how these work before using them. Pay particular attention to the default values returned when errors occur. To be certain what is happening in your code, perform the serialization yourself.

Serialization
~~~~~~~~~~~~~~~~~~~
Serialization of primitive types to byte arrays can be performed using the ``Serializer`` object exposed on ``Stratis.SmartContracts``. Serialization should always be successful, except when attempting to serialize a ``null`` reference type, which will return ``null``.

Deserialization
~~~~~~~~~~~~~~~~~~~
Deserialization can be thought of as a means to 'interpret' a byte array as a particular type. For example, the same byte array can be interpreted as an Int32 using ``Serializer.ToUInt32``, or as a string using ``Serializer.ToString``.

Interpreting a byte array as a particular type will not always be successful. A byte array that is 2 bytes long cannot be interpreted as an Int32 because an Int32 is a minimum of 4 bytes wide. When this occurs, the serializer will return a default object.

The table below outlines the behaviour when a byte array is interpreted unsuccessfully.

.. csv-table:: byte[] deserialization table
  :header: "Deserialization method", "Error Condition", "Return value"
  :escape: \

  ToBool, bytes == null || bytes.Length == 0, default(bool)
  ToAddress, bytes == null || bytes.Length != 20, Address.Zero
  ToInt32, bytes == null || bytes.Length < 4, default(int)
  ToUInt32, bytes == null || bytes.Length < 4, default(uint)
  ToInt64, bytes == null || bytes.Length < 8, default(int)
  ToUInt64, bytes == null || bytes.Length < 8, default(uint)
  ToString, bytes == null || bytes.Length < sizeof(char), string.Empty
  ToChar, bytes == null || bytes.Length < sizeof(char), default(char)
  ToArray<T>, bytes == null || bytes.Length == 0, T[0]
  ToStruct<T>, bytes == null || bytes.Length == 0, default(T)  

Deserializing a Base58 Address
~~~~~~~~~~~~~~~~~~~
The serializer contains a special case, ``Serializer.ToAddress(string val)`` which will attempt to interpret a string as a base58 encoded address. If the string is ``null``, empty, or not a valid base58 address, then ``Address.Zero`` is returned.
