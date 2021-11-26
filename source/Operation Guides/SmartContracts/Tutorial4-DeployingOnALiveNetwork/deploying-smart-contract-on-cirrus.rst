*************************************
Deploying a Smart Contract on Mainnet
*************************************
This tutorial details the process of deploying a Smart Contract in C# on the CirrusMain Sidechain. Dependant on the contract you are wishing to deploy, there may be additional steps required, this tutorial will focus on the deployment of a new Stratis Smart Contract and the steps required to have your contract deployed and executable on the Cirrus Sidechain.

Unlike other blockchain platforms, there is a level of auditing and review that is required by the public prior to the acceptance of a Smart Contract on the Cirrus Sidechain. This is achieved by whitelisting a hash of the developed contract, allowing for the validation of contracts that have been voted in approval.


Development of a Smart Contract in C#
==========================================
The process begins by developing a Smart Contract that you want to deploy and utilize. For this example, the Standard Token Issuance contract will be utilized.

This contract has been designed to replicate the functionality offered by the ERC20 Token Contract.


::

	using Stratis.SmartContracts;
	using Stratis.SmartContracts.Standards;

	/// <summary>
	/// Implementation of a standard token contract for the Stratis Platform.
	/// </summary>
	public class StandardToken : SmartContract, IStandardToken
	{
		/// <summary>
		/// Constructor used to create a new instance of the token. Assigns the total token supply to the creator of the contract.
		/// </summary>
		/// <param name="smartContractState">The execution state for the contract.</param>
		/// <param name="totalSupply">The total token supply.</param>
		/// <param name="name">The name of the token.</param>
		/// <param name="symbol">The symbol used to identify the token.</param>
		public StandardToken(ISmartContractState smartContractState, ulong totalSupply, string name, string symbol)
			: base(smartContractState)
		{
			this.TotalSupply = totalSupply;
			this.Name = name;
			this.Symbol = symbol;
			this.SetBalance(Message.Sender, totalSupply);
		}

		public string Symbol
		{
			get => PersistentState.GetString(nameof(this.Symbol));
			private set => PersistentState.SetString(nameof(this.Symbol), value);
		}

		public string Name
		{
			get => PersistentState.GetString(nameof(this.Name));
			private set => PersistentState.SetString(nameof(this.Name), value);
		}

		/// <inheritdoc />
		public ulong TotalSupply
		{
			get => PersistentState.GetUInt64(nameof(this.TotalSupply));
			private set => PersistentState.SetUInt64(nameof(this.TotalSupply), value);
		}

		/// <inheritdoc />
		public ulong GetBalance(Address address)
		{
			return PersistentState.GetUInt64($"Balance:{address}");
		}

		private void SetBalance(Address address, ulong value)
		{
			PersistentState.SetUInt64($"Balance:{address}", value);
		}

		/// <inheritdoc />
		public bool TransferTo(Address to, ulong amount)
		{
			if (amount == 0)
			{
				Log(new TransferLog { From = Message.Sender, To = to, Amount = 0 });

				return true;
			}

			ulong senderBalance = GetBalance(Message.Sender);

			if (senderBalance < amount)
			{
				return false;
			}

			SetBalance(Message.Sender, senderBalance - amount);

			SetBalance(to, checked(GetBalance(to) + amount));

			Log(new TransferLog { From = Message.Sender, To = to, Amount = amount });

			return true;
		}

		/// <inheritdoc />
		public bool TransferFrom(Address from, Address to, ulong amount)
		{
			if (amount == 0)
			{
				Log(new TransferLog { From = from, To = to, Amount = 0 });

				return true;
			}

			ulong senderAllowance = Allowance(from, Message.Sender);
			ulong fromBalance = GetBalance(from);

			if (senderAllowance < amount || fromBalance < amount)
			{
				return false;
			}

			SetApproval(from, Message.Sender, senderAllowance - amount);

			SetBalance(from, fromBalance - amount);

			SetBalance(to, checked(GetBalance(to) + amount));

			Log(new TransferLog { From = from, To = to, Amount = amount });

			return true;
		}

		/// <inheritdoc />
		public bool Approve(Address spender, ulong currentAmount, ulong amount)
		{
			if (Allowance(Message.Sender, spender) != currentAmount)
			{
				return false;
			}

			SetApproval(Message.Sender, spender, amount);

			Log(new ApprovalLog { Owner = Message.Sender, Spender = spender, Amount = amount, OldAmount = currentAmount });

			return true;
		}

		private void SetApproval(Address owner, Address spender, ulong value)
		{
			PersistentState.SetUInt64($"Allowance:{owner}:{spender}", value);
		}

		/// <inheritdoc />
		public ulong Allowance(Address owner, Address spender)
		{
			return PersistentState.GetUInt64($"Allowance:{owner}:{spender}");
		}

		public struct TransferLog
		{
			[Index]
			public Address From;

			[Index]
			public Address To;

			public ulong Amount;
		}

		public struct ApprovalLog
		{
			[Index]
			public Address Owner;

			[Index]
			public Address Spender;

			public ulong OldAmount;

			public ulong Amount;
		}
	}

