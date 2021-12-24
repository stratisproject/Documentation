################################
Interacting with the Cirrus Node
################################

The Cirrus Sidechain is the first Stratis Blockchain that supports Smart
Contract execution. Governed entirely by members of the Stratis
Community, presenting a required amount of collateral to secure their
position as a Masternode.

Interacting with the Cirrus Sidechain is no different to interacting
with the Stratis Full Node, however, there is a different and some
additional methods that can be utilised to leverage the additional
functionality presented through Smart Contract enablement.

The Cirrus Sidechain incorporates Stratis Smart Contract technology,
this enables Smart Contract deployment and interaction. There are
several endpoints available to interact with Smart Contracts. These
endpoints are documented and available via the Swagger interface,
accessible from the below URL.

   **CirrusTest**

   http://localhost:38223/Swagger

   **CirrusMain**

   http://localhost:37223/Swagger

This document will now progress to detail how an SRC20 Token can be
interacted with.

This document will progress with the assumption that a wallet has been
created as `detailed previously in this
document. <#creating-a-wallet>`__

Obtaining an SRC20 Token Balance
--------------------------------

An SRC20 Token balance can be achieved by utilising the
`*/api/SmartContracts/local-call*` endpoint.

::

	curl -X POST "http://localhost:37223/api/SmartContracts/local-call" -H "accept: application/json" -H "Content-Type: application/json-patch+json" -d '{\"contractAddress\":\"CUwkBGkXrQpMnZeWW2SpAv1Vu9zPvjWNFS\",\"methodName\":\"GetBalance\",\"amount\":\"0\",\"gasPrice\":100,\"gasLimit\":15000,\"sender\":\"CYgkKbebnkCdJ9y8MGcscQhuZEzRf7YgNJ\",\"parameters\":[\"9#CVZvejbiAHEeuZCaEJ4zPi1tCYne2CrHru\"]}'

Executing the above command, we are supplying several parameters,
highlighted below:

*The Token Contract to query.*

"**contractAddress**": "CUwkBGkXrQpMnZeWW2SpAv1Vu9zPvjWNFS"

*The name of the Method*

"**methodName**": "GetBalance"

*The amount of CRS Tokens (No CRS is required for this call)*

"**amount**": "0"

*The minimum GAS Price*

"**gasPrice**": 100

**GAS Prices must be set for the local-call, 100 is the lowest.**

*The maximum GAS to be spent*

"**gasLimit**": 15000

*The address that is making the call*

"**sender**": "CYgkKbebnkCdJ9y8MGcscQhuZEzRf7YgNJ"

*Additional parameters for the contract*

"**parameters**":

*9# defines the target address*

"**9#CVZvejbiAHEeuZCaEJ4zPi1tCYne2CrHru**"

The above example will provide a response like the below.

::

	{ 
		"internalTransfers": [],  
		"gasConsumed": {  
			"value": 10079  
		},  
		"revert": false,  
		"errorMessage": null,  
		"return": 289856038578246,  
		"logs": []  
	}

The important element of the above being the value of the return
property. The amount displayed is exclusive of a decimal point. The
value must be divided by 10^x, where x is the number of decimal places
of the token. Note: this value is for UI purposes only and is not
defined within the token contract itself. It must be obtained from the
issuer of a token.

In this case the decimal value is 8, meaning *289856038578246/
100000000* will present us with the correct balance of
**2,898,560.38578246.**

Transferring SRC20 Tokens
-------------------------

The transferring of SRC20 Coins/Tokens is very similar to the querying
of a balance, however, there are some subtle differences. For instance,
a CRS Token balance is required as any SRC20 Transfers will be
propagated and validated by the Masternodes operating the network.

The below command will interact with the api/SmartContractWallet/call
method to create an SRC20 Token Transfer.

::

	curl -X POST "http://localhost:37223/api/SmartContractWallet/call" -H "accept: application/json" -H "Content-Type: application/json-patch+json" -d '{\"walletName\":\"Cirrus\",\"contractAddress\":\"CYNs9kHdizj7Jde8KwAMivrucR3QLDszQh\",\"methodName\":\"TransferTo\",\"amount\":\"0\",\"feeAmount\":\"0.001\",\"password\":\"GettingStarted\",\"gasPrice\":100,\"gasLimit\":15000,\"sender\":\"CYgkKbebnkCdJ9y8MGcscQhuZEzRf7YgNJ\",\"parameters\":[\"9#CRw6gyKaH7RobsK7fE8ELbCrizzc5mk5u9\",\"7#1000000000\"]}'

Executing the above command, we are supplying several parameters,
highlighted below:

*The name of the wallet*

"**walletName**": "Cirrus"

*The address of the Token Contract*

"**contractAddress**": "CYNs9kHdizj7Jde8KwAMivrucR3QLDszQh"

*The name of the Method*

"**methodName**": "TransferTo"

*The amount of CRS Tokens (No CRS is required for this call)*

"**amount**": "0"

*The fee amount to fund the transaction*

