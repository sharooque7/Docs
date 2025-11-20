# Fault-Tolerant Consensus

## 1. Consensus Problem Definition
**Goal**: Have multiple nodes agree on a value despite failures.  
**Formal Properties**:
- **Uniform Agreement**: All nodes decide the same value.
- **Integrity**: No node decides twice.
- **Validity**: Decided value must have been proposed.
- **Termination**: Every non-faulty node eventually decides.

## 2. Consensus vs. Total Order Broadcast
- **Equivalence**: 
  - Total order broadcast = Repeated consensus rounds (one per message).
  - Used by Raft/Paxos/Zab for efficiency.
- **Single-Leader Replication**:
  - Manual leader assignment violates termination.
  - Automatic leader election requires consensus → circular dependency.

## 3. Key Consensus Algorithms
| Algorithm       | Key Features                          | Used In               |
|-----------------|---------------------------------------|-----------------------|
| **Paxos**       | Complex but theoretically optimal     | Google Chubby         |
| **Raft**        | Leader election + log replication     | etcd, Consul          |
| **Zab**         | Epoch-based leader election           | ZooKeeper             |
| **PBFT**        | Tolerates Byzantine faults (≤1/3 bad) | Hyperledger Fabric    |

## 4. Leader Election Mechanics
- **Epoch Numbers**: Monotonically increasing terms (Raft), ballots (Paxos).
- **Quorum Voting**:
  1. Elect leader with majority vote.
  2. Leader proposes values, checks for higher epochs.
- **Safety**: Overlapping quorums prevent split-brain.

## 5. Limitations of Consensus
- **Performance Costs**:
  - Synchronous replication (vs. async in many DBs).
  - Minimum 3 nodes for 1-fault tolerance, 5 for 2.
- **Operational Challenges**:
  - Fixed membership (dynamic variants are complex).
  - Sensitive to network timeouts (false leader elections).
  - Raft's "leader thrashing" under unstable networks.

## 6. Practical Implications
- **Use Cases**:
  - Coordination services (ZooKeeper).
  - Linearizable systems (etcd for Kubernetes).
- **Avoid When**:
  - High throughput needed (use eventual consistency).
  - Geographically distributed clusters (high latency).

## Key Insights
1. Consensus provides **safety** (agreement) + **liveness** (termination if majority alive).
2. **Total order broadcast** is the practical implementation (not single-value consensus).
3. **Leader-based** but more robust than 2PC (quorums + epoch numbers).
4. **Not a silver bullet**: High operational complexity for strong guarantees.