Best Practice Guidelines
------------------------
Stratis has no control as to what is whitelisted and what is not. Smart Contract developers should follow accepted best practices when writing new smart contracts. Some guidelines include:

1. Use properties to store and retrieve data, with nameof(Property) as the PersistentState key.
2. Ensure methods are only public when intended – especially property setters.
3. Validate methods fail early with Asserts.
4. Check the inside of the Asserts are logically correct.
5. Check for possible integer overflows. By default, contracts are compiled with overflow checking enabled which will throw an exception if this occurs. If overflows are desired, explicitly specify this using an unchecked block.
6. Decide whether you want your contract to accept the CRS Token sent from other contracts.  If so, and your contract needs to do any extra accounting, be sure to override SmartContract’s Receive method.
7. Generally, avoid loops and always avoid unbounded loops where the input of dynamic data could cause OutOfGas exceptions or other problems.
8. Be aware of truncation when using integer division.
9. Validate the result of transfers, sends or calls into other contracts - If they aren’t successful, you may not want to be updating the state of the contract being worked on.
10. Perform any updates to the contract’s state after transfers to other addresses has occurred. This avoids re-entrance attacks.
11. In general, make funds transfers in individual calls and require users to “pull” their CRS Token, rather than trying to push the funds as part of a wider method. This prevents malicious actors from denying payment to groups of users.
12. Write unit tests using a mocking framework like `Moq  <https://github.com/Moq/moq4/wiki/Quickstart>`_ or `NSubstitute <https://nsubstitute.github.io/help/getting-started/>`_. Use these to mock the properties on ISmartContractState and verify that the correct sequence of calls occur.

Testing with Moq and XUnit
--------------------------
The example below illustrates the key portions of testing your smart contract using Moq and XUnit.

First, we must create our test project and a test class. For this contract we'll name it StandardTokenTests. We'll define some private properties that hold common values that tests will use frequently and in the constructor of the class, set those values.

The first three properties have types of Mock<T> where we are defining properties that will hold mocks of the different Interfaces we will need in our tests. Then we'll use the Setup method on mockContractState to set instances of the mocks we've created.
There are other Interfaces than can and should be mocked when used such as:

• IInternalHashHelper
• IInternalTransactionExecutor
• IMessage
• ISerializer

::

    public class StandardTokenTests
        {
            private readonly Mock<ISmartContractState> mockContractState;
            private readonly Mock<IPersistentState> mockPersistentState;
            private readonly Mock<IContractLogger> mockContractLogger;
            private Address owner;
            private Address sender;
            private Address contract;
            private Address spender;
            private Address destination;
            private string name;
            private string symbol;

            public StandardTokenTests()
            {
                this.mockContractLogger = new Mock<IContractLogger>();
                this.mockPersistentState = new Mock<IPersistentState>();
                this.mockContractState = new Mock<ISmartContractState>();
                this.mockContractState.Setup(s => s.PersistentState).Returns(this.mockPersistentState.Object);
                this.mockContractState.Setup(s => s.ContractLogger).Returns(this.mockContractLogger.Object);
                this.owner = "0x0000000000000000000000000000000000000001".HexToAddress();
                this.sender = "0x0000000000000000000000000000000000000002".HexToAddress();
                this.contract = "0x0000000000000000000000000000000000000003".HexToAddress();
                this.spender = "0x0000000000000000000000000000000000000004".HexToAddress();
                this.destination = "0x0000000000000000000000000000000000000005".HexToAddress();
                this.name = "Test Token";
                this.symbol = "TST";
            }
        }
    }

