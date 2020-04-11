###############################
The Auction Smart Contract
###############################

This chapter takes a further look at the smart contract-specific parts of an Auction C# class. You can check out the complete source `here <https://github.com/stratisproject/StratisSmartContractsSamples/blob/master/src/Stratis.SmartContracts.Samples/Stratis.SmartContracts.Samples/Auction.cs>`_

::

  using Stratis.SmartContracts;

  public class Auction : SmartContract

The first line in the contract is a reference to the ``Stratis.SmartContracts`` NuGet package. This package allows you to inherit from the ``SmartContract`` class and thereby provides subclasses with useful functionality such as sending funds, hashing, and saving data. You can create smart contracts just by including the ``Stratis.SmartContracts`` NuGet package in your project and inheriting from ``SmartContract``.

The only libraries that can be included in the current iteration of Stratis smart contracts are ``System``, ``System.Linq`` and ``Stratis.SmartContracts``.

::

  public Address Owner
  {
    get
    {
        return PersistentState.GetObject<Address>("Owner");
    }
    private set
    {
        PersistentState.SetObject<Address>("Owner", value);
    }
  }

The Auction object has several properties which are structured in a similar way to the Owner property. To persist data in a smart contract, use ``PersistentState``. Data can be persisted anywhere in the smart contract not just inside a property. However, persisting data inside properties makes the code inside your methods easier to read.

The ``Address`` class is included as part of ``Stratis.SmartContracts``. It is an abstraction over a series of strings that enables funds to be sent to addresses.

::

    public ulong GetBalance(Address address)
    {
        return this.PersistentState.GetUInt64($"Balances[{address}]");
    }

    private void SetBalance(Address address, ulong balance)
    {
        this.PersistentState.SetUInt64($"Balances[{address}]", balance);
    }

The above methods emulate a dictionary-like structure for storage. Using a standard .NET dictionary would require serializing and deserializing all the dictionary data every time it was updated. For dictionaries with thousands of entries (think balances of a token contract), this would require a significant amount of processing. These methods instead store individual items in the underlying key/value store.


::

  public Auction(ISmartContractState smartContractState, ulong durationBlocks)
   : base(smartContractState)
   {
       Owner = Message.Sender;
       EndBlock = Block.Number + durationBlocks;
       HasEnded = false;
   }

The contract constructor gets run when the contract is created for the first time. Contracts must override the base class constructor and inject ``ISmartContractState``, which must be the first parameter of the constructor. Other parameters should be positioned after this parameter.

The ``Message`` and ``Block`` objects are read-only properties on the ``SmartContract`` class which the Auction class inherits from. These properties provide access to information about the current context that a contract call is executing in. For example: block numbers, the address that called the contract, etc.

Assigning a value to ``Owner``, ``EndBlock``, and ``HasEnded`` saves the values in ``PersistentState`` via their property setters. Setting ``Owner`` is a very common pattern when developing smart contracts and gives extra functionality to the creator of the contract. You will notice that in the ``AuctionEnd`` method, funds are sent to ``Owner``.

The ``Assert`` method, inherited from ``SmartContract``, provides a simple way to reject contract executions that don't meet certain criteria. In this case, we're using it to reject any further execution when the message sender doesn't have a balance in our contract.

The ``Transfer`` method, also inherited from ``SmartContract``, enables the sending of funds to a specific address. This will send funds to ordinary addresses or contracts. A third parameter can be specified as input for this method to give more information about the method etc. to call on a contract.

::

  public bool Withdraw()
  {
      ulong amount = GetBalance(this.Message.Sender);
      Assert(amount > 0);
      SetBalance(this.Message.Sender, 0);
      ITransferResult transferResult = Transfer(this.Message.Sender, amount);
      if (!transferResult.Success)
          this.SetBalance(this.Message.Sender, amount);
      return transferResult.Success;
  }

There are a few more methods in the ``Auction`` class, but the final method to look at is ``Withdraw``. This method checks whether the caller has a balance to withdraw from. If they do, this balance will be deducted from the smart contract state and they will be sent the funds.


.. note::
  You may be wondering why there is a ``Withdraw`` method at all. Why not just transfer the funds to their owner as soon as they become available? The reason is because the owner of these funds could be another smart contract that cannot be controlled. Sending the funds back to such a contract would potentially call unknown code using another user's funds. Therefore, the ``Withdraw`` pattern is very common in smart contracts. If users call a contract, that contract execution should never execute an untrusted smart contract's code.