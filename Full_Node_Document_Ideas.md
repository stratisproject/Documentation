1. Proof-of-Stake - A comprehensive explanation of how the Stratis implementation works.

2. Out-of-the-box mining - How does it work in the Full Node? Don’t just repeat the “Mastering Bitcoin” stuff. How would you customise it for your own mining requirements. Show examples.

3. Breakdown of what you see when the node is running - What exactly are the different tips (block tip, consensus tip etc.) and what does everything else the full node spits out mean. The stuff you see when the node runs in the terminal is your only visual input… don’t think its documented so would be cool to make it as immediately useful as possible.

4. Bringing in features - the modular nature of Stratis - talk about what configurations are potentially interesting and how you go about creating a custom build of the full node.

5. The UTXO and the TX in code. Nothing much happens without these so let’s take a close look at them. How were they modified (I’m thinking that they were?) to deploy a smart contract TX. How else could they be modified? Could they be used to represent something that is not a cryptocurrency (not just via the OP_RETURN methodology) or hold multiple “assets”.

6. Using the API and extending it too.

7. How to encrypt information on the blockchain. Don’t rehash what’s out there but emphasise Stratis specific implementations using “Bouncy Castle” etc. Talk about how you can use the encryption libraries to hide custom data.

8. More about how TXs are broadcast round the network. Include material on the methodology by which the network is widened. Could peers be adapted for special cases (become identifiable)? When would this be desirable?

9. How the STRAT protocol adds to the Bitcoin protocol. If useful, provide easy lookup so we can see the code for any part of the protocol implementation.

10. A deeper dive into behaviours - Writing your own behaviour by making use of their plugable nature.

11. How do our wallets come together with the full node? Give a thorough explanation of how this happens and identify the code involved. Could a wallet hold anything else? How would you do that?

12. Validation - describe how we validate both headers and blocks in more detail - how would you modify validation?

13. Can you alter the speed at which blocks are made if desired - could be part of an tutorial in which you can see this happen - link with PoS article (#1)

14. The searching/lookup capabilities on Stratis blockchain - what are they and how could you extend them - Show how the blockchain is interrogated and the algorithms involved.

15. Persistent data storage in the full node - can you configure this (use a different database for example?)

16. Caching - what do we cache, why do we cache it, and can you adjust the storage for this.

17. Chain header tree - elaborate on the logic and “decision making process” that this important part of the code allows.
18. Consensus Manager - how and when would you want to modify consensus - combine with #17
19. How to upgrade the network: building in forks / upgrades via bip9 and BuriedDeployments
20. How is the security of a network affected based on distribution of block producer algorithms: POS/POW/POA?