Now that the test class is setup and the constructor has set the properties you can begin writing your tests. See examples below or visit the full
`StandardTokenTests.cs file  <https://github.com/stratisproject/CirrusSmartContracts/blob/master/Testnet/StandardToken/StandardToken.Tests/StandardTokenTests.cs>`_
on Github.

.. note::
    For contract acceptance and whitelisting, it is important to test all successful and failing scenarios that come to mind. Smart contracts are immutable, once the hash is whitelisted or a contract is deployed, it cannot be modified.

**Ensure Constructor Sets the Total Supply**

::

    [Fact]
    public void Constructor_Sets_TotalSupply()
    {
        ulong totalSupply = 100_000;

        // Set the message that would act as the initial transaction to the contract.
        this.mockContractState.Setup(m => m.Message).Returns(new Message(this.contract, this.owner, 0));

        // Create a new instance of the smart contract class.
        var standardToken = new StandardToken(this.mockContractState.Object, totalSupply, this.name, this.symbol);

        // Verify that PersistentState was called with the total supply
        this.mockPersistentState.Verify(s => s.SetUInt64(nameof(StandardToken.TotalSupply), totalSupply));
    }

**Ensure TransferTo Full Balance Returns True**

::

    [Fact]
    public void TransferTo_Full_Balance_Returns_True()
    {
        ulong balance = 10000;
        ulong amount = balance;
        ulong destinationBalance = 123;

        // Setup the Message.Sender address
        this.mockContractState.Setup(m => m.Message)
            .Returns(new Message(this.contract, this.sender, 0));

        var standardToken = new StandardToken(this.mockContractState.Object, 100_000, this.name, this.symbol);

        // Setup the balance of the sender's address in persistent state
        this.mockPersistentState.Setup(s => s.GetUInt64($"Balance:{this.sender}")).Returns(balance);

        // Setup the balance of the recipient's address in persistent state
        this.mockPersistentState.Setup(s => s.GetUInt64($"Balance:{this.destination}")).Returns(destinationBalance);

        Assert.True(standardToken.TransferTo(this.destination, amount));

        // Verify we queried the balance
        this.mockPersistentState.Verify(s => s.GetUInt64($"Balance:{this.sender}"));

        // Verify we set the sender's balance
        this.mockPersistentState.Verify(s => s.SetUInt64($"Balance:{this.sender}", balance - amount));

        // Verify we set the receiver's balance
        this.mockPersistentState.Verify(s => s.SetUInt64($"Balance:{this.destination}", destinationBalance + amount));
    }

**Ensure TransferFrom Greater Than Owners Balance Returns False**

::

    [Fact]
    public void TransferFrom_Greater_Than_Owners_Balance_Returns_False()
    {
        ulong balance = 0; // Balance should be less than amount we are trying to send
        ulong amount = balance + 1;
        ulong allowance = amount + 1; // Allowance should be more than amount we are trying to send

        // Setup the Message.Sender address
        this.mockContractState.Setup(m => m.Message)
            .Returns(new Message(this.contract, this.sender, 0));

        var standardToken = new StandardToken(this.mockContractState.Object, 100_000, this.name, this.symbol);

        // Setup the balance of the owner in persistent state
        this.mockPersistentState.Setup(s => s.GetUInt64($"Balance:{this.owner}")).Returns(balance);

        // Setup the allowance of the sender in persistent state
        this.mockPersistentState.Setup(s => s.GetUInt64($"Allowance:{this.owner}:{this.sender}")).Returns(allowance);

        Assert.False(standardToken.TransferFrom(this.owner, this.destination, amount));

        // Verify we queried the sender's allowance
        this.mockPersistentState.Verify(s => s.GetUInt64($"Allowance:{this.owner}:{this.sender}"));

        // Verify we queried the owner's balance
        this.mockPersistentState.Verify(s => s.GetUInt64($"Balance:{this.owner}"));
    }

Generate Contract Hash
----------------------
To obtain a hash of a contract, you will need to run the Stratis Smart Contracts Test Tool to validate and compile the contract.