"**feeAmount**": "0.001"

*The wallet password*

"**password**": "GettingStarted"

*The minimum GAS Price*

"**gasPrice**": 100

*The maximum GAS to be spent*

"**gasLimit**": 15000

*The address that is making the call*

"**sender**": "CYgkKbebnkCdJ9y8MGcscQhuZEzRf7YgNJ"

*Additional parameters for the contract*

"**parameters**":

*9# defines the target/receiving address*

"**9#CRw6gyKaH7RobsK7fE8ELbCrizzc5mk5u9**"

*7# defines the number of tokens to transfer, exclusive of any decimal
places. Eg. To send 1.2345 tokens, use the value 12345*

"**7#1000000000**"

The above example will provide a response like the below.

::

	{  
		"fee": 1600000,  
		"hex": "010000000159a5c521e781c142f3da54813d4209e43f18c589545526a3536a43fe34967134000000006a47304402202db7dddaeac08dd19b97864c1ede1c18ae807759d0b1ac52a30c2f43c8e8dddf0220629c65dd3676c784a4837d11bbac9f4f5f80b0132e81c287a50901508aa43ca101210350e4a26fd33b183d1121af583a1a3e272ded8b5e1e96f62ca730ebc09bc07570ffffffff0260de6105000000001976a914b1f088bb6e3416d517b1b1a6591dce470bb27f6488ac000000000000000057c1010000006400000000000000983a000000000000ae8ebf921da2261a624edd6a34c652d6ebd169e4ed8a5472616e73666572546fa1e0950967de7ad877bf83fe70cd312d84a133da060d9e38890700ca9a3b0000000000000000",  
		"message": "Your CALL method TransferTo transaction was successfully built.",  
		"success": true,  
		"transactionId": "738db2dbd8ce2d9299f88a4337a7205c232557533e1916bf68e064524786d07c"  
	}  

The important elements of the above being the value of the success
property and the transactionId parameter.

Propagation of the transaction can be confirmed by querying the
/api/SmartContracts/receipt endpoint with the transactionId provided in
the response from the token transfer.

::

		curl -X GET "http://localhost:37223/api/SmartContracts/receipt?txHash=738db2dbd8ce2d9299f88a4337a7205c232557533e1916bf68e064524786d07c" -H "accept: application/json"

The above will provide a response like the below.

::

	{  
		"transactionHash": "738db2dbd8ce2d9299f88a4337a7205c232557533e1916bf68e064524786d07c",  
		"blockHash": "cd82b55e782d00b5c4601d5753e7971fe5da85191bf9209f95fc0428e4420bf2",  
		"postState": "b87df59cef6dcf162b6cdc53270c2989f698d7ebf96f443505a19e9a8016aedd",  
		"gasUsed": 12680,  
		"from": "CYgkKbebnkCdJ9y8MGcscQhuZEzRf7YgNJ",  
		"to": "CYNs9kHdizj7Jde8KwAMivrucR3QLDszQh",  
		"newContractAddress": null,  
		"success": true,  
		"returnValue": "True",  
		"bloom": "00000200000000000000000000000000000000000000000000000000000000000000000000000000404000000000000000002000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000020000000000000000000000000000000000000000000080000000000000000000000000080000000000000000000000000000000000008400000000000000000000000000000",  
		"error": null,  
		"logs": [  
			{  
				"address": "CYNs9kHdizj7Jde8KwAMivrucR3QLDszQh",  
				"topics": [  
					"5472616E736665724C6F67",  
					"B1F088BB6E3416D517B1B1A6591DCE470BB27F64",  
					"67DE7AD877BF83FE70CD312D84A133DA060D9E38"  
				],  
				"data": "F394B1F088BB6E3416D517B1B1A6591DCE470BB27F649467DE7AD877BF83FE70CD312D84A133DA060D9E388800CA9A3B00000000",  
				"log": {  
					"from": "CYgkKbebnkCdJ9y8MGcscQhuZEzRf7YgNJ",  
					"to": "CRw6gyKaH7RobsK7fE8ELbCrizzc5mk5u9",  
					"amount": 1000000000  
				}  
			}  
		]  
	}

There are several key properties in the above response.

*The amount of GAS associated with the Smart Contract call*

"**gasUsed**": 12680

*The sender of the transfer*

"**from**": "CYgkKbebnkCdJ9y8MGcscQhuZEzRf7YgNJ"

*The Token Contract Address Note: Not the recipient*

"**to**": "CYNs9kHdizj7Jde8KwAMivrucR3QLDszQh"

*The status of the transaction*

"**success**": true

*The transaction log*

"**log**":

*The sender of Tokens*

"**from**": "CYgkKbebnkCdJ9y8MGcscQhuZEzRf7YgNJ"

*The recipient of Tokens*

“\ **to**": "CRw6gyKaH7RobsK7fE8ELbCrizzc5mk5u9"

*The amount of Tokens transferred, exclusive of any decimal places. E.g.
For 1.2345 tokens, this would be 12345*

"**amount**": 1000000000
