# Distributed Transactions and Consensus

## 1. The Consensus Problem
**Goal**: Get multiple nodes to agree on a value/decision despite failures.  
**Challenges**:  
- FLP impossibility (no deterministic consensus in async systems with crash faults).  
- Practical workarounds: Timeouts, randomization, partial synchrony.

### Key Use Cases
1. **Leader Election**  
   - Avoid split-brain (e.g., single-leader replication).  
   - Example: ZooKeeper, etcd.
2. **Atomic Commit**  
   - Ensure transactions commit/abort atomically across nodes.  
   - Example: Distributed databases (2PC, 3PC).

---

## 2. Atomic Commit Protocols
### Two-Phase Commit (2PC)
**Phases**:  
1. **Prepare**: Coordinator asks nodes if they can commit.  
   - Nodes reply "Yes" (ready) or "No" (abort).  
2. **Commit/Abort**:  
   - If all say "Yes", coordinator sends commit.  
   - If any says "No", coordinator sends abort.  

**Problems**:  
- Blocking if coordinator fails (requires recovery logs).  
- Not fault-tolerant (violates FLP).  

### Three-Phase Commit (3PC)  
- Adds a **pre-commit** phase to reduce blocking.  
- Still not fully Byzantine-tolerant.  

---

## 3. Consensus Algorithms
### Paxos
- **Role**: Proposers, Acceptors, Learners.  
- **Phases**: Prepare + Accept.  
- **Guarantees**: Safety (no two decided values), liveness with eventual progress.  
- **Complexity**: Hard to implement correctly.  

### Raft
- **Simplified Paxos**: Leader election + log replication.  
- **Stages**:  
  1. Leader election (term-based).  
  2. Log replication (heartbeats).  
- **Used in**: etcd, Consul.  

### PBFT (Byzantine Fault Tolerance)
- Tolerates malicious nodes (`3f + 1` nodes for `f` faults).  
- **Phases**: Pre-prepare, Prepare, Commit.  
- **Overhead**: High (quadratic messages).  

---

## 4. FLP Impossibility & Practical Solutions
**Theorem**: No deterministic consensus in async systems with crash faults.  
**Workarounds**:  
- **Timeouts**: Assume partial synchrony (e.g., Raft).  
- **Randomization**: Probabilistic consensus (e.g., Paxos variants).  

---

## 5. Trade-offs
| Aspect          | 2PC      | Paxos/Raft | PBFT       |
|-----------------|----------|------------|------------|
| Fault Tolerance | Crash    | Crash      | Byzantine  |
| Blocking?       | Yes      | No         | No         |
| Complexity      | Low      | Medium     | High       |
| Use Case        | DB TXNs  | Leader election | Blockchains |

---

## Key Takeaways
1. **Consensus is subtle**: Requires careful handling of failures and timing.  
2. **Atomic commit ≠ Consensus**: 2PC is blocking; Paxos/Raft are non-blocking.  
3. **Byzantine resilience**: Needed only in adversarial environments (e.g., blockchains).  
4. **FLP is not the end**: Practical systems use timeouts/randomization.  