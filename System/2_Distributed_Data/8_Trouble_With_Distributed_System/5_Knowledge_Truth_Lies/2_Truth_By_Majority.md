# Distributed Systems: Truth, Quorums, and Fencing

## The Truth Is Defined by the Majority

Imagine a network with an **asymmetric fault**: a node is able to receive all messages sent to it, but any outgoing messages from that node are dropped or delayed. Even though that node is working perfectly well and is receiving requests from other nodes, the other nodes cannot hear its responses.

After some timeout, the other nodes declare it dead, because they haven’t heard from the node. The situation unfolds like a nightmare: the semi-disconnected node is dragged to the graveyard, kicking and screaming _“I’m not dead!”_—but since nobody can hear its screaming, the funeral procession continues with stoic determination.

In a slightly less nightmarish scenario, the semi-disconnected node may notice that the messages it is sending are not being acknowledged by other nodes, and so realize that there must be a fault in the network. Nevertheless, the node is wrongly declared dead by the other nodes and cannot do anything about it.

As a third scenario, imagine a node that experiences a long **stop-the-world garbage collection pause**. All of the node’s threads are paused for one minute. The other nodes retry, grow impatient, and eventually declare the node dead. Once GC finishes, the node resumes as if nothing happened. From its perspective, hardly any time passed, but the others have already moved on.

---

## Quorum-Based Decision Making

A **node cannot necessarily trust its own judgment**. A distributed system cannot rely on a single node. Instead, many distributed algorithms rely on a **quorum**, i.e., voting among nodes.

A quorum (commonly a majority) allows the system to continue functioning even if some nodes have failed. For example:

- With 3 nodes, 1 failure can be tolerated
- With 5 nodes, 2 failures can be tolerated

> **Important:** There can only be one majority in the system, so conflicting decisions are prevented.

---

## The Leader and the Lock

Sometimes a system must guarantee **only one of something**, for example:

- Only one leader for a database partition (to avoid split brain)
- Only one client holding a lock on a resource
- Only one user can register a username

Even if a node believes it is the leader, if the quorum has declared it dead, it may have been replaced. Continuing to act as the leader **after being declared dead** can result in inconsistencies.

---

## Example: Data Corruption Due to Incorrect Locking

Suppose a client holds a lock to a file but experiences a long pause. The lock expires, another client acquires it and starts writing. When the original client resumes, it falsely assumes it still holds the lock, causing **data corruption**.


Client 1 (Paused) ↓ lease expires Client 2 acquires lock ↓ writes to file Client 1 resumes ↓ writes to file (invalid) → File corrupted!


---

## Fencing Tokens to Prevent Conflicts

To prevent a client from acting on an **expired lease**, we can use **fencing tokens**.

### How It Works

- Each time a lock is granted, the lock service increments a token.
- The client must include this fencing token with every write.
- The resource validates tokens and **rejects any request** with an older token.

Client 1 gets token 33 Client 1 pauses Client 2 gets token 34 Client 2 writes to storage Client 1 resumes and writes with token 33 → Rejected!

yaml
Copy
Edit



---

### Implementation Tip

If using **ZooKeeper**, use:

- `zxid` (ZooKeeper Transaction ID)
- or `cversion` (Change version of a node)

These are guaranteed to be **monotonically increasing**, and can serve as effective fencing tokens.

> ⚠️ Note: It's the responsibility of the resource (e.g., storage server) to **enforce fencing**, not just the clients.

If your storage system does not support this, consider using a workaround like **including the fencing token in the filename** to avoid accidental overwrite.

---

## Final Note

Having the server enforce fencing logic may seem like extra work, but it ensures **fault tolerance** against buggy or misbehaving clients. It's a strong defensive strategy in the wild world of distributed systems.