1. Clone the Stratis.SmartContracts.Tools.SCT Repository

::

 git clone https://github.com/stratisproject/Stratis.SmartContracts.Tools.Sct.git

2. Navigate to the Stratis Smart Contract Tools project directory

::

 cd Stratis.SmartContracts.Tools.Sct\Stratis.SmartContracts.Tools.Sct

3. Pass the path to the developed contract as a parameter. (In this example, the SRC20 Token Issuance contract is referenced)

::

 dotnet run -- validate C:\CirrusSmartContracts\Mainnet\StandardToken\StandardToken\StandardToken.cs -sb

4. The output from the above will provide you with both a hash and the byte code of the given contract.

::

 Hash
 9caf44c6c3e0e6d200fdf57e42a489731a77ae31b3cab18074f80e90960b4252

 ByteCode
 4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C010200E1F046E10000000000000000E00022200B013000000E00000002000000000000522C0000002000000040000000000010002000000002000004000000000000000400000000000000006000000002000000000000030040850000100000100000000010000010000000000000100000000000000000000000002C00004F000000000000000000000000000000000000000000000000000000004000000C000000E42B00001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E74657874000000580C000000200000000E000000020000000000000000000000000000200000602E72656C6F6300000C000000004000000002000000100000000000000000000000000000400000420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000342C000000000000480000000200050050230000940800000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000C20203280500000A0204280700000602052805000006020E0428030000060202280600000A6F0700000A0428090000062A4602280800000A72010000706F0900000A2A4A02280800000A7201000070036F0A00000A2A4602280800000A720F0000706F0900000A2A4A02280800000A720F000070036F0A00000A2A4602280800000A72190000706F0B00000A2A4A02280800000A7219000070036F0C00000A2A7202280800000A7231000070038C08000001280D00000A6F0B00000A2A7602280800000A7231000070038C08000001280D00000A046F0C00000A2A0013300400A600000001000011042D34021201FE1503000002120102280600000A6F0700000A7D010000041201037D020000041201166A7D0300000407280100002B172A0202280600000A6F0700000A28080000060A06043402162A0202280600000A6F0700000A0604DB280900000602030203280800000604D72809000006021201FE1503000002120102280600000A6F0700000A7D010000041201037D020000041201047D0300000407280100002B172A000013300500AA00000002000011052D2A021202FE15030000021202037D010000041202047D020000041202166A7D0300000408280100002B172A020302280600000A6F0700000A280E0000060A020328080000060B0605370407053402162A020302280600000A6F0700000A0605DB280D00000602030705DB280900000602040204280800000605D72809000006021202FE15030000021202037D010000041202047D020000041202057D0300000408280100002B172A00001330040065000000030000110202280600000A6F0700000A03280E000006042E02162A0202280600000A6F0700000A0305280D000006021200FE1504000002120002280600000A6F0700000A7D040000041200037D050000041200057D070000041200047D0600000406280200002B172A8E02280800000A7249000070038C08000001048C08000001280F00000A056F0C00000A2A8A02280800000A7249000070038C08000001048C08000001280F00000A6F0B00000A2A42534A4201000100000000000C00000076342E302E33303331390000000005006C00000098030000237E0000040400000403000023537472696E67730000000008070000700000002355530078070000100000002347554944000000880700000C01000023426C6F6200000000000000020000015717A201090A000000FA013300160000010000000E00000004000000070000000E00000017000000010000000F00000007000000030000000100000003000000060000000100000003000000020000000200000000007E010100000000000600EB00440206001A0144020600D70010020F00640200000A00A10283020E00C60123020A008B0083020A007302830206008100AD010A000B0183020A00550083020A00B200830206005301AD010600AF02AD01000000001500000000000100010001001000C70100001500010001000A01100066010000250001000F000A0110005A010000250004000F000600BC0174000600DD0174000600C70278000600FE0174000600EE0174000600B60278000600C702780050200000000086180A027B000100812000000000860890018400050093200000000081089B0188000500A6200000000086086A0084000600B820000000008108730088000600CB2000000000E609D5028D000700DD20000000008108E50291000700F02000000000E6013500960008000D2100000000810040009C0009002C2100000000E601D501A3000B00E02100000000E601B401AA000D00982200000000E6013E01B300100009230000000081007201BB0013002D2300000000E6014B00C4001600000001009F0000000200F502000003007C0000000400A601000001003801000001003801000001003801000001007B02000001007B0200000200380100000100E00100000200CE0200000100C10100000200E00100000300CE0200000100F60100000200C00200000300CE0200000100040200000200F60100000300380100000100040200000200F6010200190009000A02010011000A02060019000A020A0051000A02060029000A02100029005E0016005900E3011B002900C3002000610046012500610050012A0061000100300061000B00350069009A023B0029006E01470069009A0264002100230005012E000B00D4002E001300DD002E001B00FC00410023000501810023000501A10023000501410053005A000200010000009F01CC0000007700CC000000E902D000020002000300010003000300020004000500010005000500020006000700010007000700048000000000000000000000000000000000A10200000400000000000000000000006B001E00000000000100020001000000000000000000830200000000010000000000000000000000000023020000000003000200040002001D004E001D005F00000000000047657455496E7436340053657455496E743634003C4D6F64756C653E0053797374656D2E507269766174652E436F72654C69620047657442616C616E63650053657442616C616E636500416C6C6F77616E636500494D657373616765006765745F4D657373616765006765745F4E616D65007365745F4E616D65006E616D650056616C7565547970650049536D617274436F6E7472616374537461746500736D617274436F6E74726163745374617465004950657273697374656E745374617465006765745F50657273697374656E7453746174650044656275676761626C6541747472696275746500436F6D70696C6174696F6E52656C61786174696F6E7341747472696275746500496E6465784174747269627574650052756E74696D65436F6D7061746962696C6974794174747269627574650076616C756500417070726F766500476574537472696E6700536574537472696E6700417070726F76616C4C6F67005472616E736665724C6F6700536574417070726F76616C00536D617274436F6E74726163742E646C6C006765745F53796D626F6C007365745F53796D626F6C0073796D626F6C0053797374656D005472616E7366657246726F6D0066726F6D00495374616E64617264546F6B656E005472616E73666572546F00746F006765745F53656E646572005370656E646572007370656E646572004F776E6572006F776E6572002E63746F720053797374656D2E446961676E6F737469637300537472617469732E536D617274436F6E7472616374732E5374616E64617264730053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300446562756767696E674D6F6465730041646472657373006164647265737300537472617469732E536D617274436F6E74726163747300466F726D617400536D617274436F6E7472616374004F626A656374004F6C64416D6F756E740063757272656E74416D6F756E7400616D6F756E74006765745F546F74616C537570706C79007365745F546F74616C537570706C7900746F74616C537570706C7900000000000D530079006D0062006F006C0000094E0061006D006500001754006F00740061006C0053007500700070006C0079000017420061006C0061006E00630065003A007B0030007D00002341006C006C006F00770061006E00630065003A007B0030007D003A007B0031007D0000000000F5148117F9C6F840A461EEE65ADF72F40004200101080320000105200101111105200101121D042000122D042000112104200012310420010E0E052002010E0E0420010B0E052002010E0B0500020E0E1C0507020B110C06300101011E00040A01110C0607030B0B110C0407011110040A0111100600030E0E1C1C087CEC85D7BEA7798E0306112102060B08200401121D0B0E0E0320000E042001010E0320000B042001010B0520010B11210620020111210B0620020211210B08200302112111210B0720030211210B0B08200301112111210B0720020B112111210328000E0328000B0801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F7773010801000200000000000401000000000000000000000000000000000010000000000000000000000000000000282C00000000000000000000422C0000002000000000000000000000000000000000000000000000342C0000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF250020001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000C000000543C00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

