#########################################
Appendix - Gas Prices and Memory Limit
#########################################

Gas Pricing
-------------------------------------

Smart contract execution costs the gas price (in satoshis) multiplied by the gas used. The gas price and the maximum amount of gas to be used are set at the transaction level.

* **Gas Price:** Minimum: 100. Maximum: 10000.
* **Gas Limit:** Minimum: 10000 for calling a contract. 12000 for creating a contract. Maximum: 250000.

.. note::
    For most transactions, we would recommend setting your gas price to 100 and the gas limit to 50000.

.. csv-table:: Gas Costs
  :escape: \
  :header: "Operation", "Cost", "Description"

  Base CALL, 10000, The cost for executing a smart contract method.
  Base CREATE, 12000, The cost for creating a new smart contract.
  Instruction, 1, The cost for executing any one CIL instruction.
  System Method Call, 5, The cost for calling any system method.
  Storage (byte), 20, The cost for storing 1 byte via PersistentState. This currently includes both keys and values\, every time a value is set.
  Storage Retrieval (byte), 1, The cost for retrieving 1 byte from PersistentState. 
  Contract Exists, 5, The cost to check if a contract exists at the given address.
  Log Indexed Data (byte), 2, The cost when logging indexed data.
  Log Unindexed Data (byte), 1, The cost when logging data that isn't indexed. 


Memory Limit
-------------------------------------

Contract execution has a limit on how many objects can be created and held in memory. Certain operations contribute to a "memory unit" counter which will trigger an exception if it exceeds 250000.

.. csv-table:: Memory consuming operations
  :header: "Method", "Description"

  Array constructor, Consumes 1 unit for every item in the array.
  Array.Resize, Consumes 1 unit for every item in the array.
  string.ToCharArray, Consumes 1 unit for every item output in the array.
  string.Split, Consumes 1 unit for every item output in the resulting array.
  string.Concat, Consumes 1 unit for every char in the resulting string.
  string.Join, Consumes 1 unit for every char in the resulting string.
  String constructor, Only for the constructor that takes an int as a parameter. Consumes that int in memory units.