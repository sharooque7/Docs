# Atomic Commit and Two-Phase Commit (2PC)

## 1. The Need for Distributed Atomic Commit
**Problem**: Ensure multi-node transactions commit atomically (all nodes commit or all abort).  
**Challenges**:
- Network failures may cause partial commits ("yes" on some nodes, "no" on others).
- Once committed, changes cannot be undone (to preserve read-committed isolation).

## 2. Two-Phase Commit (2PC) Protocol

### Key Components
- **Coordinator**: Manages the transaction lifecycle.
- **Participants**: Database nodes executing parts of the transaction.

### Phases
1. **Prepare Phase**  
   - Coordinator sends `prepare` request to all participants.  
   - Participants:  
     - Write all changes to disk (undo logs).  
     - Verify constraints/conflicts.  
     - Reply "yes" (promise to commit) or "no" (abort).  

2. **Commit/Abort Phase**  
   - **If all "yes"**: Coordinator writes `commit` to its log, sends `commit` to participants.  
   - **If any "no"**: Coordinator sends `abort` to all.  
   - Participants finalize based on coordinator's decision.  

### Guarantees
- **Atomicity**: All nodes reach the same decision.  
- **Durability**: Decisions survive crashes via logs.  

## 3. Failure Modes and Limitations

### Participant Failure
- **Before "yes"**: Coordinator aborts.  
- **After "yes"**: Must wait for coordinator's decision (blocking).  

### Coordinator Failure
- **Before prepare**: Safe to abort.  
- **After prepare (in-doubt state)**:  
  - Participants block until coordinator recovers.  
  - Coordinator uses transaction log to resolve pending commits.  

### Limitations
- **Blocking**: Participants may wait indefinitely if coordinator crashes.  
- **Performance**: Multiple disk writes (prepare + commit) increase latency.  
- **No Byzantine tolerance**: Assumes non-malicious nodes.  

## 4. Three-Phase Commit (3PC)
**Goal**: Reduce blocking by adding a `pre-commit` phase.  
**Stages**:  
1. Prepare → 2. Pre-commit → 3. Commit.  
**Limitation**: Still fails in unbounded delay networks (requires perfect failure detection).  

## 5. Practical Use Cases
- **XA Transactions**: Standard for distributed transactions in relational DBs.  
- **Embedded Coordinators**: e.g., Narayana, MSDTC.  

## 6. Comparison with Consensus Algorithms
| Feature          | 2PC               | Paxos/Raft        |
|------------------|-------------------|-------------------|
| **Fault Model**  | Crash-stop        | Crash-stop        |
| **Blocking?**    | Yes (coordinator) | No                |
| **Use Case**     | DB transactions   | Leader election   |

## Key Takeaways
1. **2PC ensures atomicity** but is blocking during coordinator failure.  
2. **Participants surrender autonomy** after voting "yes".  
3. **Real-world systems use 2PC** despite limitations (e.g., XA transactions).  
4. **Alternatives like 3PC exist** but don't solve all problems.  