Submitting a Smart Contract for review
==========================================
In order for the newly developed Smart Contract to be deployable and executable on the Cirrus Sidechain, a review process needs to take place. The hash of the byte code needs to be accepted by the Sidechain Masternodes that produce blocks on the sidechain.

A Pull Request must be raised against the CirrusSmartContracts repository under the StratisProject organization. A link to the repository can be found below.

`https://github.com/stratisproject/CirrusSmartContracts <https://github.com/stratisproject/CirrusSmartContracts>`_

The Pull Request will need to conform to a template to provide a level of standardization for Sidechain Masternode operators and developers that may review the pull request.

An example can be found below.

.. image:: PR.png
     :width: 900px
     :alt: PR Example
     :align: center

The Pull Request will need to contain a section for each of the below.

• Description
• Compiler
• Hash
• ByteCode


Smart Contract Review
---------------------
A member of the Stratis Development Team and/or .NET Developers will provide comment on your pull request relating to the Smart Contract that has been developed.

These comments can range from advice to suggested changes to improve or validate the functionality of the Smart Contract.
Comments provided on the pull request should remain constructive and relating to the contract itself, an example of a community developers comments can be found below.

.. image:: PR-Review.png
     :width: 900px
     :alt: PR Review
     :align: center

Where applicable recommendations should be taken into consideration or discussed on the pull request.


