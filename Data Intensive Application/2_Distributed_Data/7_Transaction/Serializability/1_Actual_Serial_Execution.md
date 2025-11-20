# Serializability in Database Systems

## The Problem with Weak Isolation Levels

- **Complexity**: Isolation levels are hard to understand and inconsistently implemented across databases
- **Safety Uncertainty**: Difficult to determine if application code is safe at a given isolation level
- **Detection Challenges**: 
  - No good tools exist to detect race conditions
  - Testing is hard due to non-deterministic nature
  - Static analysis remains impractical

## Serializability as the Solution

> "The answer from researchers has been simple: use serializable isolation!"

- **Strongest isolation level** guarantee
- **Eliminates all race conditions**
- **Equivalent outcome** to serial execution
- **Three implementation techniques**:
  1. Actual Serial Execution
  2. Two-Phase Locking (2PL)
  3. Serializable Snapshot Isolation (SSI)

## 1. Actual Serial Execution

### Key Characteristics
- Executes transactions sequentially on a single thread
- Became feasible due to:
  - Cheap RAM enabling in-memory datasets
  - OLTP transactions being short with few reads/writes

### Implementation Examples
- VoltDB/H-Store
- Redis 
- Datomic

### Architectural Requirements
- **Stored procedures** instead of interactive transactions
  - Entire transaction code submitted at once
  - Avoids network latency between statements
- **Modern approaches** use general-purpose languages:
  - Java/Groovy (VoltDB)
  - Clojure (Datomic)
  - Lua (Redis)

### Performance Considerations
- **Single-threaded throughput** limited to one CPU core
- **Memory requirements**: Active dataset must fit in RAM
- **Write throughput** must match single-core capacity

### Scaling Through Partitioning
| Approach | Characteristics | Performance Impact |
|----------|----------------|--------------------|
| Single-partition | Transactions access one partition | Linear scalability |
| Cross-partition | Requires coordination across partitions | ~1,000 TPS (VoltDB) |

## 2. Two-Phase Locking (2PL)
*(Covered in detail in other sections)*

## 3. Serializable Snapshot Isolation (SSI)
*(Covered in detail in other sections)*

## Practical Considerations

### Stored Procedure Challenges
- Historically vendor-specific languages (PL/SQL, T-SQL)
- Management difficulties:
  - Harder to debug and test
  - Version control complications
  - Monitoring integration challenges

### Determinism Requirements
- Critical for replication in systems like VoltDB
- Special APIs needed for time-sensitive operations

## When Serial Execution Works Best

✔ **Short-lived transactions**  
✔ **In-memory datasets**  
✔ **Partitionable workloads**  
✔ **Predictable access patterns**

## Limitations

✖ **Throughput ceiling** for write-heavy workloads  
✖ **Cross-partition** performance penalty  
✖ **Memory-bound** active datasets