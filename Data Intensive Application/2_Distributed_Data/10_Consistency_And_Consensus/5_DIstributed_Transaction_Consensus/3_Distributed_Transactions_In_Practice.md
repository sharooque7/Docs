# Distributed Transactions in Practice

## 1. Types of Distributed Transactions
| Type                     | Description                                  | Example Systems          |
|--------------------------|----------------------------------------------|--------------------------|
| **Database-Internal**    | Nodes run same DB software; optimized protocol | VoltDB, MySQL Cluster   |
| **Heterogeneous (XA)**   | Cross different tech stacks; uses 2PC         | PostgreSQL + MSMQ       |

## 2. XA Transactions
- **Standard**: X/Open XA API for cross-system 2PC.
- **Implementation**:
  - Coordinator (often embedded in app process).
  - Participants (DBs/message brokers via XA-enabled drivers).
- **Recovery**: Coordinator uses disk log to resolve in-doubt transactions after crashes.

### Limitations
- **Blocking**: Participants hold locks during in-doubt phase → system-wide delays.
- **Orphaned Transactions**: Manual intervention required if coordinator logs are lost.
- **Heuristic Decisions**: Emergency overrides break atomicity guarantees.

## 3. Operational Challenges
- **Performance**: 10x+ slower than single-node transactions (due to disk syncs + network round-trips).
- **Availability**:
  - Coordinator = single point of failure.
  - App servers become stateful (coordinator logs are critical state).
- **Deadlocks**: No cross-system detection.
- **Failure Amplification**: One failed participant aborts entire transaction.

## 4. Alternatives to XA/2PC
1. **Exactly-Once Message Processing**  
   - Deduplication + idempotent operations (Chapter 11).  
2. **Event Sourcing**  
   - Append-only logs + deterministic processing (Chapter 12).  
3. **Sagas**  
   - Sequence of local transactions with compensation.  

## Key Takeaways
1. **Database-internal** distributed transactions work well; **heterogeneous** (XA) are problematic.
2. **XA’s blocking nature** makes it unsuitable for high-availability systems.
3. **Modern architectures** avoid XA by using:
   - Domain-specific solutions (e.g., Kafka transactions).
   - Eventually consistent patterns.