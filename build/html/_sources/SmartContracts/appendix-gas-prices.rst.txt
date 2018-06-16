###############################
Appendix - Gas Prices
###############################

Smart contract execution costs the gas price (in satoshis) multiplied by the gas used. The gas price and the maximum amount of gas to be used are set at the transaction level.

* **Gas Price:** Minimum: 1. Maximum: 10000.
* **Gas Limit:** Minimum: 1000. Maximum: 5000000.

**For most transactions, we would recommend setting your gas price to 1 and the gas limit to 100000.**

.. note::
  The gas costs below are subject to change but we expect that the total cost for interacting with or creating smart contracts should not exceed ~$5 USD.

.. csv-table:: Gas Costs
  :header: "Operation", "Cost", "Description"

  Base Cost, 1000, The cost for executing any smart contract transaction.
  Contract Creation Cost, 1000, The cost for creating a new smart contract.
  Instruction Cost, 1, The cost for executing each CIL instruction.
  System Method Call Cost, 5, The cost for calling any system method.
  Storage Cost (byte), 10, The cost for storing 1 byte via PersistentState. This currently includes both keys and values, every time a value is set.

.. note::
  Base cost and contract creation cost are affected by changes in the gas price too. For example, if the gas price is set to 2, the base cost and contract creation cost rise to 2000. System method calls always remain free.
