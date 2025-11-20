# Serializable Snapshot Isolation (SSI)

## Overview
Serializable Snapshot Isolation (SSI) is a concurrency control algorithm that provides full serializability with minimal performance overhead compared to snapshot isolation. First described in 2008, it's used in PostgreSQL (since v9.1) and FoundationDB.

## Key Concepts

### Optimistic Concurrency Control
- Transactions execute without blocking
- Checks for conflicts at commit time
- Aborts transactions if serialization violations occur
- Only serializable transactions commit

### Based on Snapshot Isolation
- Reads come from a consistent database snapshot
- No blocking between readers and writers

### Conflict Detection Mechanisms
1. **Detecting stale MVCC reads**
   - Tracks when transactions ignore uncommitted writes
   - Checks if ignored writes committed before transaction commit

2. **Detecting writes affecting prior reads**
   - Uses index-range "tripwires" (like lightweight locks)
   - Notifies transactions when their reads become outdated

## Performance Characteristics
- ✅ Better performance than pessimistic approaches under low contention
- ✅ Excellent for read-heavy workloads (no reader locks)
- ✅ More predictable latency than 2PL
- ❌ Performance degrades under high contention (many aborts)
- ❌ Requires read-write transactions to be relatively short

## Comparison Table

| Approach          | Type         | Pros                          | Cons                          |
|-------------------|--------------|-------------------------------|-------------------------------|
| Two-phase locking | Pessimistic  | Strong guarantees             | Poor performance, deadlocks   |
| Serial execution  | Pessimistic  | Simple, strong guarantees     | Single-core bottleneck        |
| SSI               | Optimistic   | Good performance, scalable    | Aborts under high contention  |

## Implementations
- **PostgreSQL**: SSI available since v9.1 as serializable isolation level
- **FoundationDB**: Uses distributed version of SSI algorithm
- **Others**: Becoming more common in modern database systems

## Advantages Over Alternatives
- No blocking between readers and writers
- More scalable than serial execution
- Lower overhead than two-phase locking
- Maintains true serializability unlike basic snapshot isolation