Acquiring the CRS Token
=======================
Whilst your Smart Contract has been fully developed, it cannot be deployed until it had been voted in by the Sidechain Masternode Operators. Once the Smart Contract hash has been whitelisted by the Sidechain Masternode Operators, the Pull Request will be merged to the repository. This highlights that the contract is available to be deployed by anyone on the Cirrus Sidechain.

Deploying the contract can be done from within the Cirrus Core wallet. The wallet can be downloaded and installed from the below release page.

`https://github.com/stratisproject/StratisCore/releases <https://github.com/stratisproject/StratisCore/releases>`_


Once you have installed Cirrus Core, you will need to run it either on testnet or mainnet. As this document refers to the StratisTest (TestNet) network, you will need to run the
wallet in testnet.

| **On Windows**
| From the command line run the following command:

::

    start "" "C:\\Program Files\Cirrus Core\Cirrus Core.exe" -testnet

| **On Mac**
| Open ScriptEditor to create a new applescript document and insert the following script:

::

    do shell script "open /Applications/Cirrus\\ Core.app --args -testnet"

Save the script in the Applications folder with the name of CirrusCoreTest.app and make sure to save it as an application type.

Once you have Cirrus Core running on testnet, you will need to follow the prompted steps to create a wallet, once this wallet has been created, you will be able to generate addresses that derive from the newly created wallet.

.. image:: CirrusAddress.png
     :width: 900px
     :alt: Cirrus Address
     :align: center

The Cirrus Token is required to deploy a Smart Contract, the amount is wholly dependant on the computational cost defined by the complexity of the Smart Contract.

Initially you will need to obtain a minimum of 1 STRAX and have it available within the Stratis Core wallet. The Stratis Core wallet can be downloaded and installed from the below release page.

`https://github.com/stratisproject/StratisCore/releases
<https://github.com/stratisproject/StratisCore/releases>`_

Once you have installed Stratis Core, you will need to run it either on testnet or mainnet. As this document refers to the StratisTest (TestNet) network, you will need to run the
wallet in testnet.

| **On Windows**
| From the command line run the following command:

::

    start "" "C:\\Program Files\Stratis Core\Stratis Core.exe" -testnet

| **On Mac**
| Open ScriptEditor to create a new applescript document and insert the following script:

::

    do shell script "open /Applications/Stratis\\ Core.app --args -testnet"

Save the script in the Applications folder with the name of StratisCoreTest.app and make sure to save it as an application type.


Once you have Stratis Core running on testnet, you will need to follow the prompted steps to create a wallet, once this wallet has been created, send a minimum of 1 STRAX to an address generated from the newly created wallet.

.. image:: StratisCore.png
     :width: 900px
     :alt: Stratis Core Dashboard
     :align: center

Once the balance is confirmed, you will need to perform a cross-chain transfer to the Cirrus Sidechain.

.. image:: StratisCore-Send.png
     :width: 900px
     :alt: Stratis Core Send
     :align: center

As this document refers to the StratisTest (TestNet) network, the StratisTest and CirrusTest federation addresses are being utilized.

Federation detail for both test environments and production environments can be found below:

| **Production Environment**
| **Stratis Federation Address:** sg3WNvfWFxLJXXPYsvhGDdzpc9bT4uRQsN
| **Cirrus Federation Address:** cnYBwudqzHBtGVELyQNUGzviKV4Ym3yiEo

