****************************************************
The role of the federation on PoA networks
****************************************************

Setting up a PoA network involves selecting real-world entities, who function as "authorities" and make up the federation. Each federation member controls one node on the network. When a block is created by a federation member, the block is signed using the private key of the authority to `create a signature <https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch06.asciidoc#pay-to-public-key-hash-p2pkh>`_. A hash of the block header is signed to produce the signature. *If the private key's corresponding public key is available along with the header hash, it can be proved that the signer is also the owner of the public key.* Because the public keys of each federation member are available to all nodes on the network, any node can check that a block has been signed by a valid federation member.

 .. image:: PoA.svg
     :width: 906px
     :alt: PoA
     :align: center
	 
In the figure above, the federation has 3 members: Member A, Member B, and Member C. The network has a target spacing of 16 seconds. The figure shows three blocks being added to the chain, one from each member respectively. Member A creates the first of the three blocks, signs it, and then adds it to the blockchain. After 16 seconds have elapsed, Member B signs a block and adds it to the blockchain. Member C adds their block after 32 seconds. After 48 seconds, it is again the turn of Member A to write another block although the figure does not show this.

The following figure shows what happens if Member B is unavailable (offline for example):

 .. image:: PoA_One_Member_Missing.svg
     :width: 906px
     :alt: PoA
     :align: center
	 
In this case, Member C does not create a block any sooner. A consensus rule stipulates that a federation member can only create a block in a time slot allocated to them. The second block is only mined by after 32 seconds by Member C, so after 48 seconds, only two blocks have been mined instead of three. 

Next, let's take a look at the scenario where there is a disagreement between the members. In the above figure, this is, in fact, the reason for Member B's absence, and Member B is mining an alternative chain containing fake transactions:

 .. image:: PoA_Member_B_Rogue.svg
     :width: 906px
     :alt: PoA
     :align: center

However, after 48 seconds, Member B has only succeeded in creating one block as opposed to two. Because there is less chainwork on the chain produced by Member B, the nodes on the network will prefer the correct chain produced by Member A and Member C.


Is there an optimal size for a federation?
========================================================

Larger federations are desirable as long as all of the members participate in block creation. It is better to have less members, if those members maintain a permanent online presence, than have more members whose presence online is intermittent.

The security model of the PoA algorithm relies on 51% of miners being honest. As long as it's true, fake chains will always have less chainwork. Although it is not enforced by the consensus algorithm, the strongest security model is when the number of members in a federation is not divisible by 2: 3,5,7,9 and so on. Having an odd number of federation members means the network will never become deadlocked with 50% of members supporting one chain and the other 50% supporting another chain.


Do federation members receive a reward for mining?
========================================================

Unlike the miners on a PoW or PoS blockchain, the federation members do not receive a reward for mining the blocks. Because of this, federation members do not include coinbase or coinstake transactions in the blocks that they create. However, in the event that smart contracts are involved in the transactions, gas will still be collected by the federation members.