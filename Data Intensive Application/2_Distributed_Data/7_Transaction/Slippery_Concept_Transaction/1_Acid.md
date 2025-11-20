# Transactions: ACID Properties and Implementation

## The ACID Model

### Atomicity
**Definition**: All operations in a transaction succeed or fail together
- Implemented via:
  - Write-ahead logging (WAL)
  - Undo/rollback capabilities
- Key benefit: Prevents partial updates

### Consistency
**Clarification**:
- Not a database property but application responsibility
- Database provides tools (constraints, triggers) to help maintain consistency
- Examples:
  - Foreign key constraints
  - Unique constraints
  - Check constraints

### Isolation
**Levels of Isolation**:

| Isolation Level      | Dirty Reads | Non-Repeatable Reads | Phantoms |
|----------------------|-------------|-----------------------|----------|
| Read Uncommitted     | Possible    | Possible              | Possible |
| Read Committed       | No          | Possible              | Possible |
| Repeatable Read      | No          | No                    | Possible |
| Serializable         | No          | No                    | No       |

**Implementation Techniques**:
- Locking (2PL - Two Phase Locking)
- MVCC (Multi-Version Concurrency Control)
- Optimistic Concurrency Control

### Durability
**Implementation Approaches**:
1. Synchronous disk writes
2. Replication
3. Battery-backed write cache
4. Checksums/error detection

## Transaction Implementation

### Write-Ahead Logging (WAL)
```text
[Transaction Begin]
[Log Record 1: Update row X from value1 to value2]
[Log Record 2: Update row Y from value3 to value4]
[Commit Record]
[Actual Data Page Updates]
```


## Concurrency Control Methods
### Pessimistic:

* Two-Phase Locking (2PL)
    * Growing phase (acquire locks)
    * Shrinking phase (release locks) 

### Optimistic:
* Validation phase
* Rollback if conflicts detected

### Multi-Version (MVCC):
* Maintain multiple versions of data
* Readers see snapshot at transaction start time

## Distributed Transactions
### Challenges
* Network partitions
* Partial failures
* Clock skew

### Two-Phase Commit (2PC)
sequenceDiagram
    Coordinator->>Participant: Prepare
    Participant->>Coordinator: Vote (Yes/No)
    Coordinator->>Participant: Commit/Rollback
    Participant->>Coordinator: Ack

## Limitations
* Blocking protocol
* Single point of failure (coordinator)
* Performance overhead


## Modern Approaches
### Optimistic Alternatives
* Compensating transactions
* Saga pattern
* CRDTs (Conflict-free Replicated Data Types)

### Database-Specific Implementations
* PostgreSQL: SSI (Serializable Snapshot Isolation)
* MySQL: Gap locks for Repeatable Read
* Oracle: Snapshot Isolation as "Serializable"
* MongoDB: Multi-document transactions (since 4.0)