| **Test Environment**
| **Stratis Federation Address:** 2N1wrNv5NDayLrKuph9YDVk8Fip8Wr8F8nX
| **Cirrus Federation Address:** xH1GHWVNKwdebkgiFPtQtM4qb3vrvNX2Rg

The exchange of STRAX for CRS is known as a Cross-Chain Transfer. Each Cross-Chain Transfer will subject to an exchange fee of 0.001, meaning if you perform a Cross-Chain Transfer of 1 STRAX you will receive 0.999 CRS Tokens.

A Cross-Chain Transfer is also subject to a larger amount of confirmations, this is to cater for any reorganisations on the network and invalid credits being made on either chain. The confirmation times can be seen below.

**STRAX to CRS:** 500 Blocks (64 Second Block Time x 500 Blocks = 32000 Seconds ÷ 60 = 533 Minutes ÷ 60 = 8 Hours 48 Minutes)

**CRS to STRAX:** 240 Blocks (16 Second Block Time x 240 Blocks = 3840 Seconds ÷ 60 = 64 Minutes)

Once 500 Blocks have passed after making a Cross-Chain Transfer from STRAX to CRS you will see the CRS Balance appear in your wallet.

.. image:: CirrusCore.png
     :width: 900px
     :alt: Cirrus Core Dashboard
     :align: center

Deploying a Smart Contract on Cirrus
====================================
You are now in a position whereby you have the following.

•	A Smart Contract in C#
•	The Smart Contract ByteCode
•	The Smart Contract Hash
•	A Cirrus Token Balance

This tutorial will continue with the assumption that you have also received sufficient votes from the Sidechain Masternodes to approve the deployment and execution of your Smart Contract. This will be evidenced by the Pull Request being merged to the repository.

Within Cirrus Core, navigate to the Smart Contracts tab.

.. image:: CirrusCore-Create.png
     :width: 900px
     :alt: Cirrus Core Create
     :align: center

You can now populate this page with information relative to the developed Smart Contract.

**Amount:** 0 (No funds being sent, so the amount can be set to 0)

**Fee:** 0.01 (A fee of 0.01 will allow the transaction to be mined successfully)

**Gas Price:** 100 (The amount of ‘satoshis’ to pay for each unit of gas spent. 100 is the minimum)

**Gas Limit:** 100000 (The maximum possible gas the contract can spend. This is the maximum)

In addition, you also need to specify the parameters of the contract, this will make the deployment of the contract unique.

The contract handles three parameters for deployment.

•	**Token Supply** (ULong)
•	**Token Name** (String)
•	**Token Symbol** (String)

Finally, you add the ByteCode that was retrieved earlier in the document and enter the password for the wallet.

.. image:: CirrusCore-Create2.png
     :width: 900px
     :alt: Cirrus Core Create2
     :align: center

After ensuring your parameters are set correctly, select the Create Contract button to deploy the contract.

Querying a Smart Contract on Cirrus
====================================
The deployed contract will be included in the next block, once the transaction containing the Smart Contract is propagated to other nodes on the network. A successful deployment will be evidenced by history within the Smart Contracts tab.

.. image:: CirrusCore-SC.png
     :width: 900px
     :alt: Cirrus Core SC
     :align: center

By selecting the hash of the contract, you can view further detail regarding the Smart Contract deployment.

The address of the deployed contract will also be displayed as a value of the *newContractAddress* property.

.. image:: CirrusCore-Receipt.png
     :width: 900px
     :alt: Cirrus Core Receipt
     :align: center

You can now utilize the Call Contract functionality within Cirrus Core to interact with the contract you just deployed.

.. image:: CirrusCore-Call.png
     :width: 900px
     :alt: Cirrus Core Call
     :align: center

To retrieve the balance, you can use the GetBalance method, specifying an address as a parameter for the balance you wish to retrieve.

.. image:: CirrusCore-Call2.png
     :width: 900px
     :alt: Cirrus Core Call2
     :align: center

Select the Call Contract button to query the contract

.. image:: CirrusCore-Receipt2.png
     :width: 900px
     :alt: Cirrus Core Receipt2
     :align: center

The above action will generate a transaction querying the balance of the address provided. You will then be returned a receipt that contains the relevant information relating to the operation that was made.

In this instance you can see that the returnValue equates to the balance of the address specified; 100,000,000.
